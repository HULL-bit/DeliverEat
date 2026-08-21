import 'package:dio/dio.dart';

import '../core/network/api_exception.dart';
import '../core/network/dio_client.dart';
import '../models/category.dart';
import '../models/menu_item.dart';
import '../models/paginated.dart';
import '../models/restaurant.dart';
import '../models/review.dart';

/// Seul point d'appel réseau pour le catalogue (catégories, restaurants,
/// menus, avis).
class RestaurantService {
  RestaurantService(this._client);

  final DioClient _client;
  Dio get _dio => _client.dio;

  Future<List<Category>> getCategories() async {
    try {
      final response = await _dio.get<dynamic>('/categories');
      final data = response.data;
      final rawList = data is Map<String, dynamic> ? data['data'] as List<dynamic> : data as List<dynamic>;
      return rawList.map((e) => Category.fromJson(e as Map<String, dynamic>)).toList(growable: false);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<Paginated<Restaurant>> getRestaurants({
    String? search,
    String? category,
    bool? open,
    String? sort,
    required int page,
    required int limit,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/restaurants',
        queryParameters: {
          if (search != null && search.isNotEmpty) 'search': search,
          if (category != null && category.isNotEmpty) 'category': category,
          'open': ?open,
          if (sort != null && sort.isNotEmpty) 'sort': sort,
          'page': page,
          'limit': limit,
        },
      );
      return Paginated.fromJson(response.data!, Restaurant.fromJson);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<Restaurant> getRestaurantDetail(String id) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/restaurants/$id');
      return Restaurant.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<List<MenuItem>> getMenu(String restaurantId) async {
    try {
      final response = await _dio.get<dynamic>('/restaurants/$restaurantId/menu');
      final data = response.data;
      final rawList = data is Map<String, dynamic> ? data['data'] as List<dynamic> : data as List<dynamic>;
      return rawList.map((e) => MenuItem.fromJson(e as Map<String, dynamic>)).toList(growable: false);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<Paginated<Review>> getReviews(String restaurantId, {required int page, required int limit}) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/restaurants/$restaurantId/reviews',
        queryParameters: {'page': page, 'limit': limit},
      );
      return Paginated.fromJson(response.data!, Review.fromJson);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<Review> postReview(String restaurantId, {required int rating, required String comment}) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/restaurants/$restaurantId/reviews',
        data: {'rating': rating, 'comment': comment},
      );
      return Review.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
