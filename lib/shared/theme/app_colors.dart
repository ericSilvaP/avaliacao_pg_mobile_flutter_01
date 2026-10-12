import 'package:flutter/material.dart';

/// Cores do DESIGN (1).md.
/// Os valores Material 3 (YAML) são mantidos separados dos acentos visuais
/// descritos nas seções "Brand & Style" e "Components".
abstract final class AppColors {
  AppColors._();

  // Paleta Material 3 definida no front matter do design.
  static const Color surface = Color(0xFF151028);
  static const Color surfaceDim = Color(0xFF151028);
  static const Color surfaceBright = Color(0xFF3B3650);
  static const Color surfaceContainerLowest = Color(0xFF0F0A22);
  static const Color surfaceContainerLow = Color(0xFF1D1830);
  static const Color surfaceContainer = Color(0xFF211C35);
  static const Color surfaceContainerHigh = Color(0xFF2C2640);
  static const Color surfaceContainerHighest = Color(0xFF37314B);

  static const Color onSurface = Color(0xFFE7DEFF);
  static const Color onSurfaceVariant = Color(0xFFCCC3D8);
  static const Color inverseSurface = Color(0xFFE7DEFF);
  static const Color inverseOnSurface = Color(0xFF322D46);
  static const Color outline = Color(0xFF958DA1);
  static const Color outlineVariant = Color(0xFF4A4455);
  static const Color surfaceTint = Color(0xFFD2BBFF);

  static const Color primary = Color(0xFFD2BBFF);
  static const Color onPrimary = Color(0xFF3F008E);
  static const Color primaryContainer = Color(0xFF7C3AED);
  static const Color onPrimaryContainer = Color(0xFFEDE0FF);
  static const Color inversePrimary = Color(0xFF732EE4);

  static const Color secondary = Color(0xFFDDB8FF);
  static const Color onSecondary = Color(0xFF490081);
  static const Color secondaryContainer = Color(0xFF62259B);
  static const Color onSecondaryContainer = Color(0xFFD1A1FF);

  static const Color tertiary = Color(0xFFFFB784);
  static const Color onTertiary = Color(0xFF4F2500);
  static const Color tertiaryContainer = Color(0xFFA15100);
  static const Color onTertiaryContainer = Color(0xFFFFE0CD);

  static const Color error = Color(0xFFFFB4AB);
  static const Color onError = Color(0xFF690005);
  static const Color errorContainer = Color(0xFF93000A);
  static const Color onErrorContainer = Color(0xFFFFDAD6);

  static const Color primaryFixed = Color(0xFFEADDFF);
  static const Color primaryFixedDim = Color(0xFFD2BBFF);
  static const Color onPrimaryFixed = Color(0xFF25005A);
  static const Color onPrimaryFixedVariant = Color(0xFF5A00C6);

  static const Color secondaryFixed = Color(0xFFF0DBFF);
  static const Color secondaryFixedDim = Color(0xFFDDB8FF);
  static const Color onSecondaryFixed = Color(0xFF2C0051);
  static const Color onSecondaryFixedVariant = Color(0xFF62259B);

  static const Color tertiaryFixed = Color(0xFFFFDCC6);
  static const Color tertiaryFixedDim = Color(0xFFFFB784);
  static const Color onTertiaryFixed = Color(0xFF301400);
  static const Color onTertiaryFixedVariant = Color(0xFF713700);

  static const Color background = Color(0xFF151028);
  static const Color onBackground = Color(0xFFE7DEFF);
  static const Color surfaceVariant = Color(0xFF37314B);

  // Cores de identidade visual descritas no texto do design.
  // Não substituem os tokens Material 3 acima.
  static const Color action = Color(0xFF7C3AED);
  static const Color actionHighlight = Color(0xFF8B5CF6);
  static const Color accent = Color(0xFFC084FC);
  static const Color canvasDeep = Color(0xFF130E26);
  static const Color navigationSurface = Color(0xFF1E163B);
  static const Color cardSurface = Color(0xFF281E4E);
  static const Color keySurface = Color(0xFF382A6B);
  static const Color textHigh = Color(0xFFF8FAFC);
  static const Color textMedium = Color(0xFFDDD6FE);
  static const Color disabledSurface = Color(0xFF473873);
  static const Color disabledText = Color(0xFF8B7BB8);
  static const Color exhaustedKeySurface = Color(0xFF181230);
  static const Color exhaustedKeyText = Color(0xFF5C4E8A);
}
