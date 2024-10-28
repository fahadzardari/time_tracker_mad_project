import 'dart:async';
import 'package:flutter/material.dart';
import 'package:time_tracker_mad_project/db/models/Activity.dart';
import '../db/models/Task.dart';
import '../db/db.services.dart';
import 'package:intl/intl.dart';

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
  int _lapSeconds = 0;
  List<Activity> _activityLogs = [];
  DateTime? _startTime;
  DatabaseHelper db = DatabaseHelper();
  final DateFormat formatter = DateFormat('HH:mm:ss dd-MM-yyyy');

  @override
  void initState() {
    super.initState();
    _fetchActivities();
    _elapsedSeconds = widget.task.totalTime;
  }

  _fetchActivities() async {
    List<Map<String, dynamic>> res =
        await db.getActivitiesForTask(widget.task.title);
    setState(() {
      _activityLogs =
          res.map((activityMap) => Activity.fromMap(activityMap)).toList();
    });
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
      _startTime = DateTime.now();
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedSeconds++;
        _lapSeconds++;
      });
    });
  }

  void _stopTimer() async {
    if (_timer != null) _timer!.cancel();

    DateTime endTime = DateTime.now();
    Duration duration = endTime.difference(_startTime!);

    Activity activity = Activity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      taskId: widget.task.title,
      startTime: _startTime!,
      endTime: endTime,
      duration: duration.inSeconds,
      notes: null,
    );

    await db.insertActivity(activity.toMap(), widget.task.id);
    await _fetchActivities();
    setState(() {
      _isRunning = false;
      _lapSeconds = 0;
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(duration.inHours)}:${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}";
  }

  String _formatActivityDuration(int seconds) {
    if (seconds < 60) {
      return '$seconds seconds';
    } else if (seconds < 3600) {
      // Less than 60 minutes
      final minutes = (seconds / 60).floor();
      final remainingSeconds = seconds % 60;
      return '$minutes minutes ${remainingSeconds} seconds';
    } else {
      // 60 minutes or more
      final hours = (seconds / 3600).floor();
      final minutes = ((seconds % 3600) / 60).floor();
      final remainingSeconds = seconds % 60;
      return '$hours hours $minutes minutes ${remainingSeconds} seconds';
    }
  }

  String get _formattedTotalTime =>
      _formatDuration(Duration(seconds: _elapsedSeconds));
  String get _formattedLapTime =>
      _formatDuration(Duration(seconds: _lapSeconds));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task.title, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Total time display
              Center(
                child: Text(
                  _formattedTotalTime,
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade700,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  _formattedLapTime,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Start/Stop buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _isRunning ? null : _startTimer,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    child: Text('Start', style: TextStyle(fontSize: 16)),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: _isRunning ? _stopTimer : null,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    child: Text('Stop', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
              SizedBox(height: 30),

              // Activity logs header
              Text(
                'Activity Logs',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade900),
              ),
              SizedBox(height: 10),

              // Activity logs list
              Container(
                height: 300, // Set a height as needed
                child: _activityLogs.isEmpty
                    ? Center(
                        child: Text('No activities logged yet.',
                            style: TextStyle(fontSize: 16, color: Colors.grey)))
                    : ListView.builder(
                        itemCount: _activityLogs.length,
                        itemBuilder: (context, index) {
                          final activity = _activityLogs[index];
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: ListTile(
                              leading: Icon(Icons.timer,
                                  color: Colors.teal.shade700),
                              title: Text(
                                'Start: ${formatter.format(activity.startTime)}',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              subtitle: Text(
                                'Duration: ${_formatActivityDuration(activity.duration)} \nEnd: ${formatter.format(activity.endTime)}',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey.shade700),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
