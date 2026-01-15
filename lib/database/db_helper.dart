import 'dart:async';

import 'package:attendancewithqrwp/core/constants/app_constants.dart';
import 'package:attendancewithqrwp/model/attendance.dart';
import 'package:attendancewithqrwp/model/settings.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static DbHelper? _dbHelper;

  // Db name file
  String dbName = AppConstants.databaseName;

  // table name
  String tableSettings = AppConstants.tableSettings;
  String tableAttendance = AppConstants.tableAttendance;

  factory DbHelper() {
    _dbHelper ??= DbHelper._createObject();
    return _dbHelper!;
  }

  DbHelper._createObject();

  Future<Database> initDb() async {
    // Init name and directory of DB
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path + dbName;

    // Create, read databases
    final todoDatabase = openDatabase(path, version: 1, onCreate: _createDb);
    return todoDatabase;
  }

  // Create the table
  Future<void> _createDb(Database db, int version) async {
    // Table for settings
    await db.execute('''
      CREATE TABLE $tableSettings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        url TEXT,
        key TEXT
        )
    ''');

    // Table for Attendance
    await db.execute('''
      CREATE TABLE $tableAttendance (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        time TEXT,
        name TEXT,
        location TEXT,
        type TEXT
        )
    ''');
  }

  Future<Database?> get database {
    return initDb();
  }

  //--------------------------- Settings --------------------------------------
  // Check there is any data
  Future<int?>? countSettings() async {
    final db = (await database)!;
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM $tableSettings'),
    );
    return count;
  }

  // Insert new data
  Future<int> newSettings(Settings newSettings) async {
    final db = (await database)!;
    final result = await db.insert(tableSettings, newSettings.toJson());
    return result;
  }

  // Get the data by id
  Future getSettings(int id) async {
    final db = (await database)!;
    final res = await db.query(tableSettings, where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Settings.fromJson(res.first) : null;
  }

  // Update the data
  Future<int> updateSettings(Settings updateSettings) async {
    final db = (await database)!;
    final result = await db.update(
      tableSettings,
      updateSettings.toJson(),
      where: "id = ?",
      whereArgs: [updateSettings.id],
    );
    return result;
  }

  //--------------------------- Attendance -------------------------------------

  // Insert new data attendance
  Future<int> newAttendances(Attendance newAttendance) async {
    final db = (await database)!;
    final result = await db.insert(tableAttendance, newAttendance.toJson());
    return result;
  }

  // Get All attendance
  Future<List<Attendance>> getAttendances() async {
    final db = (await database)!;
    final List<Map> maps = await db.rawQuery(
      "SELECT * FROM $tableAttendance ORDER BY date(date) DESC, time(time) DESC",
    );
    final List<Attendance> employees = [];
    if (maps.isNotEmpty) {
      for (int i = 0; i < maps.length; i++) {
        employees.add(Attendance.fromJson(maps[i] as Map<String, dynamic>));
      }
    }
    return employees;
  }
}
