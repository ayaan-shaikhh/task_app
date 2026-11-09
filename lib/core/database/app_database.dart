import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'mini_task_app.db');

    _database = await openDatabase(
      path,
      version: 2, // was 1
      // Needed so deleting a habit also deletes its completions.
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        // Create the tasks table.
        await db.execute('''
          CREATE TABLE tasks (
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            deadline TEXT NOT NULL,
            isCompleted INTEGER NOT NULL DEFAULT 0
          )
        ''');

        // Create the habits table.
        await db.execute('''
          CREATE TABLE habits (
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            frequency TEXT NOT NULL,
            isCompleted INTEGER NOT NULL DEFAULT 0
          )
        ''');

        // Create the habit completions table (one row per habit per day).
        await _createHabitCompletionsTable(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // Existing installs (version 1) don't have the completions table yet.
        if (oldVersion < 2) {
          await _createHabitCompletionsTable(db);
        }
      },
    );

    return _database!;
  }

  static Future<void> _createHabitCompletionsTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS habit_completions (
        habit_id TEXT NOT NULL,
        date TEXT NOT NULL,
        PRIMARY KEY (habit_id, date),
        FOREIGN KEY (habit_id) REFERENCES habits(id) ON DELETE CASCADE
      )
    ''');
  }
}