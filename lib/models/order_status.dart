/// Statuts possibles d'une commande, dans l'ordre de progression attendu.
enum OrderStatus { pending, confirmed, preparing, delivering, delivered, cancelled }

/// Parse le statut renvoyé par l'API (chaîne libre) vers [OrderStatus].
OrderStatus orderStatusFromApi(String value) => switch (value.toLowerCase()) {
      'pending' => OrderStatus.pending,
      'confirmed' => OrderStatus.confirmed,
      'preparing' => OrderStatus.preparing,
      'delivering' => OrderStatus.delivering,
      'delivered' => OrderStatus.delivered,
      'cancelled' || 'canceled' => OrderStatus.cancelled,
      _ => OrderStatus.pending,
    };

extension OrderStatusX on OrderStatus {
  String get apiValue => name;

  /// Position dans la frise de progression (hors annulation, qui sort du flux).
  int get stepIndex => switch (this) {
        OrderStatus.pending => 0,
        OrderStatus.confirmed => 1,
        OrderStatus.preparing => 2,
        OrderStatus.delivering => 3,
        OrderStatus.delivered => 4,
        OrderStatus.cancelled => -1,
      };
}
