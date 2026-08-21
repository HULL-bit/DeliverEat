import 'order_item.dart';
import 'order_status.dart';
import 'status_history.dart';

/// Commande passée par l'utilisateur.
class Order {
  const Order({
    required this.id,
    required this.restaurantId,
    required this.items,
    required this.status,
    required this.deliveryAddress,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.createdAt,
    this.number,
    this.restaurantName,
    this.notes,
    this.estimatedDeliveryAt,
    this.statusHistory = const [],
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    final items = (json['items'] as List<dynamic>? ?? const [])
        .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
    final subtotal = json['subtotal'] as int? ?? items.fold<int>(0, (sum, i) => sum + i.subtotal);
    final deliveryFee = json['deliveryFee'] as int? ?? 0;
    return Order(
      id: json['id'] as String,
      number: json['number'] as String?,
      restaurantId: json['restaurantId'] as String,
      restaurantName: json['restaurantName'] as String? ??
          (json['restaurant'] is Map ? (json['restaurant'] as Map)['name'] as String? : null),
      items: items,
      status: orderStatusFromApi(json['status'] as String),
      deliveryAddress: json['deliveryAddress'] as String? ?? '',
      notes: json['notes'] as String?,
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      total: json['total'] as int? ?? (subtotal + deliveryFee),
      createdAt: DateTime.parse(json['createdAt'] as String),
      estimatedDeliveryAt:
          json['estimatedDeliveryAt'] != null ? DateTime.parse(json['estimatedDeliveryAt'] as String) : null,
      statusHistory: (json['statusHistory'] as List<dynamic>?)
              ?.map((e) => StatusHistoryEntry.fromJson(e as Map<String, dynamic>))
              .toList(growable: false) ??
          const [],
    );
  }

  final String id;
  final String? number;
  final String restaurantId;
  final String? restaurantName;
  final List<OrderItem> items;
  final OrderStatus status;
  final String deliveryAddress;
  final String? notes;
  final int subtotal;
  final int deliveryFee;
  final int total;
  final DateTime createdAt;
  final DateTime? estimatedDeliveryAt;
  final List<StatusHistoryEntry> statusHistory;

  /// Libellé d'affichage : numéro lisible si disponible, sinon id tronqué.
  String get displayNumber => number ?? '#${id.substring(0, id.length.clamp(0, 8))}';

  bool get canCancel => status == OrderStatus.pending;
}
