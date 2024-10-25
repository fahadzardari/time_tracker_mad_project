class Task {
  final String id;
  final String title;
  final String? description;
  final String? tag;
  final DateTime createdAt;
  final int totalTime;
  final bool isComplete;
  final int priority;

  Task(
      {required this.id,
      required this.title,
      this.description,
      required this.createdAt,
      required this.totalTime,
      required this.isComplete,
      required this.priority,
      this.tag});

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
        id: map['id'],
        title: map['title'],
        description: map['description'] ?? "",
        createdAt:
            DateTime.parse(map['createdAt']), // Convert string to DateTime
        totalTime: map['totalTime'],
        isComplete: map['isComplete'] ==
            1, // Assuming SQLite stores booleans as 0 and 1
        priority: map['priority'],
        tag: map['tag'] ?? "");
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(), // Convert DateTime to string
      'totalTime': totalTime,
      'isComplete': isComplete ? 1 : 0, // Convert bool to int for SQLite
      'priority': priority,
      'tag': tag
    };
  }
}
