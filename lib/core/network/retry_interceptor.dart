import 'dart:async';

import 'package:dio/dio.dart';

/// Repli automatique et discret sur les erreurs transitoires.
///
/// - 429 `RATE_LIMITED` : l'API limite à 120 req/min. On patiente un court
///   backoff (respectant l'en-tête `Retry-After` s'il est présent) puis on
///   rejoue la requête, sans jamais spammer le serveur. Sûr pour toutes les
///   méthodes : un 429 signifie que la requête n'a pas été traitée.
/// - Erreurs réseau transitoires (timeout, connexion coupée) : seules les
///   requêtes idempotentes (GET) sont rejouées, pour ne jamais risquer un
///   effet de bord dupliqué (ex: passer une commande deux fois).
///
/// Le nombre de tentatives est borné ([_maxRetries]) pour rester "un petit
/// backoff", jamais une boucle de nouvelles requêtes inutiles.
class RetryInterceptor extends Interceptor {
  RetryInterceptor(this._retryDio);

  final Dio _retryDio;

  static const _maxRetries = 2;

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;
    final retryCount = (err.requestOptions.extra['retryCount'] as int?) ?? 0;
    final isRateLimited = statusCode == 429;
    final isTransientNetwork = err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout;
    final isIdempotent = err.requestOptions.method.toUpperCase() == 'GET';

    final shouldRetry = retryCount < _maxRetries && (isRateLimited || (isTransientNetwork && isIdempotent));
    if (!shouldRetry) {
      handler.next(err);
      return;
    }

    await Future.delayed(_backoffDelay(retryCount, isRateLimited: isRateLimited, response: err.response));

    try {
      final options = err.requestOptions..extra['retryCount'] = retryCount + 1;
      final response = await _retryDio.fetch<dynamic>(options);
      handler.resolve(response);
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  Duration _backoffDelay(int retryCount, {required bool isRateLimited, Response<dynamic>? response}) {
    if (isRateLimited) {
      final retryAfter = response?.headers.value('retry-after');
      final seconds = retryAfter != null ? int.tryParse(retryAfter) : null;
      if (seconds != null && seconds > 0) return Duration(seconds: seconds);
    }
    // Petit backoff exponentiel : 500 ms puis 1200 ms.
    return Duration(milliseconds: 500 + retryCount * 700);
  }
}
