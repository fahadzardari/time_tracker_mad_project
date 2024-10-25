import 'dart:async';
import 'package:flutter/material.dart';
import 'package:time_tracker_mad_project/db/models/Activity.dart';
import 'package:time_tracker_mad_project/screens/home.dart';

class TaskDetail extends StatefulWidget {
  final Task task;

  const TaskDetail({required this.task});

  @override
  _TaskDetailState createState() => _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {
  Timer? _timer;
  bool _isRunning = false;
  int _elapsedSeconds = 0;
  List<Activity> _activityLogs = [];

  DateTime? _startTime;

  // Start the timer
  void _startTimer() {
    setState(() {
      _isRunning = true;
      _startTime = DateTime.now();
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedSeconds++;
      });
    });
  }
  
  // Stop the timer and log the activity
  void _stopTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }

    DateTime endTime = DateTime.now();
    Duration duration = endTime.difference(_startTime!);

    // Create a new activity log entry
    Activity activity = Activity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      task_id: widget.task.title,
      start_time: _startTime!,
      end_time: endTime,
      duration: _formatDuration(duration),
      notes: null,
    );

    setState(() {
      _isRunning = false;
      _elapsedSeconds = 0;
      _activityLogs.add(activity);
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

  // Display the formatted timer
  String get _formattedElapsedTime {
    Duration elapsed = Duration(seconds: _elapsedSeconds);
    return _formatDuration(elapsed);
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
            // Timer display
            Center(
              child: Text(
                _formattedElapsedTime,
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
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
                          title: Text('Start: ${activity.start_time}'),
                          subtitle: Text('Duration: ${activity.duration}'),
                          trailing: Text('End: ${activity.end_time}'),
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