import '../core/utils/image_url.dart';

/// Article de menu d'un restaurant.
///
/// Hypothèse documentée (README) : l'API renvoie une liste plate d'articles
/// portant chacun un champ `section` (ex: "Entrées", "Plats", "Boissons")
/// utilisé pour regrouper l'affichage côté client.
class MenuItem {
  const MenuItem({
    required this.id,
    required this.restaurantId,
    required this.name,
    required this.price,
    this.description,
    this.imagePath,
    this.section = 'Menu',
    this.available = true,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) => MenuItem(
        id: json['id'] as String,
        restaurantId: json['restaurantId'] as String? ?? '',
        name: json['name'] as String,
        description: json['description'] as String?,
        price: json['price'] as int,
        imagePath: json['imageUrl'] as String?,
        section: (json['section'] as String?)?.trim().isNotEmpty == true
            ? json['section'] as String
            : 'Menu',
        available: json['available'] as bool? ?? true,
      );

  final String id;
  final String restaurantId;
  final String name;
  final String? description;
  final int price;
  final String? imagePath;
  final String section;
  final bool available;

  String? get imageUrlResolved => imageUrl(imagePath);
}
