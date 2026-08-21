import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Bouton primaire avec micro-interaction de pression (scale 0.97 +
/// haptique légère), état de chargement intégré. Point d'entrée unique
/// pour les CTA principaux de l'app.
class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.loading = false,
    this.outlined = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool loading;
  final bool outlined;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  double _scale = 1;

  bool get _enabled => widget.onPressed != null && !widget.loading;

  void _setPressed(bool pressed) {
    if (!_enabled) return;
    setState(() => _scale = pressed ? 0.97 : 1);
  }

  @override
  Widget build(BuildContext context) {
    final child = widget.loading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.4,
              color: widget.outlined ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onPrimary,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[Icon(widget.icon, size: 20), const SizedBox(width: 8)],
              Text(widget.label),
            ],
          );

    final button = widget.outlined
        ? OutlinedButton(onPressed: _enabled ? widget.onPressed : null, child: child)
        : ElevatedButton(onPressed: _enabled ? widget.onPressed : null, child: child);

    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) {
        _setPressed(false);
        if (_enabled) HapticFeedback.lightImpact();
      },
      onTapCancel: () => _setPressed(false),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: button,
      ),
    );
  }
}
