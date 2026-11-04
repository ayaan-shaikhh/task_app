
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppColors {
  static const burgundy = Color(0xFF800020);
  static const champagne = Color(0xFFF7E7CE);
  static const gold = Color(0xFFD4AF37);
}

// ---------------- LIGHT THEME ----------------

ThemeData buildLightTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.burgundy,
    brightness: Brightness.light,
  ).copyWith(
    primary: AppColors.burgundy,
    secondary: AppColors.gold,
    surface: const Color(0xFFFFFFFF),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,

    scaffoldBackgroundColor: const Color(0xFFFFFBF5),

    textTheme: Typography.material2021().black.apply(
      bodyColor: const Color(0xFF30201F),
      displayColor: const Color(0xFF30201F),
    ),

    extensions: const [
      AppCustomColors(
        warningTint: Color(0xFFFFF5E8),
        warningBorder: Color(0xFFFBE3C2),
        warningText: Color(0xFFEA8A06),

        successTint: Color(0xFFEDFBF2),
        successBorder: Color(0xFFCBEFD8),
        successText: Color(0xFF16A34A),

        errorTint: Color(0xFFFDE8E8),
        errorText: Color(0xFFE11D2E),

        greyTint: Color(0xFFF5F0EA),
      ),
    ],

    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(
      backgroundColor: AppColors.burgundy,
      foregroundColor: Colors.white,
      shape: CircleBorder(),
      elevation: 4,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFFFFBF5),
      surfaceTintColor: Colors.transparent,
      foregroundColor: Color(0xFF30201F),
      elevation: 0,
      centerTitle: false,
    ),
  );
}

// ---------------- DARK THEME ----------------

ThemeData buildDarkTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.burgundy,
    brightness: Brightness.dark,
  ).copyWith(
    primary: AppColors.gold,
    secondary: AppColors.champagne,
    surface: const Color(0xFF261B1F),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,

    scaffoldBackgroundColor: const Color(0xFF171113),

    textTheme: Typography.material2021().white.apply(
      bodyColor: AppColors.champagne,
      displayColor: AppColors.champagne,
    ),

    extensions: const [
      AppCustomColors(
        warningTint: Color(0xFF382B1B),
        warningBorder: Color(0xFF66502D),
        warningText: Color(0xFFFFC76A),

        successTint: Color(0xFF193126),
        successBorder: Color(0xFF28533B),
        successText: Color(0xFF70D99A),

        errorTint: Color(0xFF3A2023),
        errorText: Color(0xFFFF8585),

        greyTint: Color(0xFF342A2D),
      ),
    ],

    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(
      backgroundColor: AppColors.gold,
      foregroundColor: Color(0xFF30201F),
      shape: CircleBorder(),
      elevation: 4,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF171113),
      surfaceTintColor: Colors.transparent,
      foregroundColor: AppColors.champagne,
      elevation: 0,
      centerTitle: false,
    ),
  );
}
