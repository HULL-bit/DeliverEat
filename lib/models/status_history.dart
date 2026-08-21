import 'order_status.dart';

/// Entrée d'historique de statut d'une commande.
class StatusHistoryEntry {
  const StatusHistoryEntry({required this.status, required this.timestamp, this.note});

  factory StatusHistoryEntry.fromJson(Map<String, dynamic> json) => StatusHistoryEntry(
        status: orderStatusFromApi(json['status'] as String),
        timestamp: DateTime.parse(
          json['at'] as String? ?? json['timestamp'] as String? ?? json['createdAt'] as String,
        ),
        note: json['note'] as String?,
      );

  final OrderStatus status;
  final DateTime timestamp;
  final String? note;
}
