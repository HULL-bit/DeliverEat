import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/l10n/gen/app_localizations.dart';
import 'core/media/media_picker_service.dart';
import 'core/network/dio_client.dart';
import 'core/notifications/notification_service.dart';
import 'core/routing/app_router.dart';
import 'core/storage/secure_storage.dart';
import 'core/theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/connectivity_provider.dart';
import 'providers/favorite_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/order_provider.dart';
import 'providers/restaurant_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/splash/splash_screen.dart';
import 'services/auth_service.dart';
import 'services/favorite_service.dart';
import 'services/order_service.dart';
import 'services/restaurant_service.dart';

/// Racine de l'application : câblage de tous les providers puis
/// [MaterialApp]. C'est le seul endroit où l'arbre de dépendances est
/// construit ; aucun écran n'instancie un service ou un provider lui-même.
class DeliverEatApp extends StatelessWidget {
  const DeliverEatApp({
    super.key,
    required this.prefs,
    required this.secureStorage,
    required this.dioClient,
    required this.notificationService,
    required this.mediaPickerService,
  });

  final SharedPreferences prefs;
  final SecureStorage secureStorage;
  final DioClient dioClient;
  final NotificationService notificationService;
  final MediaPickerService mediaPickerService;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<SecureStorage>.value(value: secureStorage),
        Provider<DioClient>.value(value: dioClient),
        Provider<NotificationService>.value(value: notificationService),
        Provider<MediaPickerService>.value(value: mediaPickerService),
        Provider<AuthService>(create: (c) => AuthService(c.read<DioClient>())),
        Provider<RestaurantService>(create: (c) => RestaurantService(c.read<DioClient>())),
        Provider<OrderService>(create: (c) => OrderService(c.read<DioClient>())),
        Provider<FavoriteService>(create: (c) => FavoriteService(c.read<DioClient>())),
        ChangeNotifierProvider(create: (_) => ThemeProvider(prefs: prefs)),
        ChangeNotifierProvider(create: (_) => LocaleProvider(prefs: prefs)),
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(
          create: (c) => AuthProvider(
            authService: c.read<AuthService>(),
            dioClient: c.read<DioClient>(),
            secureStorage: c.read<SecureStorage>(),
          ),
        ),
        ChangeNotifierProvider(create: (c) => RestaurantProvider(c.read<RestaurantService>(), prefs: prefs)),
        ChangeNotifierProxyProvider<AuthProvider, FavoriteProvider>(
          create: (c) => FavoriteProvider(c.read<FavoriteService>()),
          update: (c, auth, previous) => (previous ?? FavoriteProvider(c.read<FavoriteService>()))..updateAuth(auth),
        ),
        ChangeNotifierProxyProvider<AuthProvider, OrderProvider>(
          create: (c) => OrderProvider(c.read<OrderService>()),
          update: (c, auth, previous) => (previous ?? OrderProvider(c.read<OrderService>()))..updateAuth(auth),
        ),
      ],
      child: Consumer2<ThemeProvider, LocaleProvider>(
        builder: (context, themeProvider, localeProvider, _) {
          return MaterialApp(
            title: 'DeliverEat',
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.mode,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            locale: localeProvider.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            onGenerateRoute: AppRouter.onGenerateRoute,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
