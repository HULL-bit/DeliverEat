/// Avis laissé par un utilisateur sur un restaurant.
class Review {
  const Review({
    required this.id,
    required this.restaurantId,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.userName,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json['id'] as String,
        restaurantId: json['restaurantId'] as String? ?? '',
        rating: json['rating'] as int,
        comment: json['comment'] as String? ?? '',
        createdAt: DateTime.parse(json['createdAt'] as String),
        userName: json['userName'] as String? ?? (json['user'] is Map ? (json['user'] as Map)['name'] as String? : null),
      );

  final String id;
  final String restaurantId;
  final int rating;
  final String comment;
  final DateTime createdAt;
  final String? userName;
}
