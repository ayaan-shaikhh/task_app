import 'package:flutter/material.dart';

import '../data/task_store.dart';
import '../data/habit_store.dart';

// import '../theme/app_theme.dart';
import '../theme/app_colors.dart';

import '../widgets/section_card.dart';
import '../widgets/habit_section_card.dart';

import 'task_list_page.dart';
import 'habit_list_page.dart';

/// Change this to the signed-in user's name once there is a login.
const String userName = 'Ayaan';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.taskstore,
    required this.habitstore,
  });

  final TaskStore taskstore;
  final HabitStore habitstore;

  String _greeting(int hour) {
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  void opentask(BuildContext context, String title) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TaskListPage(title: title, taskstore: taskstore),
      ),
    );
  }

  void openhabits(BuildContext context, String title) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => HabitListPage(title: title, store: habitstore),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final customColors = Theme.of(context).extension<AppCustomColors>()!;

    final hour = DateTime.now().hour;
    final isEvening = hour >= 18 || hour < 5;

    return SafeArea(
      child: Column(
        children: [
          // Greeting header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 16, 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  isEvening
                      ? Icons.nights_stay_rounded
                      : Icons.wb_sunny_rounded,
                  size: 40,
                  color: isEvening ? colorScheme.primary : customColors.warningText,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_greeting(hour)},\n$userName',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                       Text(
                        'Small steps make big progress.',
                        style: TextStyle(color: colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Profile',
                  onPressed: () {},
                  icon:  Icon(
                    Icons.account_circle_outlined,
                    size: 32,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),

          // Tasks and Habits cards share the remaining height.
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await Future.wait([
                  taskstore.loadTasks(),
                  habitstore.loadHabits(),
                ]);
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: Column(
                      children: [
                        // Keep your existing Tasks card here.
                        Expanded(
                          child: ListenableBuilder(
                            listenable: taskstore,
                            builder: (context, _) {
                              final tasks = taskstore.tasks;

                              return SectionCard(
                                title: 'Tasks',
                                subtitle: 'Focus on what matters most',
                                icon: Icons.flag_rounded,
                                accent: customColors.warningText,
                                accentText: customColors.warningText,
                                tint: customColors.warningTint,
                                border: customColors.warningBorder,
                                tasks: tasks,
                                onToggle: taskstore.toggle,
                                taskstore: taskstore,
                                onOpen: () => opentask(context, 'Tasks'),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Keep your existing Habits card here.
                        Expanded(
                          child: ListenableBuilder(
                            listenable: habitstore,
                            builder: (context, _) {
                              final habits = habitstore.todayhabits;

                              // NOTE:
                              // This requires a SectionCard that accepts
                              // List<HabitTask>. If SectionCard currently
                              // accepts List<Task>, create a separate
                              // HabitSectionCard for this section.

                              return HabitSectionCard(
                                title: 'Habits',
                                subtitle: 'Stay consistent, get things done',
                                icon: Icons.check_rounded,
                                accent: customColors.successText,
                                accentText: customColors.successText,
                                tint: customColors.successTint,
                                border: customColors.successBorder,
                                onToggle: habitstore.toggle,
                                habits: habits,
                                habitstore: habitstore,
                                onOpen: () => openhabits(context, 'Habits'),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
