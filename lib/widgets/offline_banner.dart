import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/l10n/gen/app_localizations.dart';
import '../providers/connectivity_provider.dart';

/// Bannière discrète affichée en haut de l'app lorsque le réseau est
/// indisponible. Observe [ConnectivityProvider] via `context.select` pour
/// ne se reconstruire que sur un vrai changement d'état réseau.
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final isOffline = context.select<ConnectivityProvider, bool>((c) => c.isOffline);
    final scheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);

    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      child: !isOffline
          ? const SizedBox(width: double.infinity)
          : Container(
              width: double.infinity,
              color: scheme.errorContainer,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Icon(Icons.cloud_off_rounded, size: 16, color: scheme.onErrorContainer),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.offlineBanner,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onErrorContainer),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
