import '../core/utils/image_url.dart';

/// Utilisateur authentifié.
class User {
  const User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatarPath,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
        phone: json['phone'] as String?,
        avatarPath: json['avatarUrl'] as String? ?? json['avatar'] as String?,
      );

  final String id;
  final String name;
  final String email;
  final String? phone;

  /// Chemin brut renvoyé par l'API (relatif, sous `/uploads/...`).
  final String? avatarPath;

  /// URL absolue prête à être affichée, toujours préfixée par [AppConfig.baseUrl].
  String? get avatarUrl => imageUrl(avatarPath);

  User copyWith({String? name, String? phone, String? avatarPath}) => User(
        id: id,
        name: name ?? this.name,
        email: email,
        phone: phone ?? this.phone,
        avatarPath: avatarPath ?? this.avatarPath,
      );
}
