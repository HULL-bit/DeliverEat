import 'dart:async';

import 'package:dio/dio.dart';

import '../storage/secure_storage.dart';

/// Intercepteur d'authentification.
///
/// - Injecte le header `Authorization: Bearer <token>` sur chaque requête
///   (sauf celles marquées `extra['skipAuth'] = true`, ex: login/register).
/// - Sur une erreur 401 dont le code métier est `TOKEN_EXPIRED`, déclenche
///   un rafraîchissement du token via `/auth/refresh`, rejoue la requête
///   d'origine de façon transparente, puis restitue la réponse à l'appelant
///   initial comme si de rien n'était.
/// - Verrou "single-flight" : si plusieurs requêtes échouent en même temps
///   avec un token expiré, un seul appel à `/auth/refresh` est effectué : les
///   autres attendent le même [Future] au lieu de consommer chacune un
///   refresh token rotatif à usage unique.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({required SecureStorage secureStorage, required Dio refreshDio})
      : _secureStorage = secureStorage,
        _refreshDio = refreshDio;

  final SecureStorage _secureStorage;
  final Dio _refreshDio;

  /// Le client Dio "principal" est injecté après sa propre construction
  /// (il se référence lui-même via son intercepteur) pour rejouer les
  /// requêtes échouées sans dépendance circulaire à la création.
  Dio? _retryDio;

  /// Appelé lorsque le refresh échoue définitivement : le provider d'auth
  /// s'y abonne pour déconnecter proprement l'utilisateur.
  void Function()? onSessionExpired;

  Completer<String?>? _refreshCompleter;

  void attachRetryClient(Dio dio) => _retryDio = dio;

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.extra['skipAuth'] != true) {
      final token = await _secureStorage.readAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;
    final code = _errorCode(err.response);
    final alreadyRetried = err.requestOptions.extra['retried'] == true;
    final retryDio = _retryDio;

    final shouldRefresh = statusCode == 401 && code == 'TOKEN_EXPIRED' && !alreadyRetried && retryDio != null;
    if (!shouldRefresh) {
      handler.next(err);
      return;
    }

    final newAccessToken = await _refreshToken();
    if (newAccessToken == null) {
      onSessionExpired?.call();
      handler.next(err);
      return;
    }

    try {
      final retryOptions = err.requestOptions;
      retryOptions.extra['retried'] = true;
      retryOptions.headers['Authorization'] = 'Bearer $newAccessToken';
      final response = await retryDio.fetch<dynamic>(retryOptions);
      handler.resolve(response);
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  /// Verrou single-flight autour de l'appel à `/auth/refresh`.
  Future<String?> _refreshToken() {
    final inFlight = _refreshCompleter;
    if (inFlight != null) return inFlight.future;

    final completer = Completer<String?>();
    _refreshCompleter = completer;
    unawaited(
      _performRefresh().then(completer.complete).catchError((_) {
        completer.complete(null);
      }).whenComplete(() {
        _refreshCompleter = null;
      }),
    );
    return completer.future;
  }

  Future<String?> _performRefresh() async {
    final refreshToken = await _secureStorage.readRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) return null;

    try {
      final response = await _refreshDio.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
        options: Options(extra: {'skipAuth': true}),
      );
      final data = response.data;
      final newAccess = data?['accessToken'] as String?;
      final newRefresh = data?['refreshToken'] as String?;
      if (newAccess == null || newRefresh == null) return null;
      await _secureStorage.saveTokens(accessToken: newAccess, refreshToken: newRefresh);
      return newAccess;
    } on DioException {
      return null;
    }
  }

  String? _errorCode(Response<dynamic>? response) {
    final data = response?.data;
    if (data is Map<String, dynamic>) {
      final errorField = data['error'];
      if (errorField is Map<String, dynamic>) {
        return errorField['code'] as String?;
      }
    }
    return null;
  }
}
