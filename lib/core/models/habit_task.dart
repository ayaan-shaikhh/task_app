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
  final Set<String> completedDates; // "2026-11-07" style keys

  const HabitTask({
    required this.id,
    required this.title,
    this.frequency = const {
      Weekday.monday, Weekday.tuesday, Weekday.wednesday, Weekday.thursday,
      Weekday.friday, Weekday.saturday, Weekday.sunday,
    },
    this.completedDates = const {},
  });

  static String dateKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  bool isCompletedOn(DateTime d) => completedDates.contains(dateKey(d));

  HabitTask copyWith({
    String? title,
    Set<Weekday>? frequency,
    Set<String>? completedDates,
  }) {
    return HabitTask(
      id: id,
      title: title ?? this.title,
      frequency: frequency ?? this.frequency,
      completedDates: completedDates ?? this.completedDates,
    );
  }
}