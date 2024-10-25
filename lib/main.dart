import 'package:flutter/material.dart';
import 'package:time_tracker_mad_project/screens/create_task.dart';
import 'package:time_tracker_mad_project/screens/home.dart';
import 'package:time_tracker_mad_project/screens/task_detail.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Tracker App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Home(),
        '/task_detail': (context) => TaskDetail(task: Task(title: 'Task 1', timeSpent: '1 hour', isCompleted: false)),
        '/create_task': (context) => CreateTask(),
      },
    );
  }
}
