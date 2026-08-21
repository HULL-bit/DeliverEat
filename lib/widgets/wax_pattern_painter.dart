import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Motif décoratif léger inspiré des tissus wax / bogolan sénégalais :
/// une trame de losanges et de traits obliques, en opacité faible.
///
/// Purement décoratif (splash, en-têtes, séparateurs, états vides) :
/// aucune donnée métier n'y transite. La couleur est toujours injectée
/// depuis le [ColorScheme] appelant, jamais codée en dur.
class WaxPatternPainter extends CustomPainter {
  const WaxPatternPainter({required this.color, this.tileSize = 36});

  final Color color;
  final double tileSize;

  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    final dotPaint = Paint()..color = color;

    final cols = (size.width / tileSize).ceil() + 1;
    final rows = (size.height / tileSize).ceil() + 1;

    for (var row = 0; row < rows; row++) {
      for (var col = 0; col < cols; col++) {
        final cx = col * tileSize;
        final cy = row * tileSize;
        final offset = (row.isOdd) ? tileSize / 2 : 0.0;
        final center = Offset(cx + offset, cy);

        final diamond = Path()
          ..moveTo(center.dx, center.dy - tileSize * 0.28)
          ..lineTo(center.dx + tileSize * 0.28, center.dy)
          ..lineTo(center.dx, center.dy + tileSize * 0.28)
          ..lineTo(center.dx - tileSize * 0.28, center.dy)
          ..close();
        canvas.drawPath(diamond, strokePaint);
        canvas.drawCircle(center, 1.6, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant WaxPatternPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.tileSize != tileSize;
}

/// Fond décoratif prêt à l'emploi appliquant [WaxPatternPainter] en filigrane
/// derrière son [child].
class WaxPatternBackground extends StatelessWidget {
  const WaxPatternBackground({
    super.key,
    required this.child,
    this.opacity = 0.06,
    this.tileSize = 36,
  });

  final Widget child;
  final double opacity;
  final double tileSize;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: IgnorePointer(
            child: Opacity(
              opacity: MediaQuery.of(context).disableAnimations ? opacity * 0.6 : opacity,
              child: CustomPaint(
                painter: WaxPatternPainter(color: scheme.onSurface, tileSize: tileSize),
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}

/// Variante circulaire utilisée en illustration pour les états vides.
class WaxMedallion extends StatelessWidget {
  const WaxMedallion({super.key, required this.icon, this.size = 96});

  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.rotate(
            angle: math.pi / 12,
            child: Container(
              decoration: BoxDecoration(
                color: scheme.primaryContainer.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(size * 0.3),
              ),
            ),
          ),
          Icon(icon, size: size * 0.42, color: scheme.primary),
        ],
      ),
    );
  }
}
