import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Hiérarchie typographique centralisée.
///
/// Titres chaleureux avec Sora, corps de texte très lisible avec Inter.
/// Toujours consommer via `Theme.of(context).textTheme`, jamais de
/// `TextStyle` ad hoc dispersé dans les écrans.
class AppText {
  AppText._();

  static TextTheme textTheme(ColorScheme scheme) {
    final base = TextTheme(
      displayLarge: GoogleFonts.sora(fontSize: 40, fontWeight: FontWeight.w700, height: 1.15),
      displayMedium: GoogleFonts.sora(fontSize: 32, fontWeight: FontWeight.w700, height: 1.18),
      displaySmall: GoogleFonts.sora(fontSize: 28, fontWeight: FontWeight.w700, height: 1.2),
      headlineLarge: GoogleFonts.sora(fontSize: 24, fontWeight: FontWeight.w700),
      headlineMedium: GoogleFonts.sora(fontSize: 22, fontWeight: FontWeight.w700),
      headlineSmall: GoogleFonts.sora(fontSize: 20, fontWeight: FontWeight.w600),
      titleLarge: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.w600),
      titleMedium: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.w600),
      titleSmall: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.w600),
      bodyLarge: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400, height: 1.4),
      bodyMedium: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, height: 1.4),
      bodySmall: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400, height: 1.3),
      labelLarge: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
      labelMedium: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
      labelSmall: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600),
    );
    return base.apply(
      bodyColor: scheme.onSurface,
      displayColor: scheme.onSurface,
      decorationColor: scheme.onSurface,
    );
  }
}
