import '../core/utils/image_url.dart';
import 'menu_item.dart';

/// Restaurant du catalogue.
class Restaurant {
  const Restaurant({
    required this.id,
    required this.name,
    required this.rating,
    required this.deliveryTimeMin,
    required this.deliveryTimeMax,
    required this.deliveryFee,
    required this.isOpen,
    this.description,
    this.imagePath,
    this.categoryId,
    this.address,
    this.ratingCount = 0,
    this.menu,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String?,
        imagePath: json['imageUrl'] as String?,
        rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
        ratingCount: json['ratingCount'] as int? ?? 0,
        deliveryTimeMin: json['deliveryTimeMin'] as int? ?? json['deliveryTime'] as int? ?? 0,
        deliveryTimeMax: json['deliveryTimeMax'] as int? ?? json['deliveryTime'] as int? ?? 0,
        deliveryFee: json['deliveryFee'] as int? ?? 0,
        isOpen: json['isOpen'] as bool? ?? true,
        categoryId: json['category'] as String? ?? json['categoryId'] as String?,
        address: json['address'] as String?,
        menu: (json['menu'] as List<dynamic>?)
            ?.map((e) => MenuItem.fromJson(e as Map<String, dynamic>))
            .toList(growable: false),
      );

  final String id;
  final String name;
  final String? description;
  final String? imagePath;
  final double rating;
  final int ratingCount;
  final int deliveryTimeMin;
  final int deliveryTimeMax;
  final int deliveryFee;
  final bool isOpen;
  final String? categoryId;
  final String? address;

  /// Présent uniquement lorsque le restaurant a été chargé via
  /// `GET /restaurants/:id` (détail avec menu inclus).
  final List<MenuItem>? menu;

  String? get imageUrlResolved => imageUrl(imagePath);

  /// Délai de livraison formaté, ex: "25-40" ou "25" si min == max.
  String get deliveryTimeRange =>
      deliveryTimeMin == deliveryTimeMax ? '$deliveryTimeMin' : '$deliveryTimeMin-$deliveryTimeMax';
}
