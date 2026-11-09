import 'package:flutter/material.dart';
import '../../../core/stores/task_store.dart';
import '../../../core/stores/habit_store.dart';
import '../../../core/theme/app_theme3.dart'; // for AppColors
import '../widgets/stats_header.dart';
import 'stats_app_shell.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({
    super.key,
    required this.taskstore,
    required this.habitstore,
  });

  final TaskStore taskstore;
  final HabitStore habitstore;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const StatsHeader(),

        // Dark sheet
        Expanded(
          child: Container(
            color: AppColors.blush,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.sheet,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: ListenableBuilder(
                listenable: Listenable.merge([taskstore, habitstore]),
                builder: (context, _) => StatsAppShell(
                  taskstore: taskstore,
                  habitstore: habitstore,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}