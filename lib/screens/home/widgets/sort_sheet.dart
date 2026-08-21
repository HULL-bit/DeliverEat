import 'package:flutter/material.dart';

import '../../../core/l10n/gen/app_localizations.dart';

/// Feuille modale de sélection du tri des restaurants.
void showSortSheet(BuildContext context, {required String currentSort, required ValueChanged<String> onSelected}) {
  final l10n = AppLocalizations.of(context);
  final options = <String, String>{
    'rating': l10n.homeSortRating,
    'deliveryTime': l10n.homeSortDeliveryTime,
    'deliveryFee': l10n.homeSortDeliveryFee,
    'name': l10n.homeSortName,
  };

  showModalBottomSheet<void>(
    context: context,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text(l10n.homeSortLabel, style: Theme.of(context).textTheme.titleMedium),
            ),
            RadioGroup<String>(
              groupValue: currentSort,
              onChanged: (value) {
                if (value != null) onSelected(value);
                Navigator.of(context).pop();
              },
              child: Column(
                children: [
                  for (final entry in options.entries)
                    RadioListTile<String>(value: entry.key, title: Text(entry.value)),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
