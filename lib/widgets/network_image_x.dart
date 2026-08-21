import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Image réseau robuste : cache, skeleton shimmer pendant le chargement,
/// fade-in à l'arrivée, et repli discret en cas d'échec (aucune URL, image
/// cassée...). Point de passage unique pour toutes les images distantes de
/// l'app (photos de restaurants, plats, avatar).
class NetworkImageX extends StatelessWidget {
  const NetworkImageX({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  final String? url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final radius = borderRadius ?? BorderRadius.zero;

    Widget child;
    if (url == null || url!.isEmpty) {
      child = _fallback(scheme);
    } else {
      child = CachedNetworkImage(
        imageUrl: url!,
        width: width,
        height: height,
        fit: fit,
        fadeInDuration: const Duration(milliseconds: 300),
        placeholder: (context, _) => Shimmer.fromColors(
          baseColor: scheme.surfaceContainerHighest,
          highlightColor: scheme.surface,
          child: Container(width: width, height: height, color: scheme.surfaceContainerHighest),
        ),
        errorWidget: (context, _, _) => _fallback(scheme),
      );
    }

    return ClipRRect(borderRadius: radius, child: child);
  }

  Widget _fallback(ColorScheme scheme) => Container(
        width: width,
        height: height,
        color: scheme.surfaceContainerHighest,
        alignment: Alignment.center,
        child: Icon(Icons.restaurant_rounded, color: scheme.onSurfaceVariant.withValues(alpha: 0.5)),
      );
}
