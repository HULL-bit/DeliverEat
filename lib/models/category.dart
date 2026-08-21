import '../core/utils/image_url.dart';

/// Catégorie de restaurants/plats (100% pilotée par l'API).
class Category {
  const Category({
    required this.id,
    required this.name,
    required this.emoji,
    this.imagePath,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json['id'] as String,
        name: json['name'] as String,
        emoji: json['emoji'] as String? ?? '🍽️',
        imagePath: json['imageUrl'] as String?,
      );

  final String id;
  final String name;
  final String emoji;
  final String? imagePath;

  String? get imageUrlResolved => imageUrl(imagePath);
}
