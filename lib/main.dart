import 'package:flutter/material.dart';
import 'package:time_tracker_mad_project/screens/create_task.dart';
import 'package:time_tracker_mad_project/screens/home.dart';


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
        brightness: Brightness.dark, // Forces dark mode
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Home(),
        '/create_task': (context) => CreateTask(),
      },
    );
  }
}
