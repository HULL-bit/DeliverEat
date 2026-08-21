import 'package:dio/dio.dart';

import '../core/network/api_exception.dart';
import '../core/network/dio_client.dart';
import '../models/order.dart';
import '../models/order_item.dart';
import '../models/paginated.dart';

/// Seul point d'appel réseau pour les commandes.
class OrderService {
  OrderService(this._client);

  final DioClient _client;
  Dio get _dio => _client.dio;

  Future<Order> createOrder({
    required String restaurantId,
    required List<OrderItem> items,
    required String deliveryAddress,
    String? notes,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/orders',
        data: {
          'restaurantId': restaurantId,
          'items': items.map((e) => e.toOrderPayload()).toList(),
          'deliveryAddress': deliveryAddress,
          if (notes != null && notes.isNotEmpty) 'notes': notes,
        },
      );
      return Order.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<Paginated<Order>> getOrders({String? status, required int page, required int limit}) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/orders',
        queryParameters: {
          if (status != null && status.isNotEmpty) 'status': status,
          'page': page,
          'limit': limit,
        },
      );
      return Paginated.fromJson(response.data!, Order.fromJson);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<Order> getOrderDetail(String id) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/orders/$id');
      return Order.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<Order> cancelOrder(String id) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>('/orders/$id/cancel');
      return Order.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
