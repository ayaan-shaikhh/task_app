import 'package:flutter/material.dart';

import '../../../core/models/habit_task.dart';

class CreateHabitPage extends StatefulWidget {
  const CreateHabitPage({super.key});

  @override
  State<CreateHabitPage> createState() => _CreateHabitPageState();
}

class _CreateHabitPageState extends State<CreateHabitPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  final Set<Weekday> _selectedDays = {
    Weekday.monday,
    Weekday.tuesday,
    Weekday.wednesday,
    Weekday.thursday,
    Weekday.friday,
    Weekday.saturday,
    Weekday.sunday,
  };

  static const Color _primaryColor = Color(0xFF6C63FF);

  static const List<Weekday> _weekdays = [
    Weekday.monday,
    Weekday.tuesday,
    Weekday.wednesday,
    Weekday.thursday,
    Weekday.friday,
    Weekday.saturday,
    Weekday.sunday,
  ];

  static const List<String> _dayLabels = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _toggleDay(Weekday day) {
    setState(() {
      if (_selectedDays.contains(day)) {
        _selectedDays.remove(day);
      } else {
        _selectedDays.add(day);
      }
    });
  }

  void _createHabit() {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one day.'),
        ),
      );
      return;
    }

    final habit = HabitTask(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      frequency: Set<Weekday>.of(_selectedDays),
    );

    // Return the newly created habit to the previous page.
    Navigator.pop(context, habit);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Habit'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Build a good habit',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Choose a habit and the days you want to practise it.',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 28),

                const Text(
                  'Habit title',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),

                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: 'e.g. Read 10 pages',
                    prefixIcon: const Icon(Icons.edit_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a habit title.';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 28),

                const Text(
                  'Repeat on',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Select the days when this habit should appear.',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 16),

                Row(
                  children: List.generate(_weekdays.length, (index) {
                    final day = _weekdays[index];
                    final isSelected = _selectedDays.contains(day);

                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: index == _weekdays.length - 1 ? 0 : 4,
                        ),
                        child: Column(
                          children: [
                            Text(
                              _dayLabels[index],
                              style: const TextStyle(fontSize: 11),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: OutlinedButton(
                                  onPressed: () => _toggleDay(day),
                                  style: OutlinedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    backgroundColor: isSelected
                                        ? _primaryColor
                                        : Colors.transparent,
                                    foregroundColor: isSelected
                                        ? Colors.white
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                    side: BorderSide(
                                      color: isSelected
                                          ? _primaryColor
                                          : Colors.grey.shade400,
                                    ),
                                    shape: const CircleBorder(),
                                  ),
                                  child: isSelected
                                      ? const Icon(
                                          Icons.check,
                                          size: 18,
                                        )
                                      : Text(
                                          _dayLabels[index][0],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 12),

                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedDays
                        ..clear()
                        ..addAll(_weekdays);
                    });
                  },
                  child: const Text('Select every day'),
                ),

                const SizedBox(height: 36),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _createHabit,
                    icon: const Icon(Icons.add_task),
                    label: const Text('Create Habit'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: _primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}