import 'package:flutter/material.dart';

import '../../../core/models/habit_task.dart';
// import '../theme/app_theme.dart';
import '../../habits/widgets/habit_row.dart';

import '../../../core/stores/habit_store.dart';

class HabitSectionCard extends StatelessWidget {
  const HabitSectionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.accentText,
    required this.tint,
    required this.border,
    required this.habits,
    required this.onOpen,
    required this.onToggle,
    required this.habitstore,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final Color accentText;
  final Color tint;
  final Color border;
  final List<HabitTask> habits;
  final VoidCallback onOpen;
  final HabitStore habitstore;
  final void Function(String id) onToggle;

  

  @override
  Widget build(BuildContext context) {

    final colorScheme = Theme.of(context).colorScheme;
    final preview = habits.toList();

    return Material(
      color: tint,
      elevation: 2,
      shadowColor: const Color(0x33000000),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          InkWell(
            onTap: onOpen,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: accent,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: Colors.white),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 13,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: accentText),
                ],
              ),
            ),
          ),

          // Habit preview
          Expanded(
            child: preview.isEmpty
                ? Center(
                    child: Text(
                      'No habits yet',
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    children: [
                      for (final habit in preview)
                        HabitRow(
                          habitstore: habitstore,
                          habit: habit,
                          onToggle: () => onToggle(habit.id),
                        ),
                    ],
                  ),
          ),

          // View all
          InkWell(
            onTap: onOpen,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Text(
                'View all (${habits.length})',
                style: TextStyle(
                  color: accentText,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
