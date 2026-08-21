import 'package:flutter/widgets.dart';

import '../l10n/gen/app_localizations.dart';
import '../network/api_exception.dart';

/// Traduit une erreur applicative en message lisible par l'utilisateur,
/// dans la langue courante (FR/EN). Point d'entrée unique pour tout le
/// mapping code -> message : aucun écran ne doit interpréter un code
/// d'erreur lui-même.
class ErrorMessages {
  ErrorMessages._();

  static String from(BuildContext context, Object error) {
    final l10n = AppLocalizations.of(context);

    if (error is ApiException) {
      return switch (error.code) {
        'EMAIL_TAKEN' => l10n.errorEmailTaken,
        'INVALID_CREDENTIALS' => l10n.errorInvalidCredentials,
        'RESTAURANT_CLOSED' => l10n.errorRestaurantClosed,
        'MIXED_RESTAURANTS' => l10n.errorMixedRestaurants,
        'VALIDATION_ERROR' => l10n.errorValidation,
        'ALREADY_REVIEWED' => l10n.errorAlreadyReviewed,
        'CANNOT_CANCEL' => l10n.errorCannotCancel,
        'FILE_TOO_LARGE' => l10n.errorFileTooLarge,
        'RATE_LIMITED' => l10n.errorRateLimited,
        'NOT_FOUND' => l10n.errorNotFound,
        'NETWORK_ERROR' => l10n.errorNetwork,
        'TIMEOUT' => l10n.errorTimeout,
        'UNAUTHORIZED' => l10n.errorUnauthorized,
        'CONFLICT' => l10n.errorConflict,
        _ => error.message.isNotEmpty ? error.message : l10n.commonUnknownError,
      };
    }

    return l10n.commonUnknownError;
  }
}
