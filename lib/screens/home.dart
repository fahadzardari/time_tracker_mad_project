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
  String? selectedTag; 

  @override
  void initState() {
    super.initState();
    _getTasks();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _getTasks() async {
    List<Map<String, dynamic>> res = await db.getTasks();
    setState(() {
      tasks = res.map((taskMap) => Task.fromMap(taskMap)).toList();
    });
  }

  Future<void> completeTask(String taskId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Completion"),
          content: const Text(
              "Are you sure you want to mark this task as complete?"),
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

    if (confirm == true) {
      await db.updateTaskCompletion(taskId, true);
      await _getTasks();
    }
  }

  Future<void> deleteTask(String taskId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Deletion"),
          content: const Text(
              "Are you sure you want to delete this task? This action cannot be undone."),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text("Delete"),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await db.deleteTask(taskId);
      await _getTasks();
    }
  }

  Future<void> markTaskIncomplete(String taskId) async {
    await db.updateTaskCompletion(taskId, false); 
    await _getTasks();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  String _formattedTotalTime(int time) {
    Duration totalDuration = Duration(seconds: time);
    return _formatDuration(totalDuration);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String?> tags = tasks
        .where((task) => !task.isComplete)
        .map((task) => task.tag)
        .toSet()
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        backgroundColor: Colors.teal[800],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.amberAccent,
          labelColor: Colors.amberAccent,
          unselectedLabelColor: Colors.grey[400],
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
            Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: tags.map((tag) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: ChoiceChip(
                          label: Text(
                            tag ?? "",
                            style: TextStyle(color: Colors.white),
                          ),
                          selected: selectedTag == tag,
                          selectedColor: Colors.teal[700],
                          backgroundColor: Colors.grey[800],
                          onSelected: (isSelected) {
                            setState(() {
                              selectedTag = isSelected ? tag : null;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Expanded(
                  child: tasks.isEmpty
                      ? const Center(
                          child: Text(
                            "No tasks yet!!!",
                            style: TextStyle(color: Colors.white70),
                          ),
                        )
                      : ListView.builder(
                          itemCount: tasks
                              .where((task) =>
                                  !task.isComplete &&
                                  (selectedTag == null ||
                                      task.tag == selectedTag))
                              .length,
                          itemBuilder: (context, index) {
                            final task = tasks
                                .where((task) =>
                                    !task.isComplete &&
                                    (selectedTag == null ||
                                        task.tag == selectedTag))
                                .toList()[index];
                            return ListTile(
                              tileColor: Colors.grey[850],
                              title: Text(
                                task.title,
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                'Time Spent: ${_formattedTotalTime(task.totalTime)}',
                                style: TextStyle(color: Colors.grey[400]),
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.check_circle_outline,
                                  color: Colors.amberAccent,
                                ),
                                onPressed: () => completeTask(task.id),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        TaskDetail(task: task),
                                  ),
                                ).then((_) async => {await _getTasks()});
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
            tasks.isEmpty
                ? const Center(
                    child: Text(
                      "No tasks yet!!!",
                      style: TextStyle(color: Colors.white70),
                    ),
                  )
                : ListView.builder(
                    itemCount: tasks.where((task) => task.isComplete).length,
                    itemBuilder: (context, index) {
                      final task = tasks
                          .where((task) => task.isComplete)
                          .toList()[index];
                      return ListTile(
                        tileColor: Colors.grey[850],
                        title: Text(
                          task.title,
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          'Time Spent: ${_formattedTotalTime(task.totalTime)}',
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                        trailing: Wrap(
                          spacing: 8,
                          children: [
                            IconButton(
                              icon: Icon(Icons.undo, color: Colors.amberAccent),
                              onPressed: () => markTaskIncomplete(task.id),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.redAccent),
                              onPressed: () => deleteTask(task.id),
                            ),
                          ],
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        backgroundColor: Colors.teal,
      ),
    );
  }
}
