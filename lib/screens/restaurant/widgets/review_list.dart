import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../core/l10n/gen/app_localizations.dart';
import '../../../core/utils/error_messages.dart';
import '../../../models/view_state.dart';
import '../../../providers/restaurant_detail_provider.dart';
import '../../../widgets/error_retry.dart';
import '../../../widgets/rating_stars.dart';
import '../../../widgets/shimmer_loader.dart';

/// Liste des avis d'un restaurant, avec chargement supplémentaire manuel
/// (bouton "Voir plus") plutôt qu'un défilement infini imbriqué dans le
/// scroll principal de la fiche.
class ReviewList extends StatelessWidget {
  const ReviewList({super.key, required this.restaurantId});

  final String restaurantId;

  String _initial(String? name) => (name == null || name.isEmpty) ? '?' : name.substring(0, 1).toUpperCase();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RestaurantDetailProvider>();
    final state = provider.reviewsState;
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.restaurantReviewsTitle, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        if (state.status == ViewStatus.loading && provider.reviews.isEmpty)
          const ShimmerBox(height: 80)
        else if (state.status == ViewStatus.error && provider.reviews.isEmpty)
          ErrorRetry(
            message: ErrorMessages.resolve(context, code: state.errorCode, fallback: state.message ?? ''),
            onRetry: provider.loadReviews,
          )
        else if (provider.reviews.isEmpty)
          Text(l10n.restaurantNoReviews, style: Theme.of(context).textTheme.bodyMedium)
        else ...[
          for (final review in provider.reviews)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(radius: 16, child: Text(_initial(review.userName))),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(review.userName ?? '', style: Theme.of(context).textTheme.titleSmall),
                            Text(
                              timeago.format(review.createdAt, locale: locale),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      RatingStars(rating: review.rating.toDouble()),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(review.comment, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          if (provider.canLoadMoreReviews)
            Center(
              child: TextButton(
                onPressed: provider.loadMoreReviews,
                child: Text(l10n.commonSeeAll),
              ),
            ),
        ],
      ],
    );
  }
}
