import 'package:flutter/material.dart';
import 'package:time_tracker_mad_project/screens/task_detail.dart';
import '../db/db.services.dart';
import '../db/models/Task.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final DatabaseHelper db = DatabaseHelper();
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    _getTasks();
  }

  Future<void> _getTasks() async {
    List<Map<String, dynamic>> res = await db.getTasks();
    setState(() {
      tasks = res.map((taskMap) => Task.fromMap(taskMap)).toList();
    });
  }

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
          child: tasks.isEmpty
              ? Text(
                  "No tasks yet!!!") // Show loading indicator while tasks are being fetched
              : ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return ListTile(
                      title: Text(task.title),
                      subtitle: Text('Time Spent: ${task.totalTime}'),
                      trailing: Icon(
                        task.isComplete
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: task.isComplete ? Colors.green : Colors.grey,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TaskDetail(task: task),
                          ),
                        ).then((_) async => {await _getTasks()});
                      },
                    );
                  },
                ),
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
