class Task {
  final int id;
  final String title;
  final bool completed;

  Task({required this.id, required this.title, required this.completed});

  // Factory method to create a Task from JSON
  factory Task.fromJSON(Map<String, dynamic> json) => Task(
        id: json['id'],
        title: json['title'],
        completed: json['completed'],
      );
}
