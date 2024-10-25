import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'time_tracker.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
   CREATE TABLE Task (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT,
    createdAt TEXT NOT NULL,
    totalTime INT,
    isComplete INTEGER,
    priority INT NOT NULL,
    tag TEXT
  )
''');

    await db.execute('''
      CREATE TABLE Activity (
        id TEXT PRIMARY KEY,
        taskId INTEGER NOT NULL,
        startTime TEXT NOT NULL,
        endTime TEXT NOT NULL,
        duration INT NOT NULL,
        notes TEXT,
        FOREIGN KEY (taskId) REFERENCES Task(id) ON DELETE CASCADE
      )
    ''');
  }

  // Insert a task into the Task table
  Future<int> insertTask(Map<String, dynamic> task) async {
    final db = await database;
    return await db.insert('Task', task);
  }

  // Insert an activity into the Activity table
  // Insert an activity into the Activity table
  Future<int> insertActivity(
      Map<String, dynamic> activity, String taskId) async {
    final db = await database;

    // First, insert the activity
    int activityId = await db.insert('Activity', activity);

    // Then increment the task duration
    await incrementTaskDuration(taskId, activity['duration']);

    return activityId; // Return the ID of the inserted activity
  }

  // Query all tasks
  Future<List<Map<String, dynamic>>> getTasks() async {
    final db = await database;
    return await db.query('Task');
  }

  // Query all activities for a specific task
  Future<List<Map<String, dynamic>>> getActivitiesForTask(String taskId) async {
    final db = await database;
    return await db.query('Activity', where: 'taskId = ?', whereArgs: [taskId]);
  }

  // Increment total task duration
  Future<Map<String, dynamic>> incrementTaskDuration(
      String taskId, int duration) async {
    final db = await database;

    // Fetch the current task details
    List<Map<String, dynamic>> tasks = await db.query(
      'Task',
      where: 'id = ?',
      whereArgs: [taskId],
    );

    if (tasks.isNotEmpty) {
      // Get the current total time for the task
      int currentTotalTime = tasks.first['totalTime'] ?? 0;

      // Calculate the new total time
      int newTotalTime = currentTotalTime + duration;

      // Update the task with the new total time
      await db.update(
        'Task',
        {'totalTime': newTotalTime},
        where: 'id = ?',
        whereArgs: [taskId],
      );

      // Optionally, return the updated task
      return {'id': taskId, 'totalTime': newTotalTime};
    }

    // Return an empty map if the task does not exist
    return {};
  }

  // update task completion status
  Future<Map<String, dynamic>> updateTaskCompletion(String taskId) async {
    final db = await database;

    // Fetch the current task details
    List<Map<String, dynamic>> tasks = await db.query(
      'Task',
      where: 'id = ?',
      whereArgs: [taskId],
    );

    if (tasks.isNotEmpty) {
      // Update the task with the new total time
      await db.update(
        'Task',
        {'isComplete': 1},
        where: 'id = ?',
        whereArgs: [taskId],
      );

      // Optionally, return the updated task
      return {'id': taskId, 'isComplete': 1};
    }

    // Return an empty map if the task does not exist
    return {};
  }

  // Delete a task and its associated activities
  Future<int> deleteTask(int taskId) async {
    final db = await database;
    return await db.delete('Task', where: 'id = ?', whereArgs: [taskId]);
  }
}
