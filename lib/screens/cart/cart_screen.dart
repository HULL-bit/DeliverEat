import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/gen/app_localizations.dart';
import '../../core/routing/app_router.dart';
import '../../core/utils/formatters.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/network_image_x.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.cartTitle)),
      body: cart.isEmpty
          ? EmptyState(icon: Icons.shopping_bag_outlined, title: l10n.cartEmptyTitle, subtitle: l10n.cartEmptySubtitle)
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: cart.items.length,
                    separatorBuilder: (_, _) => const Divider(height: 24),
                    itemBuilder: (context, i) {
                      final item = cart.items[i];
                      return Row(
                        children: [
                          NetworkImageX(url: item.imagePath, width: 64, height: 64, borderRadius: BorderRadius.circular(12)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.name, style: Theme.of(context).textTheme.titleSmall),
                                const SizedBox(height: 4),
                                Text(Formatters.priceFcfa(item.unitPrice), style: Theme.of(context).textTheme.bodySmall),
                              ],
                            ),
                          ),
                          _Stepper(menuItemId: item.menuItemId, quantity: item.quantity),
                        ],
                      ).animate().fadeIn(delay: (30 * i).ms, duration: 250.ms);
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).padding.bottom + 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    border: Border(top: BorderSide(color: Theme.of(context).colorScheme.outlineVariant)),
                  ),
                  child: Column(
                    children: [
                      _SummaryRow(label: l10n.cartSubtotal, value: cart.subtotal),
                      _SummaryRow(label: l10n.cartDeliveryFee, value: cart.deliveryFee),
                      const Divider(height: 20),
                      _SummaryRow(label: l10n.cartTotal, value: cart.total, emphasize: true),
                      const SizedBox(height: 16),
                      AppButton(
                        label: l10n.cartCheckoutButton,
                        onPressed: () => Navigator.of(context).pushNamed(AppRoutes.checkout),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value, this.emphasize = false});

  final String label;
  final int value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final style = emphasize ? Theme.of(context).textTheme.titleMedium : Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(Formatters.priceFcfa(value), style: style?.copyWith(fontWeight: emphasize ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  const _Stepper({required this.menuItemId, required this.quantity});

  final String menuItemId;
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
            onPressed: () => context.read<CartProvider>().decrementQuantity(menuItemId),
          ),
          Text('$quantity', style: Theme.of(context).textTheme.labelLarge),
          IconButton(
            icon: const Icon(Icons.add_rounded, size: 18),
            tooltip: l10n.cartIncreaseQuantity,
            onPressed: () => context.read<CartProvider>().incrementQuantity(menuItemId),
          ),
        ],
      ),
    );
  }
}
