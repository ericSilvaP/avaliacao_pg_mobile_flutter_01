import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Medidas do DESIGN (1).md. Valores em dp (equivalentes a rem * 16).
abstract final class AppSpacing {
  AppSpacing._();

  static const double gutter = 12;
  static const double gutterMobile = 8;
  static const double margin = 16;
  static const double marginMobile = 12;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
}

abstract final class AppRadius {
  AppRadius._();

  static const double sm = 4;
  static const double base = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double pill = 9999;
}

abstract final class AppTextStyles {
  AppTextStyles._();

  static const TextStyle runeLabel = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 24 / 20,
    letterSpacing: 1.2,
    color: AppColors.textHigh,
  );

  static const TextStyle actionLabel = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 15,
    fontWeight: FontWeight.w700,
    height: 20 / 15,
    letterSpacing: 0.6,
  );
}

abstract final class AppTheme {
  AppTheme._();

  static const ColorScheme _colors = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    primaryContainer: AppColors.primaryContainer,
    onPrimaryContainer: AppColors.onPrimaryContainer,
    primaryFixed: AppColors.primaryFixed,
    primaryFixedDim: AppColors.primaryFixedDim,
    onPrimaryFixed: AppColors.onPrimaryFixed,
    onPrimaryFixedVariant: AppColors.onPrimaryFixedVariant,
    secondary: AppColors.secondary,
    onSecondary: AppColors.onSecondary,
    secondaryContainer: AppColors.secondaryContainer,
    onSecondaryContainer: AppColors.onSecondaryContainer,
    secondaryFixed: AppColors.secondaryFixed,
    secondaryFixedDim: AppColors.secondaryFixedDim,
    onSecondaryFixed: AppColors.onSecondaryFixed,
    onSecondaryFixedVariant: AppColors.onSecondaryFixedVariant,
    tertiary: AppColors.tertiary,
    onTertiary: AppColors.onTertiary,
    tertiaryContainer: AppColors.tertiaryContainer,
    onTertiaryContainer: AppColors.onTertiaryContainer,
    tertiaryFixed: AppColors.tertiaryFixed,
    tertiaryFixedDim: AppColors.tertiaryFixedDim,
    onTertiaryFixed: AppColors.onTertiaryFixed,
    onTertiaryFixedVariant: AppColors.onTertiaryFixedVariant,
    error: AppColors.error,
    onError: AppColors.onError,
    errorContainer: AppColors.errorContainer,
    onErrorContainer: AppColors.onErrorContainer,
    surface: AppColors.surface,
    onSurface: AppColors.onSurface,
    surfaceDim: AppColors.surfaceDim,
    surfaceBright: AppColors.surfaceBright,
    surfaceContainerLowest: AppColors.surfaceContainerLowest,
    surfaceContainerLow: AppColors.surfaceContainerLow,
    surfaceContainer: AppColors.surfaceContainer,
    surfaceContainerHigh: AppColors.surfaceContainerHigh,
    surfaceContainerHighest: AppColors.surfaceContainerHighest,
    onSurfaceVariant: AppColors.onSurfaceVariant,
    outline: AppColors.outline,
    outlineVariant: AppColors.outlineVariant,
    inverseSurface: AppColors.inverseSurface,
    onInverseSurface: AppColors.inverseOnSurface,
    inversePrimary: AppColors.inversePrimary,
    surfaceTint: AppColors.surfaceTint,
  );

  static const TextTheme _text = TextTheme(
    displayLarge: TextStyle(
      fontFamily: 'Outfit', fontSize: 40, fontWeight: FontWeight.w700,
      height: 48 / 40, letterSpacing: -0.8, color: AppColors.onSurface,
    ),
    headlineLarge: TextStyle(
      fontFamily: 'Outfit', fontSize: 32, fontWeight: FontWeight.w700,
      height: 40 / 32, letterSpacing: -0.32, color: AppColors.onSurface,
    ),
    headlineMedium: TextStyle(
      fontFamily: 'Outfit', fontSize: 26, fontWeight: FontWeight.w700,
      height: 32 / 26, letterSpacing: -0.26, color: AppColors.onSurface,
    ),
    headlineSmall: TextStyle(
      fontFamily: 'Outfit', fontSize: 22, fontWeight: FontWeight.w600,
      height: 28 / 22, color: AppColors.onSurface,
    ),
    titleLarge: TextStyle(
      fontFamily: 'Outfit', fontSize: 18, fontWeight: FontWeight.w600,
      height: 24 / 18, letterSpacing: 0.18, color: AppColors.onSurface,
    ),
    titleMedium: TextStyle(
      fontFamily: 'Plus Jakarta Sans', fontSize: 16,
      fontWeight: FontWeight.w600, height: 22 / 16,
      letterSpacing: 0.16, color: AppColors.onSurface,
    ),
    bodyLarge: TextStyle(
      fontFamily: 'Plus Jakarta Sans', fontSize: 16,
      fontWeight: FontWeight.w400, height: 24 / 16,
      letterSpacing: 0.32, color: AppColors.onSurface,
    ),
    bodyMedium: TextStyle(
      fontFamily: 'Plus Jakarta Sans', fontSize: 14,
      fontWeight: FontWeight.w400, height: 20 / 14,
      letterSpacing: 0.14, color: AppColors.onSurfaceVariant,
    ),
    labelLarge: TextStyle(
      fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.w700,
      height: 20 / 15, letterSpacing: 0.6, color: AppColors.onSurface,
    ),
    labelMedium: TextStyle(
      fontFamily: 'Outfit', fontSize: 13, fontWeight: FontWeight.w600,
      height: 16 / 13, letterSpacing: 0.65, color: AppColors.onSurface,
    ),
  );

  static ThemeData dark() {
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
      borderSide: const BorderSide(color: AppColors.keySurface),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: _colors,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'Plus Jakarta Sans',
      textTheme: _text,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardSurface,
        labelStyle: const TextStyle(color: AppColors.textMedium),
        hintStyle: const TextStyle(color: AppColors.onSurfaceVariant),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ),
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: inputBorder.copyWith(
          borderSide: const BorderSide(color: AppColors.accent, width: 2),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.action,
          foregroundColor: AppColors.textHigh,
          disabledBackgroundColor: AppColors.disabledSurface,
          disabledForegroundColor: AppColors.disabledText,
          minimumSize: const Size(88, 48),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          textStyle: AppTextStyles.actionLabel,
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: AppColors.navigationSurface,
        indicatorColor: AppColors.action,
        elevation: 0,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.outlineVariant,
        thickness: 1,
      ),
    );
  }
}
