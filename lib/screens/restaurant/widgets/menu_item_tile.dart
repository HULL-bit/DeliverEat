import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/l10n/gen/app_localizations.dart';
import '../../../core/utils/formatters.dart';
import '../../../models/menu_item.dart';
import '../../../models/restaurant.dart';
import '../../../providers/cart_provider.dart';
import '../../../widgets/network_image_x.dart';
import '../restaurant_detail_screen.dart';

/// Ligne de menu : image, nom, description, prix, et bouton
/// d'ajout/stepper de quantité synchronisé avec le panier.
class MenuItemTile extends StatelessWidget {
  const MenuItemTile({super.key, required this.item, required this.restaurant});

  final MenuItem item;
  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    final quantity = context.select<CartProvider, int>((c) => c.quantityOf(item.id));
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NetworkImageX(url: item.imageUrlResolved, width: 76, height: 76, borderRadius: BorderRadius.circular(14)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: Theme.of(context).textTheme.titleSmall),
                if (item.description != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    item.description!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 6),
                Text(Formatters.priceFcfa(item.price), style: Theme.of(context).textTheme.labelLarge),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (!item.available)
            const SizedBox.shrink()
          else if (quantity == 0)
            IconButton.filled(
              onPressed: !restaurant.isOpen ? null : () => addMenuItemToCart(context, item: item, restaurant: restaurant),
              icon: const Icon(Icons.add_rounded),
            )
          else
            _QuantityStepper(item: item, quantity: quantity),
        ],
      ),
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  const _QuantityStepper({required this.item, required this.quantity});

  final MenuItem item;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(color: scheme.primaryContainer, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove_rounded, size: 18),
            tooltip: l10n.cartDecreaseQuantity,
            onPressed: () => context.read<CartProvider>().decrementQuantity(item.id),
          ),
          Text('$quantity', style: Theme.of(context).textTheme.labelLarge),
          IconButton(
            icon: const Icon(Icons.add_rounded, size: 18),
            tooltip: l10n.cartIncreaseQuantity,
            onPressed: () => context.read<CartProvider>().incrementQuantity(item.id),
          ),
        ],
      ),
    );
  }
}
