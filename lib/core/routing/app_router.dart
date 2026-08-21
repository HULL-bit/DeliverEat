import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import '../../screens/auth/login_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../../screens/cart/cart_screen.dart';
import '../../screens/checkout/checkout_screen.dart';
import '../../screens/onboarding/onboarding_screen.dart';
import '../../screens/order_tracking/order_tracking_screen.dart';
import '../../screens/profile/profile_edit_screen.dart';
import '../../screens/root/root_shell.dart';
import '../../screens/settings/settings_screen.dart';

/// Noms de routes centralisés et unique point de génération des pages.
///
/// Toutes les navigations "classiques" (hors container-transform des
/// cartes restaurant, géré localement par `OpenContainer`) transitent par
/// [onGenerateRoute] et partagent la même transition fade-through, pour une
/// continuité visuelle cohérente dans toute l'app.
class AppRoutes {
  AppRoutes._();

  static const onboarding = '/onboarding';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const cart = '/cart';
  static const checkout = '/checkout';
  static const orderTracking = '/order-tracking';
  static const settings = '/settings';
  static const profileEdit = '/profile-edit';
}

class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final builder = switch (settings.name) {
      AppRoutes.onboarding => (BuildContext _) => const OnboardingScreen(),
      AppRoutes.login => (BuildContext _) => const LoginScreen(),
      AppRoutes.register => (BuildContext _) => const RegisterScreen(),
      AppRoutes.home => (BuildContext _) => const RootShell(),
      AppRoutes.cart => (BuildContext _) => const CartScreen(),
      AppRoutes.checkout => (BuildContext _) => const CheckoutScreen(),
      AppRoutes.orderTracking => (BuildContext _) => OrderTrackingScreen(orderId: settings.arguments as String),
      AppRoutes.settings => (BuildContext _) => const SettingsScreen(),
      AppRoutes.profileEdit => (BuildContext _) => const ProfileEditScreen(),
      _ => (BuildContext _) => const RootShell(),
    };

    return PageRouteBuilder<dynamic>(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
      transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeThroughTransition(
        animation: animation,
        secondaryAnimation: secondaryAnimation,
        child: child,
      ),
    );
  }
}
