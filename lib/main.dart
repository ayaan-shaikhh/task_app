import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'app/app_shell.dart';

import 'core/theme/app_theme3.dart';
import 'core/providers/theme_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Use SQLite FFI when running on Windows.
  if (Platform.isWindows) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Mini Task',
          debugShowCheckedModeBanner: false,

          theme: buildLightTheme(),
          darkTheme: buildDarkTheme(),
          themeMode: themeProvider.themeMode,

          home: const AppShell(),
        );
      },
    );
  }
}
