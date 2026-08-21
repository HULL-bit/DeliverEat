/// Ligne de commande (article + quantité au moment de la commande).
class OrderItem {
  const OrderItem({
    required this.menuItemId,
    required this.name,
    required this.quantity,
    required this.unitPrice,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        menuItemId: json['menuItemId'] as String,
        name: json['name'] as String? ?? '',
        quantity: json['quantity'] as int,
        unitPrice: json['unitPrice'] as int? ?? json['price'] as int? ?? 0,
      );

  final String menuItemId;
  final String name;
  final int quantity;
  final int unitPrice;

  int get subtotal => unitPrice * quantity;

  Map<String, dynamic> toOrderPayload() => {
        'menuItemId': menuItemId,
        'quantity': quantity,
      };
}
