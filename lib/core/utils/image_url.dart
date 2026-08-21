import '../config/app_config.dart';

/// Résout un chemin d'image renvoyé par l'API vers une URL absolue.
///
/// L'API renvoie des chemins relatifs sous `/uploads/...` : ce helper est le
/// point de passage unique pour les préfixer par [AppConfig.baseUrl]. Une
/// URL déjà absolue (http/https) est retournée telle quelle.
String? imageUrl(String? path) {
  if (path == null || path.isEmpty) return null;
  if (path.startsWith('http://') || path.startsWith('https://')) return path;
  final normalized = path.startsWith('/') ? path : '/$path';
  return '${AppConfig.baseUrl}$normalized';
}
