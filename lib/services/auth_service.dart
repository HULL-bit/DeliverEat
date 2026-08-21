import 'package:dio/dio.dart';

import '../core/network/api_exception.dart';
import '../core/network/dio_client.dart';
import '../models/user.dart';

/// Résultat d'une authentification réussie (login/register).
class AuthResult {
  const AuthResult({required this.user, required this.accessToken, required this.refreshToken, required this.expiresIn});

  factory AuthResult.fromJson(Map<String, dynamic> json) => AuthResult(
        user: User.fromJson(json['user'] as Map<String, dynamic>),
        accessToken: json['accessToken'] as String,
        refreshToken: json['refreshToken'] as String,
        expiresIn: json['expiresIn'] as int? ?? 0,
      );

  final User user;
  final String accessToken;
  final String refreshToken;
  final int expiresIn;
}

/// Seul point d'appel réseau pour l'authentification et le profil.
class AuthService {
  AuthService(this._client);

  final DioClient _client;
  Dio get _dio => _client.dio;

  Future<AuthResult> register({required String name, required String email, required String password}) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/register',
        data: {'name': name, 'email': email, 'password': password},
        options: Options(extra: {'skipAuth': true}),
      );
      return AuthResult.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<AuthResult> login({required String email, required String password}) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/login',
        data: {'email': email, 'password': password},
        options: Options(extra: {'skipAuth': true}),
      );
      return AuthResult.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<void> logout(String refreshToken) async {
    try {
      await _dio.post<void>('/auth/logout', data: {'refreshToken': refreshToken});
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<User> me() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/auth/me');
      return User.fromJson(_unwrapUser(response.data!));
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<User> updateMe({String? name, String? phone}) async {
    try {
      final response = await _dio.patch<Map<String, dynamic>>(
        '/auth/me',
        data: {'name': ?name, 'phone': ?phone},
      );
      return User.fromJson(_unwrapUser(response.data!));
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<User> uploadAvatar({required List<int> bytes, required String filename, required String mimeSubtype}) async {
    try {
      final formData = FormData.fromMap({
        'avatar': MultipartFile.fromBytes(bytes, filename: filename, contentType: DioMediaType('image', mimeSubtype)),
      });
      final response = await _dio.post<Map<String, dynamic>>('/auth/me/avatar', data: formData);
      return User.fromJson(_unwrapUser(response.data!));
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// L'API renvoie `{ "user": {...} }` pour /auth/me (GET et PATCH) alors
  /// que /auth/login et /auth/register renvoient l'utilisateur à plat sous
  /// `user` dans une enveloppe différente : ce helper tolère les deux formes.
  Map<String, dynamic> _unwrapUser(Map<String, dynamic> json) =>
      json['user'] is Map<String, dynamic> ? json['user'] as Map<String, dynamic> : json;
}
