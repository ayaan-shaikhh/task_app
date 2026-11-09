import 'package:flutter/material.dart';
import '../../../core/models/habit_task.dart';
import '../../../core/stores/habit_store.dart';
import '../../../core/theme/app_theme3.dart'; // for AppColors

class HabitPicker extends StatefulWidget {
  const HabitPicker({super.key, required this.habitstore});

  final HabitStore habitstore;

  @override
  State<HabitPicker> createState() => _HabitPickerState();
}

class _HabitPickerState extends State<HabitPicker> {
  bool _habitDone(HabitTask habit) => habit.isCompletedOn(DateTime.now());
  String _habitName(HabitTask habit) => habit.title;
  String _habitKey(HabitTask habit) => habit.id;
  List<HabitTask> get _allHabits => widget.habitstore.habits; // ALL habits

  static const _card = Color(0xFF151213);

  final Set<String> _selected = {};

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.habitstore,
      builder: (context, _) {
        final all = _allHabits;
        final selected =
            all.where((h) => _selected.contains(_habitKey(h))).toList();
        final done = selected.where(_habitDone).length;
        final pct = selected.isEmpty ? 0.0 : done / selected.length;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _card,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Habit completion',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  TextButton(
                    onPressed: all.isEmpty
                        ? null
                        : () => setState(
                            () => _selected.addAll(all.map(_habitKey))),
                    child: const Text('Select all'),
                  ),
                  TextButton(
                    onPressed: _selected.isEmpty
                        ? null
                        : () => setState(_selected.clear),
                    child: const Text('Clear'),
                  ),
                ],
              ),
              if (all.isEmpty)
                const Text('No habits yet',
                    style: TextStyle(color: Colors.white60))
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: all.map((h) {
                    final key = _habitKey(h);
                    final isSel = _selected.contains(key);
                    return FilterChip(
                      label: Text(_habitName(h)),
                      selected: isSel,
                      showCheckmark: false,
                      backgroundColor: Colors.white12,
                      selectedColor: AppColors.peach,
                      labelStyle: TextStyle(
                        color: isSel ? Colors.black : Colors.white70,
                      ),
                      onSelected: (v) => setState(() {
                        v ? _selected.add(key) : _selected.remove(key);
                      }),
                    );
                  }).toList(),
                ),
              const SizedBox(height: 20),
              if (selected.isEmpty)
                const Text(
                  'Select one or more habits to see their completion',
                  style: TextStyle(color: Colors.white60),
                )
              else ...[
                Text(
                  '${(pct * 100).round()}%',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: AppColors.peach,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${selected.length} habit${selected.length == 1 ? '' : 's'} selected',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    Text(
                      '$done / ${selected.length}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: pct,
                    minHeight: 8,
                    backgroundColor: Colors.white12,
                    valueColor: const AlwaysStoppedAnimation(AppColors.peach),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}