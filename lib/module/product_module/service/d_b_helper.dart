import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  static const String databaseName = 'sqflite_database.db';
  static const int versionNumber = 1;

  // Table name
  static const String productTable = 'Products';

  // Table (Products) Columns
  static const String productId = 'product_id';
  static const String productName = 'product_name';
  static const String productImg = 'product_img';

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, databaseName);
    var db = await openDatabase(path, version: versionNumber, onCreate: _onCreate);
    return db;
  }

  // Run the CREATE TABLE statement on the database.
  _onCreate(Database db, int intVersion) async {
    await db.execute("CREATE TABLE IF NOT EXISTS $productTable ("
        " $productId INTEGER PRIMARY KEY AUTOINCREMENT, "
        " $productName TEXT NOT NULL, "
        " $productImg TEXT NOT NULL "
        ")");
  }
}
