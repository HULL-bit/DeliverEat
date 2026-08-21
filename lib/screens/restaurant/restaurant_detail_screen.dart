import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/gen/app_localizations.dart';
import '../../core/network/api_exception.dart';
import '../../core/routing/app_router.dart';
import '../../core/utils/error_messages.dart';
import '../../core/utils/formatters.dart';
import '../../models/menu_item.dart';
import '../../models/restaurant.dart';
import '../../providers/cart_provider.dart';
import '../../providers/favorite_provider.dart';
import '../../providers/restaurant_detail_provider.dart';
import '../../services/restaurant_service.dart';
import '../../widgets/cart_bar.dart';
import '../../widgets/error_retry.dart';
import '../../widgets/network_image_x.dart';
import '../../widgets/rating_stars.dart';
import 'widgets/menu_item_tile.dart';
import 'widgets/review_list.dart';
import 'widgets/review_sheet.dart';

/// Fiche restaurant : en-tête, menu regroupé par section, avis paginés.
///
/// [heroRestaurant] (la carte d'origine) est affiché immédiatement pendant
/// que le détail complet (avec menu) se charge, pour une continuité visuelle
/// sans écran blanc.
class RestaurantDetailScreen extends StatelessWidget {
  const RestaurantDetailScreen({super.key, required this.restaurantId, this.heroRestaurant});

  final String restaurantId;
  final Restaurant? heroRestaurant;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (c) => RestaurantDetailProvider(c.read<RestaurantService>(), restaurantId: restaurantId),
      child: _RestaurantDetailView(heroRestaurant: heroRestaurant),
    );
  }
}

class _RestaurantDetailView extends StatelessWidget {
  const _RestaurantDetailView({this.heroRestaurant});

  final Restaurant? heroRestaurant;

  @override
  Widget build(BuildContext context) {
    final detailState = context.watch<RestaurantDetailProvider>().detailState;
    final restaurant = detailState.data ?? heroRestaurant;
    final l10n = AppLocalizations.of(context);

    if (restaurant == null && detailState.isError) {
      return Scaffold(
        appBar: AppBar(),
        body: ErrorRetry(
          message: detailState.message ?? '',
          onRetry: () => context.read<RestaurantDetailProvider>().reload(),
        ),
      );
    }
    if (restaurant == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                _Header(restaurant: restaurant),
                SliverToBoxAdapter(child: _Info(restaurant: restaurant)),
                SliverToBoxAdapter(child: _MenuSection(restaurant: restaurant)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
                    child: ReviewList(restaurantId: restaurant.id),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: CartBar(onTap: () => Navigator.of(context).pushNamed(AppRoutes.cart)),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showReviewSheet(context, restaurantId: restaurant.id),
        icon: const Icon(Icons.rate_review_outlined),
        label: Text(l10n.restaurantAddReview),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.restaurant});

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    final isFavorite = context.select<FavoriteProvider, bool>((p) => p.isFavorite(restaurant.id));
    final scheme = Theme.of(context).colorScheme;

    return SliverAppBar(
      expandedHeight: 240,
      pinned: true,
      leading: const _CircleIconButton(icon: Icons.arrow_back_rounded),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: _CircleIconButton(
            icon: isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            color: isFavorite ? scheme.error : null,
            onTap: () {
              HapticFeedback.selectionClick();
              context.read<FavoriteProvider>().toggle(restaurant);
            },
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            NetworkImageX(url: restaurant.imageUrlResolved),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black45],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, this.onTap, this.color});

  final IconData icon;
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: CircleAvatar(
        backgroundColor: Colors.black.withValues(alpha: 0.35),
        child: IconButton(
          icon: Icon(icon, color: color ?? Colors.white, size: 20),
          onPressed: onTap ?? () => Navigator.of(context).maybePop(),
        ),
      ),
    );
  }
}

class _Info extends StatelessWidget {
  const _Info({required this.restaurant});

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(restaurant.name, style: Theme.of(context).textTheme.headlineSmall)),
              if (!restaurant.isOpen)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: scheme.error, borderRadius: BorderRadius.circular(8)),
                  child: Text(l10n.restaurantClosedBadge, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              RatingStars(rating: restaurant.rating),
              const SizedBox(width: 4),
              Text('(${restaurant.ratingCount})', style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(width: 16),
              Icon(Icons.schedule_rounded, size: 14, color: scheme.onSurfaceVariant),
              const SizedBox(width: 3),
              Text(l10n.restaurantMinutes(restaurant.deliveryTimeMax), style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(width: 16),
              Icon(Icons.moped_rounded, size: 14, color: scheme.onSurfaceVariant),
              const SizedBox(width: 3),
              Text(Formatters.priceFcfa(restaurant.deliveryFee), style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
          if (restaurant.description != null) ...[
            const SizedBox(height: 12),
            Text(restaurant.description!, style: Theme.of(context).textTheme.bodyMedium),
          ],
          if (restaurant.address != null) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.place_outlined, size: 14, color: scheme.onSurfaceVariant),
                const SizedBox(width: 4),
                Text(restaurant.address!, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ],
          const Divider(height: 32),
        ],
      ),
    );
  }
}

class _MenuSection extends StatelessWidget {
  const _MenuSection({required this.restaurant});

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    final menu = restaurant.menu ?? const <MenuItem>[];
    final l10n = AppLocalizations.of(context);

    if (menu.isEmpty) return const SizedBox.shrink();

    final sections = <String, List<MenuItem>>{};
    for (final item in menu) {
      sections.putIfAbsent(item.section, () => []).add(item);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.restaurantMenuTitle, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          for (final entry in sections.entries) ...[
            Text(entry.key, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            for (var i = 0; i < entry.value.length; i++)
              MenuItemTile(item: entry.value[i], restaurant: restaurant)
                  .animate()
                  .fadeIn(delay: (20 * i).ms, duration: 250.ms),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}

/// Ajoute [item] au panier ; en cas de conflit de restaurant, propose la
/// boîte de dialogue "vider le panier / annuler" (règle métier : une
/// commande = un seul restaurant).
Future<void> addMenuItemToCart(BuildContext context, {required MenuItem item, required Restaurant restaurant}) async {
  final cart = context.read<CartProvider>();
  final l10n = AppLocalizations.of(context);
  final result = cart.addItem(
    item,
    restaurantId: restaurant.id,
    restaurantName: restaurant.name,
    deliveryFee: restaurant.deliveryFee,
  );

  if (result == CartAddResult.restaurantConflict) {
    final previousName = cart.restaurantName ?? '';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.restaurantSwitchTitle),
        content: Text(l10n.restaurantSwitchBody(previousName)),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l10n.commonCancel)),
          FilledButton(onPressed: () => Navigator.of(context).pop(true), child: Text(l10n.restaurantSwitchConfirm)),
        ],
      ),
    );
    if (confirmed == true) {
      cart.clearAndAdd(item, restaurantId: restaurant.id, restaurantName: restaurant.name, deliveryFee: restaurant.deliveryFee);
    }
    return;
  }

  HapticFeedback.lightImpact();
}

/// Enregistre/retire un favori et affiche une erreur claire en cas d'échec.
Future<void> toggleFavoriteSafely(BuildContext context, Restaurant restaurant) async {
  try {
    await context.read<FavoriteProvider>().toggle(restaurant);
  } on ApiException catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ErrorMessages.from(context, e))));
  }
}
