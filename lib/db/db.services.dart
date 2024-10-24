import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        created_at TEXT NOT NULL,
        total_time TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE Activity (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        task_id INTEGER NOT NULL,
        start_time TEXT NOT NULL,
        end_time TEXT NOT NULL,
        duration TEXT NOT NULL,
        notes TEXT,
        FOREIGN KEY (task_id) REFERENCES Task(id) ON DELETE CASCADE
      )
    ''');
  }

  // Insert a task into the Task table
  Future<int> insertTask(Map<String, dynamic> task) async {
    final db = await database;
    return await db.insert('Task', task);
  }

  // Insert an activity into the Activity table
  Future<int> insertActivity(Map<String, dynamic> activity) async {
    final db = await database;
    return await db.insert('Activity', activity);
  }

  // Query all tasks
  Future<List<Map<String, dynamic>>> getTasks() async {
    final db = await database;
    return await db.query('Task');
  }

  // Query all activities for a specific task
  Future<List<Map<String, dynamic>>> getActivitiesForTask(int taskId) async {
    final db = await database;
    return await db.query('Activity', where: 'task_id = ?', whereArgs: [taskId]);
  }

  // Delete a task and its associated activities
  Future<int> deleteTask(int taskId) async {
    final db = await database;
    return await db.delete('Task', where: 'id = ?', whereArgs: [taskId]);
  }
}
