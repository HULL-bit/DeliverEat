import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../core/l10n/gen/app_localizations.dart';
import '../core/utils/formatters.dart';
import '../models/restaurant.dart';
import '../providers/favorite_provider.dart';
import 'network_image_x.dart';
import 'rating_stars.dart';

/// Carte restaurant utilisée dans les listes (accueil, favoris, recherche).
///
/// La navigation vers la fiche détail passe par [OpenContainer]
/// (container-transform du package `animations`) : l'image et le nom se
/// "déplient" en continu vers l'en-tête de la fiche, sans Hero séparé
/// nécessaire. [openBuilder] est fourni par l'écran appelant pour ne pas
/// coupler ce widget purement présentationnel à un écran précis.
class RestaurantCard extends StatelessWidget {
  const RestaurantCard({
    super.key,
    required this.restaurant,
    required this.openBuilder,
    this.showFavorite = true,
  });

  final Restaurant restaurant;
  final Widget Function(BuildContext context, void Function({Object? returnValue}) closeContainer) openBuilder;
  final bool showFavorite;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);

    return OpenContainer<Object?>(
      closedElevation: 0,
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      openColor: scheme.surface,
      closedColor: scheme.brightness == Brightness.light ? Colors.white : scheme.surfaceContainerHighest,
      transitionDuration: const Duration(milliseconds: 400),
      openBuilder: (context, closeContainer) => openBuilder(context, closeContainer),
      closedBuilder: (context, openContainer) => InkWell(
        onTap: openContainer,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 10,
                  child: NetworkImageX(url: restaurant.imageUrlResolved, width: double.infinity, height: double.infinity),
                ),
                if (!restaurant.isOpen)
                  Positioned(
                    left: 10,
                    top: 10,
                    child: _Badge(label: l10n.restaurantClosedBadge, color: scheme.error),
                  ),
                if (showFavorite)
                  Positioned(right: 8, top: 8, child: _FavoriteButton(restaurant: restaurant)),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      RatingStars(rating: restaurant.rating),
                      const SizedBox(width: 12),
                      Icon(Icons.schedule_rounded, size: 14, color: scheme.onSurfaceVariant),
                      const SizedBox(width: 3),
                      Text(l10n.restaurantMinutes(restaurant.deliveryTimeMax), style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(width: 12),
                      Icon(Icons.moped_rounded, size: 14, color: scheme.onSurfaceVariant),
                      const SizedBox(width: 3),
                      Text(Formatters.priceFcfa(restaurant.deliveryFee), style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _FavoriteButton extends StatefulWidget {
  const _FavoriteButton({required this.restaurant});

  final Restaurant restaurant;

  @override
  State<_FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<_FavoriteButton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 350));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFavorite = context.select<FavoriteProvider, bool>((p) => p.isFavorite(widget.restaurant.id));
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        if (!MediaQuery.of(context).disableAnimations) _controller.forward(from: 0);
        context.read<FavoriteProvider>().toggle(widget.restaurant);
      },
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.35), shape: BoxShape.circle),
        child: ScaleTransition(
          scale: Tween(begin: 1.0, end: 1.4)
              .chain(CurveTween(curve: Curves.elasticOut))
              .animate(_controller),
          child: Icon(
            isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            color: isFavorite ? scheme.error : Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }
}
