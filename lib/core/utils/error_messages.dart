import 'package:flutter/widgets.dart';

import '../l10n/gen/app_localizations.dart';
import '../network/api_exception.dart';

/// Traduit une erreur applicative en message lisible par l'utilisateur,
/// dans la langue courante (FR/EN). Point d'entrée unique pour tout le
/// mapping code -> message : aucun écran ni provider n'interprète un code
/// d'erreur lui-même.
class ErrorMessages {
  ErrorMessages._();

  /// Résout un code d'erreur métier (ex: `RESTAURANT_CLOSED`) vers un
  /// message déjà traduit. Utilisé aussi bien pour une [ApiException]
  /// fraîchement attrapée dans un écran que pour un `code` conservé dans un
  /// [ViewState] par un provider (les providers ne dépendent jamais de
  /// [BuildContext] : ils stockent le code, l'UI le résout ici au moment de
  /// l'affichage).
  static String resolve(BuildContext context, {required String? code, required String fallback}) {
    final l10n = AppLocalizations.of(context);
    return switch (code) {
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
      _ => fallback.isNotEmpty ? fallback : l10n.commonUnknownError,
    };
  }

  /// Raccourci pour une [ApiException] attrapée directement dans un écran.
  static String from(BuildContext context, Object error) {
    if (error is ApiException) {
      return resolve(context, code: error.code, fallback: error.message);
    }
    return AppLocalizations.of(context).commonUnknownError;
  }
}
