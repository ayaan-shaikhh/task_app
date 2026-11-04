import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Appearance', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            'Choose how Mini Task looks.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),

          // Theme options will go here.
          RadioListTile<ThemeMode>(
            title: const Text('Light'),
            value: ThemeMode.light,
            groupValue: themeProvider.themeMode,
            onChanged: (mode) {
              if (mode != null) {
                themeProvider.setThemeMode(mode);
              }
            },
          ),

          RadioListTile<ThemeMode>(
            title: const Text('Dark'),
            value: ThemeMode.dark,
            groupValue: themeProvider.themeMode,
            onChanged: (mode) {
              if (mode != null) {
                themeProvider.setThemeMode(mode);
              }
            },
          ),

          RadioListTile<ThemeMode>(
            title: const Text('System default'),
            value: ThemeMode.system,
            groupValue: themeProvider.themeMode,
            onChanged: (mode) {
              if (mode != null) {
                themeProvider.setThemeMode(mode);
              }
            },
          ),
        ],
      ),
    );
  }
}
