/// Point de configuration unique de l'application.
///
/// Changer d'environnement (dev, staging, prod) ne doit coûter qu'une
/// modification de [baseUrl] : tout le reste de l'app (client HTTP,
/// WebSocket, helper d'images) en dérive.
class AppConfig {
  AppConfig._();

  /// URL de base de l'API DeliverEat (sans slash final).
  static const String baseUrl = 'https://delivereat.89-167-122-158.sslip.io';

  /// Préfixe commun à toutes les routes REST.
  static const String apiPrefix = '/api';

  /// URL complète du préfixe API (ex: https://host/api).
  static const String apiBaseUrl = '$baseUrl$apiPrefix';

  /// URL de base du WebSocket, dérivée de [baseUrl] (http(s) -> ws(s)).
  static String get wsBaseUrl {
    final uri = Uri.parse(baseUrl);
    final scheme = uri.scheme == 'https' ? 'wss' : 'ws';
    return '$scheme://${uri.authority}/ws';
  }

  /// Construit l'URL du WebSocket avec le token d'accès courant.
  static String wsUrl(String accessToken) =>
      '$wsBaseUrl?token=${Uri.encodeQueryComponent(accessToken)}';

  /// Compte de démonstration fourni par l'énoncé.
  static const String demoEmail = 'demo@delivereat.app';
  static const String demoPassword = 'password123';
}
