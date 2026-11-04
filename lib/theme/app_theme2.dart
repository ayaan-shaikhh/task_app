// import 'package:flutter/material.dart';
// import 'app_colors.dart';

// class AppColors {
//   static const navy = Color(0xFF0A2463);
//   static const skyBlue = Color(0xFF3E92CC);
//   static const iceWhite = Color(0xFFFFFAFF);
//   static const crimson = Color(0xFFD8315B);
//   static const darkCharcoal = Color(0xFF1E1B18);
// }

// // ---------------- LIGHT THEME ----------------

// ThemeData buildLightTheme() {
//   final scheme = ColorScheme.fromSeed(
//     seedColor: AppColors.navy,
//     brightness: Brightness.light,
//   ).copyWith(
//     primary: AppColors.navy,
//     secondary: AppColors.skyBlue,
//     surface: AppColors.iceWhite,
//   );

//   return ThemeData(
//     useMaterial3: true,
//     colorScheme: scheme,

//     scaffoldBackgroundColor: const Color(0xFFF4F6F9), // Soft clean off-white background

//     textTheme: Typography.material2021().black.apply(
//       bodyColor: AppColors.darkCharcoal,
//       displayColor: AppColors.darkCharcoal,
//     ),

//     extensions: const [
//       AppCustomColors(
//         warningTint: Color(0xFFFFF7E6),
//         warningBorder: Color(0xFFFFE0B2),
//         warningText: Color.fromARGB(255, 207, 39, 13),

//         successTint: Color(0xFFEDFBF2),
//         successBorder: Color(0xFFCBEFD8),
//         successText: Color(0xFF16A34A),

//         errorTint: Color(0xFFFDF2F4),
//         errorText: AppColors.crimson,

//         greyTint: Color(0xFFE5E9F0),
//       ),
//     ],

//     floatingActionButtonTheme: const FloatingActionButtonThemeData(
//       backgroundColor: AppColors.crimson, // Using crimson for high attention pop
//       foregroundColor: Colors.white,
//       shape: CircleBorder(),
//       elevation: 4,
//     ),

//     appBarTheme: const AppBarTheme(
//       backgroundColor: Color(0xFFF4F6F9),
//       surfaceTintColor: Colors.transparent,
//       foregroundColor: AppColors.darkCharcoal,
//       elevation: 0,
//       centerTitle: false,
//     ),
//   );
// }

// // ---------------- DARK THEME ----------------

// ThemeData buildDarkTheme() {
//   final scheme = ColorScheme.fromSeed(
//     seedColor: AppColors.skyBlue,
//     brightness: Brightness.dark,
//   ).copyWith(
//     primary: AppColors.skyBlue,
//     secondary: AppColors.crimson,
//     surface: const Color(0xFF262421), // Muted dark charcoal container surface
//   );

//   return ThemeData(
//     useMaterial3: true,
//     colorScheme: scheme,

//     scaffoldBackgroundColor: AppColors.darkCharcoal, // Deep rich background

//     textTheme: Typography.material2021().white.apply(
//       bodyColor: AppColors.iceWhite,
//       displayColor: AppColors.iceWhite,
//     ),

//     extensions: const [
//       AppCustomColors(
//         warningTint: Color(0xFF382E1B),
//         warningBorder: Color(0xFF66532D),
//         warningText: Color(0xFFFFC76A),

//         successTint: Color(0xFF193126),
//         successBorder: Color(0xFF28533B),
//         successText: Color(0xFF70D99A),

//         errorTint: Color(0xFF3E1D27),
//         errorText: Color(0xFFFF859B),

//         greyTint: Color(0xFF2E2B28),
//       ),
//     ],

//     floatingActionButtonTheme: const FloatingActionButtonThemeData(
//       backgroundColor: AppColors.skyBlue,
//       foregroundColor: AppColors.darkCharcoal,
//       shape: CircleBorder(),
//       elevation: 4,
//     ),

//     appBarTheme: const AppBarTheme(
//       backgroundColor: AppColors.darkCharcoal,
//       surfaceTintColor: Colors.transparent,
//       foregroundColor: AppColors.iceWhite,
//       elevation: 0,
//       centerTitle: false,
//     ),
//   );
// }