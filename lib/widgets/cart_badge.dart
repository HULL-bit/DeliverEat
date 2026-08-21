import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';

/// Badge numérique qui rebondit à chaque ajout au panier.
///
/// Utilise `context.select` pour ne reconstruire que ce badge (pas tout
/// l'écran) lorsque le nombre d'articles change.
class CartBadge extends StatefulWidget {
  const CartBadge({super.key, required this.child});

  final Widget child;

  @override
  State<CartBadge> createState() => _CartBadgeState();
}

class _CartBadgeState extends State<CartBadge> with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
  late final Animation<double> _bounce = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
  int _previousCount = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final count = context.select<CartProvider, int>((cart) => cart.itemCount);

    if (count > _previousCount && !MediaQuery.of(context).disableAnimations) {
      _controller.forward(from: 0);
    }
    _previousCount = count;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        widget.child,
        if (count > 0)
          Positioned(
            right: -6,
            top: -6,
            child: ScaleTransition(
              scale: Tween(begin: 1.0, end: 1.35).animate(_bounce),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                constraints: const BoxConstraints(minWidth: 18),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.error,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  count > 99 ? '99+' : '$count',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(color: Theme.of(context).colorScheme.onError, height: 1.3),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
