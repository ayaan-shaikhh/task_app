enum Weekday {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

class HabitTask {
  final String id;
  final String title;
  final Set<Weekday> frequency;
  final bool isCompleted;

  const HabitTask({
    required this.id,
    required this.title,
    this.frequency = const {
      Weekday.monday,
      Weekday.tuesday,
      Weekday.wednesday,
      Weekday.thursday,
      Weekday.friday,
      Weekday.saturday,
      Weekday.sunday,
    },
    this.isCompleted = false,
  });

  HabitTask copyWith({
    String? title,
    Set<Weekday>? frequency,
    bool? isCompleted,
  }) {
    return HabitTask(
      id: id,
      title: title ?? this.title,
      frequency: frequency ?? this.frequency,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
