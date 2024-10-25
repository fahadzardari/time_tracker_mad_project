import 'package:flutter/material.dart';
import 'package:time_tracker_mad_project/screens/home.dart';

class TaskDetail extends StatelessWidget{
  final Task task;

  const TaskDetail({required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(task.title),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title: ${task.title}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Time Spent: ${task.timeSpent}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Completed: ${task.isCompleted ? 'Yes' : 'No'}',
              style: TextStyle(fontSize: 18, color: task.isCompleted ? Colors.green : Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}