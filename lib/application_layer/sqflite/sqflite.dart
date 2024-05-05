import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = 'pdf_database.db';
  static final _databaseVersion = 1;

  static final table = 'pdf_files';

  static final columnCourseId = 'course_id';
  static final columnId = '_id';
  static final columnName = 'name';
  static final columnPath = 'path';

  // Make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only have a single app-wide reference to the database
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  // open the database
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnPath TEXT NOT NULL,
            $columnCourseId TEXT NOT NULL
          )
          ''');
  }

  // Insert a pdf file into the database with a specific course ID
  Future<int> insertPdf(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  // Get all pdf files associated with a specific course ID
  Future<List<Map<String, dynamic>>> queryRowsByCourseId(String courseId) async {
    Database db = await instance.database;
    return await db.query(table, where: '$columnCourseId = ?', whereArgs: [courseId]);
  }

  // Delete a pdf file associated with a specific course ID
  Future<int> deletePdfByCourseId(String courseId, int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ? AND $columnCourseId = ?', whereArgs: [id, courseId]);
  }

}
