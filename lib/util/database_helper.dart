import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:calendar_event/modal/event_vo.dart';

class Database_helper {

  //static final _databaseName = "calendar_event";
  static final _databaseVesrion = 1;
  static final table = "event";
  static final ColumnId = "id";
  static final ColumnEventName = "eventName";
  static final ColumnDateTime = "eventdate";

  Database_helper._private();
  static final Database_helper instance = Database_helper._private();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await initDatabase();
      return _database;
    }
  }

  initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'calendarevent.db');
    return openDatabase(path,
        version: _databaseVesrion, onCreate: _CreateDatabase);
  }

  Future _CreateDatabase(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table(
            $ColumnId INTEGER PRIMARY KEY,
            $ColumnEventName TEXT,
            $ColumnDateTime TEXT)
          
          ''');
  }

  /// INTEGER DEFAULT (cast(strftime('%Y-%m-%d','now') as int)


  Future<int> insert(EventCalendarVo vo) async {
    Database db = await instance.database;

    int result = await db.insert(table, vo.toMap());
    return result;
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return db.update(table, row, where: "$ColumnId=?", whereArgs: [row["id"]]);
  }

  Future<List<Map<String, dynamic>>> read() async {
    Database db = await instance.database;
    return db.query(table);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return db.delete(table, where: "$ColumnId=?", whereArgs: [id]);
  }
  Future<List<Map<String, dynamic>>> readDateByEntry({String date}) async {
    Database db = await instance.database;
    return db.query(table,where: "$ColumnDateTime=?",whereArgs: [date]);
  }



}
