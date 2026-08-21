import 'package:dio/dio.dart';

import '../config/app_config.dart';
import '../constants/app_constants.dart';
import '../storage/secure_storage.dart';
import 'auth_interceptor.dart';

/// Enveloppe le client HTTP unique de l'application.
///
/// Toute la couche `services/` appelle l'API exclusivement via
/// [DioClient.dio] : aucun widget ni provider n'instancie [Dio]
/// directement. Le rafraîchissement transparent du token est géré par
/// [AuthInterceptor].
class DioClient {
  factory DioClient({SecureStorage? secureStorage}) {
    final storage = secureStorage ?? SecureStorage();

    // Dio "nu" dédié à /auth/refresh : pas d'intercepteur d'auth pour éviter
    // toute boucle si le refresh lui-même répond 401.
    final refreshDio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: AppDurations.connectTimeout,
        receiveTimeout: AppDurations.receiveTimeout,
        contentType: 'application/json',
      ),
    );

    final authInterceptor = AuthInterceptor(secureStorage: storage, refreshDio: refreshDio);

    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: AppDurations.connectTimeout,
        receiveTimeout: AppDurations.receiveTimeout,
        contentType: 'application/json',
      ),
    )..interceptors.add(authInterceptor);

    authInterceptor.attachRetryClient(dio);

    return DioClient._(dio: dio, authInterceptor: authInterceptor, secureStorage: storage);
  }

  DioClient._({required this.dio, required this.authInterceptor, required this.secureStorage});

  final Dio dio;
  final AuthInterceptor authInterceptor;
  final SecureStorage secureStorage;
}
