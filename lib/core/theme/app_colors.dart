import 'package:flutter/material.dart';

/// Palette "Teranga" (hospitalité sénégalaise).
///
/// Seule source de vérité pour les couleurs de la marque. Aucune couleur ne
/// doit être écrite en dur ailleurs dans l'app : les widgets consomment
/// toujours [ColorScheme] via `Theme.of(context).colorScheme`
/// (voir [AppTheme]).
class AppColors {
  AppColors._();

  // Couleurs de marque
  static const terracotta = Color(0xFFE8622C); // primaire
  static const terangaGreen = Color(0xFF0B6E4F); // secondaire
  static const safranYellow = Color(0xFFF6B93B); // accent
  static const lateriteRed = Color(0xFFC0392B); // alertes / erreurs

  // Fonds
  static const creamLight = Color(0xFFFFF8F0);
  static const anthraciteDark = Color(0xFF1A1614);

  // Neutres complémentaires (dérivés de la palette, pour surfaces/bordures)
  static const sand100 = Color(0xFFF3E7D9);
  static const sand300 = Color(0xFFE3CFB4);
  static const cocoa700 = Color(0xFF3B2A22);
  static const cocoa900 = Color(0xFF241B16);

  // Sémantiques
  static const success = terangaGreen;
  static const warning = safranYellow;
  static const error = lateriteRed;
  static const info = Color(0xFF2E86AB);

  static const ColorScheme lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: terracotta,
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFFFDCC7),
    onPrimaryContainer: Color(0xFF5A2100),
    secondary: terangaGreen,
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFFBFE9D3),
    onSecondaryContainer: Color(0xFF00341F),
    tertiary: safranYellow,
    onTertiary: Color(0xFF432C00),
    tertiaryContainer: Color(0xFFFFE4AE),
    onTertiaryContainer: Color(0xFF432C00),
    error: lateriteRed,
    onError: Colors.white,
    errorContainer: Color(0xFFFFDAD4),
    onErrorContainer: Color(0xFF410E0B),
    surface: creamLight,
    onSurface: cocoa900,
    surfaceContainerHighest: sand100,
    onSurfaceVariant: cocoa700,
    outline: Color(0xFFB8A390),
    outlineVariant: sand300,
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: cocoa900,
    onInverseSurface: creamLight,
    inversePrimary: Color(0xFFFFB68C),
  );

  static const ColorScheme darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFFF9A6B),
    onPrimary: Color(0xFF4A1A00),
    primaryContainer: Color(0xFF7A3010),
    onPrimaryContainer: Color(0xFFFFDCC7),
    secondary: Color(0xFF6FCB9F),
    onSecondary: Color(0xFF00391F),
    secondaryContainer: Color(0xFF08543A),
    onSecondaryContainer: Color(0xFFBFE9D3),
    tertiary: safranYellow,
    onTertiary: Color(0xFF432C00),
    tertiaryContainer: Color(0xFF624000),
    onTertiaryContainer: Color(0xFFFFE4AE),
    error: Color(0xFFFF8A80),
    onError: Color(0xFF680003),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD4),
    surface: anthraciteDark,
    onSurface: Color(0xFFF3E7D9),
    surfaceContainerHighest: cocoa700,
    onSurfaceVariant: Color(0xFFD8C4B2),
    outline: Color(0xFF8A7666),
    outlineVariant: cocoa700,
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: creamLight,
    onInverseSurface: cocoa900,
    inversePrimary: terracotta,
  );
}
