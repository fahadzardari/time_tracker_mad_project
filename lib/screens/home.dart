import 'package:flutter/material.dart';
import 'package:time_tracker_mad_project/screens/task_detail.dart';
import '../db/db.services.dart';
import '../db/models/Task.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final DatabaseHelper db = DatabaseHelper();
  List<Task> tasks = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _getTasks();
    _tabController = TabController(length: 2, vsync: this); // 2 tabs
  }

  Future<void> _getTasks() async {
    List<Map<String, dynamic>> res = await db.getTasks();
    setState(() {
      tasks = res.map((taskMap) => Task.fromMap(taskMap)).toList();
    });
  }

  Future<void> completeTask(String taskId) async {
    // Show confirmation dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Completion"),
          content: const Text("Are you sure you want to mark this task as complete?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text("Confirm"),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    // If confirmed, update the task
    if (confirm == true) {
      await db.updateTaskCompletion(taskId); // Assuming you have this method in your DatabaseHelper
      await _getTasks(); // Refresh the task list
    }
  }

  @override
  void dispose() {
    _tabController.dispose(); // Dispose of the TabController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Incomplete Tasks'),
            Tab(text: 'Completed Tasks'),
          ],
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: [
            // Incomplete Tasks
            tasks.isEmpty
                ? Center(child: Text("No tasks yet!!!"))
                : ListView.builder(
                    itemCount: tasks.where((task) => !task.isComplete).length,
                    itemBuilder: (context, index) {
                      final task = tasks.where((task) => !task.isComplete).toList()[index];
                      return ListTile(
                        title: Text(task.title),
                        subtitle: Text('Time Spent: ${task.totalTime}'),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.check_circle_outline, // Change to outline to indicate incomplete
                            color: Colors.grey,
                          ),
                          onPressed: () => completeTask(task.id), // Call completeTask on icon press
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

            // Completed Tasks
            tasks.isEmpty
                ? Center(child: Text("No tasks yet!!!"))
                : ListView.builder(
                    itemCount: tasks.where((task) => task.isComplete).length,
                    itemBuilder: (context, index) {
                      final task = tasks.where((task) => task.isComplete).toList()[index];
                      return ListTile(
                        title: Text(task.title),
                        subtitle: Text('Time Spent: ${task.totalTime}'),
                        trailing: Icon(
                          Icons.check_circle,
                          color: Colors.green,
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
          ],
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
