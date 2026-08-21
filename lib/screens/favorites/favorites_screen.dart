import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/gen/app_localizations.dart';
import '../../models/view_state.dart';
import '../../providers/favorite_provider.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/error_retry.dart';
import '../../widgets/restaurant_card.dart';
import '../../widgets/shimmer_loader.dart';
import '../restaurant/restaurant_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final provider = context.watch<FavoriteProvider>();
    final state = provider.state;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.favoritesTitle)),
      body: RefreshIndicator(
        onRefresh: provider.load,
        child: Builder(builder: (context) {
          if (state.status == ViewStatus.loading && state.data == null) {
            return const RestaurantListShimmer();
          }
          if (state.status == ViewStatus.error && (state.data == null || state.data!.isEmpty)) {
            return ListView(children: [ErrorRetry(message: state.message ?? '', onRetry: provider.load)]);
          }
          final favorites = state.data ?? const [];
          if (favorites.isEmpty) {
            return ListView(
              children: [
                EmptyState(icon: Icons.favorite_border_rounded, title: l10n.favoritesEmptyTitle, subtitle: l10n.favoritesEmptySubtitle),
              ],
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: favorites.length,
            separatorBuilder: (_, _) => const SizedBox(height: 14),
            itemBuilder: (context, i) {
              final restaurant = favorites[i];
              return RestaurantCard(
                restaurant: restaurant,
                openBuilder: (context, close) => RestaurantDetailScreen(restaurantId: restaurant.id, heroRestaurant: restaurant),
              ).animate().fadeIn(delay: (30 * i).ms, duration: 250.ms);
            },
          );
        }),
      ),
    );
  }
}
