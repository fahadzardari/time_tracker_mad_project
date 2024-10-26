import 'package:flutter/material.dart';
import 'package:time_tracker_mad_project/db/models/Task.dart';
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orangeAccent),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Home(),
        // '/task_detail': (context) => TaskDetail(task: Task(id: '1', title: "313", created_at: DateTime(2016,2,2), total_time: '23', is_complete: false, priority:1),),
        '/create_task': (context) => CreateTask(),
      },
    );
  }
}
