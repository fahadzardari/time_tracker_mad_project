class Activity {
  final String? id;
  final String taskId;
  final DateTime startTime;
  final DateTime endTime;
  final int duration;
  final String? notes;

  Activity({
    this.id,
    required this.taskId,
    required this.duration,
    required this.startTime,
    required this.endTime,
    this.notes,
  });

  // Convert an Activity object into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'taskId': taskId,
      'startTime': startTime.toIso8601String(), // Convert DateTime to ISO 8601 String
      'endTime': endTime.toIso8601String(),     // Convert DateTime to ISO 8601 String
      'duration': duration,
      'notes': notes,
    };
  }

  // Create an Activity object from a Map
  factory Activity.fromMap(Map<String, dynamic> map) {
    return Activity(
      id: map['id'],
      taskId: map['taskId'],
      startTime: DateTime.parse(map['startTime']), // Convert String back to DateTime
      endTime: DateTime.parse(map['endTime']),     // Convert String back to DateTime
      duration: map['duration'],
      notes: map['notes'],
    );
  }
}
