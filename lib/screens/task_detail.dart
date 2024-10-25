import 'dart:async';
import 'package:flutter/material.dart';
import 'package:time_tracker_mad_project/db/models/Activity.dart';
import 'package:time_tracker_mad_project/screens/home.dart';
import '../db/models/Task.dart';
import '../db/db.services.dart'; // Import your database services

class TaskDetail extends StatefulWidget {
  final Task task;

  const TaskDetail({required this.task});

  @override
  _TaskDetailState createState() => _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {
  Timer? _timer;
  bool _isRunning = false;
  int _elapsedSeconds = 0; // Total time for the task
  int _lapSeconds = 0; // Current lap time
  List<Activity> _activityLogs = [];
  DateTime? _startTime;
  DatabaseHelper db = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _fetchActivities();
    _elapsedSeconds = widget.task.totalTime; // Assuming totalTime is a property in Task
  }

  // Fetch activities for the specific task
  _fetchActivities() async {
    List<Map<String, dynamic>> res =
        await db.getActivitiesForTask(widget.task.title);
    setState(() {
      _activityLogs =
          res.map((activityMap) => Activity.fromMap(activityMap)).toList();
    });
  }

  // Start the timer
  void _startTimer() {
    setState(() {
      _isRunning = true;
      _startTime = DateTime.now();
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedSeconds++;
        _lapSeconds++; // Increment the lap timer
      });
    });
  }

  // Stop the timer and log the activity
  void _stopTimer() async {
    if (_timer != null) {
      _timer!.cancel();
    }

    DateTime endTime = DateTime.now();
    Duration duration = endTime.difference(_startTime!);

    // Create a new activity log entry
    Activity activity = Activity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      taskId: widget.task.title,
      startTime: _startTime!,
      endTime: endTime,
      duration: duration.inSeconds, // Lap time for activity
      notes: null,
    );

    await db.insertActivity(activity.toMap(), widget.task.id);
    await _fetchActivities();
    setState(() {
      _isRunning = false;
      _lapSeconds = 0; // Reset lap time after stopping
    });
  }

  // Format the duration to a readable format
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  // Display the formatted total elapsed time
  String get _formattedTotalTime {
    Duration totalDuration = Duration(seconds: _elapsedSeconds);
    return _formatDuration(totalDuration);
  }

  // Display the formatted lap time
  String get _formattedLapTime {
    Duration lapDuration = Duration(seconds: _lapSeconds);
    return _formatDuration(lapDuration);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total time display
            Center(
              child: Text(
                _formattedTotalTime,
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),

            // Lap time display
            Center(
              child: Text(
                _formattedLapTime,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
            ),
            SizedBox(height: 20),

            // Start/Stop buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _isRunning ? null : _startTimer,
                  child: Text('Start'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _isRunning ? _stopTimer : null,
                  child: Text('Stop'),
                ),
              ],
            ),
            SizedBox(height: 40),

            // Activity logs header
            Text(
              'Activity Logs',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Activity logs list
            Expanded(
              child: _activityLogs.isEmpty
                  ? Center(child: Text('No activities logged yet.'))
                  : ListView.builder(
                      itemCount: _activityLogs.length,
                      itemBuilder: (context, index) {
                        final activity = _activityLogs[index];
                        return ListTile(
                          title: Text('Start: ${activity.startTime}'),
                          subtitle:
                              Text('Duration: ${activity.duration} seconds'),
                          trailing: Text('End: ${activity.endTime}'),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
