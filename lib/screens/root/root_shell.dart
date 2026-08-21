import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/l10n/gen/app_localizations.dart';
import '../../core/routing/app_router.dart';
import '../../widgets/cart_bar.dart';
import '../../widgets/offline_banner.dart';
import '../favorites/favorites_screen.dart';
import '../home/home_screen.dart';
import '../order_history/order_history_screen.dart';
import '../profile/profile_screen.dart';

/// Coquille principale post-connexion : navigation par onglets (Accueil,
/// Favoris, Commandes, Profil) avec transition "shared axis" horizontale
/// entre onglets, bannière hors ligne persistante et mini-barre panier.
class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _index = 0;

  static const _screens = [
    HomeScreen(),
    FavoritesScreen(),
    OrderHistoryScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const OfflineBanner(),
            Expanded(
              child: PageTransitionSwitcher(
                duration: AppDurations.animMedium,
                transitionBuilder: (child, primaryAnimation, secondaryAnimation) => SharedAxisTransition(
                  animation: primaryAnimation,
                  secondaryAnimation: secondaryAnimation,
                  transitionType: SharedAxisTransitionType.horizontal,
                  fillColor: Theme.of(context).colorScheme.surface,
                  child: child,
                ),
                child: _screens[_index],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
              child: CartBar(onTap: () => Navigator.of(context).pushNamed(AppRoutes.cart)),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: BottomNavigationBar(
          currentIndex: _index,
          onTap: (i) => setState(() => _index = i),
          items: [
            BottomNavigationBarItem(icon: const Icon(Icons.home_rounded), label: l10n.homeTitle),
            BottomNavigationBarItem(icon: const Icon(Icons.favorite_rounded), label: l10n.favoritesTitle),
            BottomNavigationBarItem(icon: const Icon(Icons.receipt_long_rounded), label: l10n.ordersTitle),
            BottomNavigationBarItem(icon: const Icon(Icons.person_rounded), label: l10n.profileTitle),
          ],
        ),
      ),
    );
  }
}
