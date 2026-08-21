import 'package:dio/dio.dart';

import '../core/network/api_exception.dart';
import '../core/network/dio_client.dart';
import '../models/restaurant.dart';

/// Seul point d'appel réseau pour les favoris.
class FavoriteService {
  FavoriteService(this._client);

  final DioClient _client;
  Dio get _dio => _client.dio;

  Future<List<Restaurant>> getFavorites() async {
    try {
      final response = await _dio.get<dynamic>('/me/favorites');
      final data = response.data;
      final rawList = data is Map<String, dynamic> ? data['data'] as List<dynamic> : data as List<dynamic>;
      return rawList.map((e) => Restaurant.fromJson(e as Map<String, dynamic>)).toList(growable: false);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<void> addFavorite(String restaurantId) async {
    try {
      await _dio.post<void>('/me/favorites/$restaurantId');
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<void> removeFavorite(String restaurantId) async {
    try {
      await _dio.delete<void>('/me/favorites/$restaurantId');
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
