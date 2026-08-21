import 'package:dio/dio.dart';

/// Exception typée mappée depuis le format d'erreur uniforme de l'API :
/// `{ "error": { "code": "...", "message": "..." } }`.
///
/// [code] est le code machine (ex: `EMAIL_TAKEN`, `RATE_LIMITED`) que les
/// providers/écrans peuvent tester pour adapter leur comportement ;
/// [message] est le message brut renvoyé par le serveur, utilisé comme
/// repli si aucune traduction locale n'existe pour ce code (voir
/// `error_messages.dart`).
class ApiException implements Exception {
  const ApiException({
    required this.statusCode,
    required this.code,
    required this.message,
  });

  /// Construit une [ApiException] à partir d'une [DioException].
  factory ApiException.fromDioException(DioException error) {
    final statusCode = error.response?.statusCode ?? 0;
    final data = error.response?.data;

    String code = 'UNKNOWN';
    String message = error.message ?? 'Une erreur est survenue.';

    if (data is Map<String, dynamic>) {
      final errorField = data['error'];
      if (errorField is Map<String, dynamic>) {
        code = (errorField['code'] as String?) ?? _codeFromStatus(statusCode);
        message = (errorField['message'] as String?) ?? message;
      }
    }

    if (statusCode == 0) {
      code = switch (error.type) {
        DioExceptionType.connectionTimeout ||
        DioExceptionType.sendTimeout ||
        DioExceptionType.receiveTimeout =>
          'TIMEOUT',
        DioExceptionType.connectionError => 'NETWORK_ERROR',
        DioExceptionType.cancel => 'CANCELLED',
        _ => code,
      };
    }

    return ApiException(statusCode: statusCode, code: code, message: message);
  }

  final int statusCode;
  final String code;
  final String message;

  static String _codeFromStatus(int statusCode) => switch (statusCode) {
        400 => 'VALIDATION_ERROR',
        401 => 'UNAUTHORIZED',
        404 => 'NOT_FOUND',
        409 => 'CONFLICT',
        422 => 'UNPROCESSABLE',
        429 => 'RATE_LIMITED',
        _ => 'UNKNOWN',
      };

  bool get isNetworkError => code == 'NETWORK_ERROR' || code == 'TIMEOUT';

  @override
  String toString() => 'ApiException($statusCode, $code, $message)';
}
