import 'package:flutter/material.dart';
import 'package:time_tracker_mad_project/screens/task_detail.dart';

class Task {
  final String title;
  final String timeSpent;
  final bool isCompleted;

  Task({required this.title, required this.timeSpent, required this.isCompleted});
}

class Home extends StatelessWidget{
   final List<Task> tasks = [
    Task(title: 'Task 1', timeSpent: '1 hour', isCompleted: false),
    Task(title: 'Task 2', timeSpent: '30 mins', isCompleted: true),
    Task(title: 'Task 3', timeSpent: '2 hours', isCompleted: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: SafeArea(
        child: Center(
          child: Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return ListTile(
                  title: Text(task.title),
                  subtitle: Text('Time Spent: ${task.timeSpent}'),
                  trailing: Icon(
                    task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: task.isCompleted ? Colors.green : Colors.grey,
                  ),
                  onTap: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskDetail(task: task),
                    ),
                  );
                  },
                );
              },
            ),
          )
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/create_task');
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blueGrey,
      ),
    );
  }
}