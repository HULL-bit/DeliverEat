import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/l10n/gen/app_localizations.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/utils/error_messages.dart';
import '../../../providers/restaurant_detail_provider.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/rating_stars.dart';

/// Feuille modale d'ajout d'avis (note 1-5 + commentaire). Gère 409
/// ALREADY_REVIEWED sans planter : le message est affiché dans la feuille
/// elle-même, qui reste ouverte pour que l'utilisateur comprenne.
void showReviewSheet(BuildContext context, {required String restaurantId}) {
  final provider = context.read<RestaurantDetailProvider>();
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (sheetContext) => ChangeNotifierProvider.value(
      value: provider,
      child: const _ReviewSheetContent(),
    ),
  );
}

class _ReviewSheetContent extends StatefulWidget {
  const _ReviewSheetContent();

  @override
  State<_ReviewSheetContent> createState() => _ReviewSheetContentState();
}

class _ReviewSheetContentState extends State<_ReviewSheetContent> {
  int _rating = 5;
  final _commentController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _errorMessage = null);
    final provider = context.read<RestaurantDetailProvider>();
    try {
      await provider.submitReview(rating: _rating, comment: _commentController.text.trim());
      if (!mounted) return;
      Navigator.of(context).pop();
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _errorMessage = ErrorMessages.from(context, e));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final submitting = context.watch<RestaurantDetailProvider>().submittingReview;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.restaurantAddReview, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Center(child: RatingInput(rating: _rating, onChanged: (value) => setState(() => _rating = value))),
          const SizedBox(height: 16),
          TextField(
            controller: _commentController,
            maxLines: 3,
            decoration: InputDecoration(hintText: l10n.restaurantReviewHint),
          ),
          if (_errorMessage != null) ...[
            const SizedBox(height: 10),
            Text(_errorMessage!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ],
          const SizedBox(height: 20),
          AppButton(label: l10n.restaurantReviewSubmit, onPressed: _submit, loading: submitting),
        ],
      ),
    );
  }
}
