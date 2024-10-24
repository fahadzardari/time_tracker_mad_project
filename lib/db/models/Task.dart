class Task {
  final String id;
  final String title;
  final String? description;
  final DateTime created_at;
  final String total_time_spent;
  final String status;
  final String tag;
  final bool is_favorite;
  final int priority;

  Task({
    required this.id,
    required this.title,
    this.description,
    required this.created_at,
    required this.status,
    required this.is_favorite,
    required this.priority,
    required this.total_time_spent,
    required this.tag,
  });
}
