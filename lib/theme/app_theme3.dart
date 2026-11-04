import 'package:flutter/material.dart';
import 'app_colors.dart'; // AppCustomColors lives here

/// Palette lifted from the calendar: peach -> pink wash, black ink, near-black sheet.
class AppColors {
  // Calendar gradient
  static const peach = Color(0xFFF8CBA9);
  static const blush = Color(0xFFEE9DB4);

  // Neutrals
  static const ink = Color(0xFF111111);
  static const sheet = Color(0xFF050505);

  // Accent (deeper rose for text/icons on light backgrounds)
  static const rose = Color(0xFFC2557A);
  static const roseDeep = Color(0xFF8E2C4A);

  /// Use this anywhere you want the same wash as the calendar header.
  static const calendarGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [peach, blush],
  );
}

// ---------------- LIGHT THEME ----------------

ThemeData buildLightTheme() {
  const scaffold = Color(0xFFFFF6EF); // very pale peach
  const onSurface = Color(0xFF1F1416);

  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.blush,
    brightness: Brightness.light,
  ).copyWith(
    primary: AppColors.ink,
    onPrimary: Colors.white,
    primaryContainer: AppColors.peach,
    onPrimaryContainer: AppColors.ink,
    secondary: AppColors.rose,
    onSecondary: Colors.white,
    secondaryContainer: const Color(0xFFFADADF),
    onSecondaryContainer: AppColors.roseDeep,
    surface: const Color(0xFFFFFCFA),
    onSurface: onSurface,
    onSurfaceVariant: const Color(0xFF6B5558),
    outline: const Color(0xFFC9A9A3),
    outlineVariant: const Color(0xFFEBD3CA),
    error: const Color(0xFFD62F4B),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: scaffold,

    textTheme: Typography.material2021().black.apply(
          bodyColor: onSurface,
          displayColor: onSurface,
        ),

    extensions: const [
      AppCustomColors(
        warningTint: Color(0xFFFFF0E2),
        warningBorder: Color(0xFFF8CBA9),
        warningText: Color(0xFFC2620A),

        successTint: Color(0xFFEAF7EF),
        successBorder: Color(0xFFC5E8D3),
        successText: Color(0xFF1E8E4E),

        errorTint: Color(0xFFFDE6EA),
        errorText: Color(0xFFD62F4B),

        greyTint: Color(0xFFF6ECE7),
      ),
    ],

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.ink,
      foregroundColor: Colors.white,
      shape: CircleBorder(),
      elevation: 4,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: scaffold,
      surfaceTintColor: Colors.transparent,
      foregroundColor: onSurface,
      elevation: 0,
      centerTitle: false,
    ),

    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: scaffold,
      surfaceTintColor: Colors.transparent,
      indicatorColor: AppColors.peach,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        return IconThemeData(
          color: states.contains(WidgetState.selected)
              ? AppColors.ink
              : const Color(0xFF6B5558),
        );
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        return TextStyle(
          fontSize: 12,
          fontWeight: states.contains(WidgetState.selected)
              ? FontWeight.w600
              : FontWeight.w400,
          color: states.contains(WidgetState.selected)
              ? AppColors.ink
              : const Color(0xFF6B5558),
        );
      }),
    ),

    segmentedButtonTheme: SegmentedButtonThemeData(
      style: SegmentedButton.styleFrom(
        selectedBackgroundColor: AppColors.ink,
        selectedForegroundColor: Colors.white,
        foregroundColor: AppColors.ink,
        side: const BorderSide(color: Color(0xFFEBD3CA)),
      ),
    ),

    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) =>
          states.contains(WidgetState.selected) ? AppColors.ink : null),
      checkColor: WidgetStateProperty.all(Colors.white),
    ),

    dividerTheme: const DividerThemeData(
      color: Color(0xFFEBD3CA),
      thickness: 0.8,
    ),
  );
}

// ---------------- DARK THEME ----------------

ThemeData buildDarkTheme() {
  const scaffold = AppColors.sheet; // same near-black as the calendar sheet
  const onSurface = Color(0xFFF5E9E4);

  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.blush,
    brightness: Brightness.dark,
  ).copyWith(
    primary: AppColors.peach,
    onPrimary: const Color(0xFF1A0F0A),
    primaryContainer: const Color(0xFF4A2A33),
    onPrimaryContainer: const Color(0xFFFBD9C0),
    secondary: AppColors.blush,
    onSecondary: const Color(0xFF2A0F18),
    secondaryContainer: const Color(0xFF3D2129),
    onSecondaryContainer: const Color(0xFFFAD1DC),
    surface: const Color(0xFF121012),
    onSurface: onSurface,
    onSurfaceVariant: const Color(0xFFB8A6A8),
    outline: const Color(0xFF6B5A5E),
    outlineVariant: const Color(0xFF3A2E32),
    error: const Color(0xFFFF8FA3),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: scaffold,

    textTheme: Typography.material2021().white.apply(
          bodyColor: onSurface,
          displayColor: onSurface,
        ),

    extensions: const [
      AppCustomColors(
        warningTint: Color(0xFF2A1F18),
        warningBorder: Color(0xFF5C4030),
        warningText: Color(0xFFFFB27A),

        successTint: Color(0xFF14261C),
        successBorder: Color(0xFF24473A),
        successText: Color(0xFF7BDCA3),

        errorTint: Color(0xFF331A20),
        errorText: Color(0xFFFF8FA3),

        greyTint: Color(0xFF1C171A),
      ),
    ],

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.peach,
      foregroundColor: Color(0xFF1A0F0A),
      shape: CircleBorder(),
      elevation: 4,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: scaffold,
      surfaceTintColor: Colors.transparent,
      foregroundColor: onSurface,
      elevation: 0,
      centerTitle: false,
    ),

    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: scaffold,
      surfaceTintColor: Colors.transparent,
      indicatorColor: const Color(0xFF4A2A33),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        return IconThemeData(
          color: states.contains(WidgetState.selected)
              ? AppColors.peach
              : const Color(0xFFB8A6A8),
        );
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        return TextStyle(
          fontSize: 12,
          fontWeight: states.contains(WidgetState.selected)
              ? FontWeight.w600
              : FontWeight.w400,
          color: states.contains(WidgetState.selected)
              ? AppColors.peach
              : const Color(0xFFB8A6A8),
        );
      }),
    ),

    segmentedButtonTheme: SegmentedButtonThemeData(
      style: SegmentedButton.styleFrom(
        selectedBackgroundColor: AppColors.peach,
        selectedForegroundColor: const Color(0xFF1A0F0A),
        foregroundColor: onSurface,
        side: const BorderSide(color: Color(0xFF3A2E32)),
      ),
    ),

    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) =>
          states.contains(WidgetState.selected) ? AppColors.peach : null),
      checkColor: WidgetStateProperty.all(const Color(0xFF1A0F0A)),
    ),

    dividerTheme: const DividerThemeData(
      color: Color(0xFF3A2E32),
      thickness: 0.8,
    ),
  );
}