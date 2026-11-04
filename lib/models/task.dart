class Task {
  final String id;
  final String title;
  final DateTime deadline;
  final bool isCompleted;

  const Task({
    required this.id,
    required this.title,
    required this.deadline,
    this.isCompleted = false,
  });

  Task copyWith({
    String? title,
    DateTime? deadline,
    bool? isCompleted,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      deadline: deadline ?? this.deadline,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
