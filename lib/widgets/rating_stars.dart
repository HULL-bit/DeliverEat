import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

/// Affichage compact d'une note (lecture seule).
class RatingStars extends StatelessWidget {
  const RatingStars({super.key, required this.rating, this.size = 16});

  final double rating;
  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star_rounded, size: size, color: scheme.tertiary),
        const SizedBox(width: 3),
        Text(rating.toStringAsFixed(1), style: Theme.of(context).textTheme.labelMedium),
      ],
    );
  }
}

/// Sélecteur de note interactif (formulaire d'avis).
class RatingInput extends StatelessWidget {
  const RatingInput({super.key, required this.rating, required this.onChanged});

  final int rating;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: rating.toDouble(),
      minRating: 1,
      itemCount: 5,
      itemSize: 34,
      allowHalfRating: false,
      glowColor: Theme.of(context).colorScheme.tertiary,
      itemBuilder: (context, _) => Icon(Icons.star_rounded, color: Theme.of(context).colorScheme.tertiary),
      onRatingUpdate: (value) => onChanged(value.round()),
    );
  }
}
