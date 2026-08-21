/// Constantes techniques partagées (durées, tailles, limites).
///
/// Ne contient aucune donnée métier (pas de nom de restaurant, de plat...):
/// uniquement des réglages d'UX et de robustesse réseau.
class AppDurations {
  AppDurations._();

  static const searchDebounce = Duration(milliseconds: 400);
  static const connectTimeout = Duration(seconds: 15);
  static const receiveTimeout = Duration(seconds: 15);
  static const wsReconnectDelay = Duration(seconds: 3);
  static const wsPollingFallback = Duration(seconds: 8);
  static const splashMinDuration = Duration(milliseconds: 1400);

  static const animFast = Duration(milliseconds: 200);
  static const animMedium = Duration(milliseconds: 300);
  static const animSlow = Duration(milliseconds: 400);
}

class AppSizes {
  AppSizes._();

  static const int defaultPageLimit = 10;
  static const int maxAvatarSizeBytes = 2 * 1024 * 1024; // 2 Mo
}

/// Clés utilisées pour la persistance locale (secure storage / prefs).
class StorageKeys {
  StorageKeys._();

  static const accessToken = 'delivereat.access_token';
  static const refreshToken = 'delivereat.refresh_token';
  static const themeMode = 'delivereat.theme_mode';
  static const localeCode = 'delivereat.locale_code';
  static const onboardingSeen = 'delivereat.onboarding_seen';
  static const cachedRestaurants = 'delivereat.cached_restaurants';
  static const recentSearches = 'delivereat.recent_searches';
}
