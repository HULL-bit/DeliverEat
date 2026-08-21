import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/l10n/gen/app_localizations.dart';
import '../core/utils/formatters.dart';
import '../providers/cart_provider.dart';

/// Mini-barre panier persistante ("Voir le panier · total FCFA"), affichée
/// au-dessus de la navigation lorsque le panier n'est pas vide.
class CartBar extends StatelessWidget {
  const CartBar({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isEmpty = context.select<CartProvider, bool>((cart) => cart.isEmpty);
    final itemCount = context.select<CartProvider, int>((cart) => cart.itemCount);
    final total = context.select<CartProvider, int>((cart) => cart.total);
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      transitionBuilder: (child, animation) => SizeTransition(
        sizeFactor: animation,
        axisAlignment: -1,
        child: FadeTransition(opacity: animation, child: child),
      ),
      child: isEmpty
          ? const SizedBox.shrink(key: ValueKey('empty'))
          : SafeArea(
              top: false,
              bottom: false,
              child: Material(
                key: const ValueKey('cart-bar'),
                color: scheme.primary,
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: onTap,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: scheme.onPrimary.withValues(alpha: 0.2),
                          child: Text('$itemCount', style: TextStyle(color: scheme.onPrimary, fontWeight: FontWeight.bold, fontSize: 13)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            l10n.cartViewCart,
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(color: scheme.onPrimary),
                          ),
                        ),
                        Text(
                          Formatters.priceFcfa(total),
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(color: scheme.onPrimary, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
