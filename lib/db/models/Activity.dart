class Activity {
  final String? id;
  final String task_id;
  final DateTime start_time;
  final DateTime end_time;
  final String duration;
  final String? notes;

  Activity(
      {this.id,
      required this.task_id,
      required this.duration,
      required this.start_time,
      required this.end_time,
      this.notes});
}
