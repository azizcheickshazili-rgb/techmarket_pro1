import 'package:flutter/material.dart';

/// TechMarket's visual identity: deep navy surfaces with a cyan accent.
///
/// The palette and type scale are defined explicitly rather than relying
/// on Material's default seed-color generation, so the app has a
/// deliberate, branded look instead of an out-of-the-box template feel.
abstract final class AppColors {
  static const Color navyBackground = Color(0xFF0B1220);
  static const Color navySurface = Color(0xFF121A2B);
  static const Color navySurfaceElevated = Color(0xFF19233A);
  static const Color cyanAccent = Color(0xFF35E0DC);
  static const Color cyanAccentMuted = Color(0xFF1F8C89);
  static const Color textPrimary = Color(0xFFEAF0FA);
  static const Color textSecondary = Color(0xFF8C9AB5);
  static const Color danger = Color(0xFFFF6B6B);
  static const Color success = Color(0xFF4ADE80);
  static const Color divider = Color(0xFF223049);
}

abstract final class AppTheme {
  static const String _fontFamily = 'SpaceGrotesk';

  static ThemeData get dark {
    const ColorScheme scheme = ColorScheme.dark(
      primary: AppColors.cyanAccent,
      onPrimary: Color(0xFF01221F),
      secondary: AppColors.cyanAccentMuted,
      surface: AppColors.navySurface,
      onSurface: AppColors.textPrimary,
      error: AppColors.danger,
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: _fontFamily,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.navyBackground,
      dividerColor: AppColors.divider,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.navyBackground,
        elevation: 0,
        centerTitle: false,
        foregroundColor: AppColors.textPrimary,
        titleTextStyle: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          letterSpacing: -0.2,
        ),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 26,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          letterSpacing: -0.4,
        ),
        titleLarge: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        bodyLarge: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 15,
          color: AppColors.textPrimary,
        ),
        bodyMedium: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 13,
          color: AppColors.textSecondary,
        ),
        labelLarge: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardTheme(
        color: AppColors.navySurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: AppColors.divider),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.navySurfaceElevated,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.cyanAccent, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.danger, width: 1.2),
        ),
        labelStyle: const TextStyle(color: AppColors.textSecondary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.cyanAccent,
          foregroundColor: const Color(0xFF01221F),
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontFamily: _fontFamily,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.navySurface,
        selectedItemColor: AppColors.cyanAccent,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.navySurfaceElevated,
        contentTextStyle: const TextStyle(color: AppColors.textPrimary),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
