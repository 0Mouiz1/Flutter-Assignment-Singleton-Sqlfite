import 'package:sqflite/sqflite.dart';
//import 'package:urann_crud/sqflite/database_student.dart';
import 'package:path/path.dart' as p;
import 'package:urann_crud/sqflite/model_student.dart';

final String table_name = 'student_table';
final String id = 'id';
final String roll_no = 'roll_no';
final String name = 'name';

class DatabaseStudent {
  static DatabaseStudent? databaseStudent;
  DatabaseStudent._createInstance();

  factory DatabaseStudent() {
    databaseStudent ??= DatabaseStudent._createInstance();
    return databaseStudent!;
  }

///////////////////////////////////////////////////////////////////ignore: prefer_typing_uninitialized_variables, non_constant_identifier_names

  static Database? _database;

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    //Database? database;
    try {
      var database_path = await getDatabasesPath();
      var path = p.join(database_path, 'database_stdent.db');
      String sqlQuery = '''
    CREATE TABLE $table_name (
          $id INTEGER PRIMARY KEY,
    $name text,
    $roll_no text )
    ''';
      var database = await openDatabase(
        path,
        version: 1,
        onCreate: (Database db, int version) {
          db.execute(sqlQuery);
        },
      );
      return database;
    } catch (e) {
      print("Database Error!${e.toString()}");
      return database;
    }
  }

// Future

///////////////////////////////////////////////////////////////
  Future<bool> AddRecord(ModelStudent modelStudent) async {
    try {
      Database db = await database;
      int count = await db.insert(table_name, modelStudent.toMap());
      print("$count");
      return true;
    } catch (e) {
      print("Database Error in insertion !${e.toString()}");
      return false;
    }

    //db.execute("Insert into $table_name()");
  }

  Future<bool> UpdateRecord(ModelStudent modelStudent) async {
    try {
      Database db = await database;
      db.update(table_name, modelStudent.toMap(),
          where: "$id=?", whereArgs: [modelStudent.id]);
      return true;
    } catch (e) {
      print("Database Error in update !${e.toString()}");
      return false;
    }
  }

  Future<bool> DeleteRecord(String record_id) async {
    try {
      Database db = await database;
      db.delete(table_name, where: "$id=?", whereArgs: [record_id]);
      return true;
    } catch (e) {
      print("Database Error in single deletion!${e.toString()}");
      return false;
    }
  }

  Future<bool> DeleteAllRecord(ModelStudent modelStudent) async {
    try {
      Database db = await database;
      db.delete(
        table_name,
      );
      return true;
    } catch (e) {
      print("Database Error in all deletion!${e.toString()}");
      return false;
    }
  }

  Future<List<ModelStudent>> GetAllRecord() async {
    List<ModelStudent> list_student = [];
    try {
      Database db = await database;
      List<Map<String, dynamic>> listMap = await db.query(table_name);

      listMap.forEach((Map<String, dynamic> element) {
        ModelStudent modelStudent = ModelStudent.fromMap(element);

        list_student.add(modelStudent);
//        Load();
      });
      //print("${list_student.length}");
      return list_student;
    } catch (e) {
      //print("Database Error!${e.toString()}");
      return list_student;
    }
  }

  Future<bool> GetSingleRecord(ModelStudent modelStudent) async {
    try {
      Database db = await database;
      db.insert(table_name, modelStudent.toMap());
      return true;
    } catch (e) {
      print("Database Error!${e.toString()}");
      return false;
    }
  }
}
