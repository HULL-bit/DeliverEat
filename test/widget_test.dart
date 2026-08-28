// Test de fumée : vérifie que le thème de l'app se construit sans erreur
// et qu'un widget partagé (EmptyState) s'affiche correctement avec les
// localisations FR chargées.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:delivereat/core/l10n/gen/app_localizations.dart';
import 'package:delivereat/core/theme/app_theme.dart';
import 'package:delivereat/widgets/empty_state.dart';

void main() {
  // google_fonts tente de télécharger les polices à l'exécution : en test,
  // on désactive cet appel réseau et on retombe sur les polices système.
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('EmptyState affiche le titre fourni', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        locale: const Locale('fr'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: const Scaffold(
          body: EmptyState(icon: Icons.inbox_outlined, title: 'Aucun résultat', subtitle: 'Essayez autre chose'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Aucun résultat'), findsOneWidget);
    expect(find.text('Essayez autre chose'), findsOneWidget);
  });
}
