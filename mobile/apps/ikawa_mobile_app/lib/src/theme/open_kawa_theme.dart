import 'package:flutter/material.dart';

import 'open_kawa_colors.dart';

abstract final class OpenKawaTheme {
  static ThemeData light() {
    const primary = OpenKawaColors.coffeeCherryRed;
    const onPrimary = OpenKawaColors.warmCream;
    const secondary = OpenKawaColors.deepForestGreen;
    const onSecondary = OpenKawaColors.warmCream;
    const surface = OpenKawaColors.warmCream;
    const onSurface = OpenKawaColors.darkRoast;

    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: primary,
      onPrimary: onPrimary,
      secondary: secondary,
      onSecondary: onSecondary,
      tertiary: OpenKawaColors.goldenHarvest,
      onTertiary: OpenKawaColors.darkRoast,
      error: OpenKawaColors.berryJam,
      onError: onPrimary,
      surface: surface,
      onSurface: onSurface,
      surfaceContainerHighest: OpenKawaColors.softPeach,
      onSurfaceVariant: OpenKawaColors.chocolate,
      outline: OpenKawaColors.chocolate,
      outlineVariant: OpenKawaColors.softPeach,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: OpenKawaColors.warmCream,
      canvasColor: OpenKawaColors.warmCream,
      dialogTheme: const DialogThemeData(
        backgroundColor: OpenKawaColors.warmCream,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: OpenKawaColors.richEarthBrown,
        foregroundColor: OpenKawaColors.warmCream,
        elevation: 0,
        centerTitle: false,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: OpenKawaColors.warmCream.withValues(alpha: 0.94),
        indicatorColor: OpenKawaColors.softPeach,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected ? OpenKawaColors.coffeeCherryRed : OpenKawaColors.chocolate,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? OpenKawaColors.coffeeCherryRed : OpenKawaColors.chocolate,
          );
        }),
      ),
      navigationRailTheme: const NavigationRailThemeData(
        backgroundColor: Colors.transparent,
        indicatorColor: OpenKawaColors.softPeach,
        selectedIconTheme: IconThemeData(color: OpenKawaColors.coffeeCherryRed),
        unselectedIconTheme: IconThemeData(color: OpenKawaColors.chocolate),
        selectedLabelTextStyle: TextStyle(
          color: OpenKawaColors.coffeeCherryRed,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelTextStyle: TextStyle(color: OpenKawaColors.chocolate),
      ),
      cardTheme: CardThemeData(
        color: OpenKawaColors.warmCream.withValues(alpha: 0.92),
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: OpenKawaColors.coffeeCherryRed,
          foregroundColor: OpenKawaColors.warmCream,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: OpenKawaColors.richEarthBrown,
          foregroundColor: OpenKawaColors.warmCream,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: OpenKawaColors.darkRoast,
          side: const BorderSide(color: OpenKawaColors.chocolate),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: OpenKawaColors.coffeeCherryRed),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: OpenKawaColors.softPeach,
        labelStyle: const TextStyle(color: OpenKawaColors.darkRoast),
        side: BorderSide(color: OpenKawaColors.chocolate.withValues(alpha: 0.35)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: OpenKawaColors.warmCream.withValues(alpha: 0.9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: OpenKawaColors.chocolate),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: OpenKawaColors.coffeeCherryRed, width: 2),
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: OpenKawaColors.darkRoast),
        bodyMedium: TextStyle(color: OpenKawaColors.darkRoast),
        bodySmall: TextStyle(color: OpenKawaColors.chocolate),
        titleLarge: TextStyle(color: OpenKawaColors.darkRoast, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(color: OpenKawaColors.darkRoast, fontWeight: FontWeight.w600),
        titleSmall: TextStyle(color: OpenKawaColors.richEarthBrown, fontWeight: FontWeight.w600),
      ),
      dividerColor: OpenKawaColors.chocolate.withValues(alpha: 0.25),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: OpenKawaColors.richEarthBrown,
        contentTextStyle: const TextStyle(color: OpenKawaColors.warmCream),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
