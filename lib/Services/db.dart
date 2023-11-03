import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {
  // настройки таблиц;
  static const dbname = "productDatabase.db";
  static const dbversion = 1;
  static const tablename = "products_db";
  static const columnId = "id";

  DB._privateConstructor();
  static final DB instance = DB._privateConstructor();

  // Если табличка не создан то создаем;
  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initiateDatabase();
    return _database;
  }
  //Инилизация;
  // static initiateDatabase() async {
  //   Directory directory = await getApplicationDocumentsDirectory();
  //   String path = join(directory.path, dbname);
  //   return await openDatabase(
  //       path,
  //       version: dbversion,
  //       onCreate: onCreate);
  // }

  static initiateDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, dbname);
    //
    return await openDatabase( path, version: dbversion,
        onCreate: (db, version) async {
          var batch = db.batch();
          _onCreateTable(batch);
          await batch.commit();
        },
        onDowngrade: onDatabaseDowngradeDelete
    );
  }

  // Создаем табличку;
  /*
  static Future onCreateTest(Database db, int dbversion) async {
    // return await db.execute('''
    //      CREATE TABLE $tablename ($columnId INTEGER PRIMARY KEY, title STRING,title STRING,title STRING,title STRING, )
    //   ''');
    return await db.execute('CREATE TABLE $tablename'
        '($columnId INTEGER PRIMARY KEY AUTOINCREMENT,, '
        'title STRING, '
        'category TEXT, '
        'price REAL, '
        'description TEXT, '
        'date_time STRING NOT NULL, '
        'image STRING)'
    );
  }
  */
  static _onCreateTable(Batch batch) {
    batch.execute('DROP TABLE IF EXISTS $tablename');
    batch.execute('CREATE TABLE $tablename'
        '($columnId INTEGER PRIMARY KEY AUTOINCREMENT, '
        'title STRING, '
        'category TEXT, '
        'price REAL, '
        'description TEXT, '
        'date_time STRING, '
        'is_sqf_lite INTEGER, '
        'image STRING)'
    );
  }

  // Создать запись
  // https://github.com/tekartik/sqflite/blob/master/sqflite/doc/migration_example.md
  static Future<int> insert(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert(tablename, row, conflictAlgorithm: ConflictAlgorithm.replace);
  }
  // static Future<void> insert(Map<String, dynamic> row) async {
  //   Database? db = await instance.database;
  //   db.insert(table, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  // }

  // Получить все записей;
  static Future<List<Map<String, dynamic>>> queryAll() async {
    Database? db = await instance.database;
    return await db!.query(tablename,orderBy: 'date_time DESC');
  }
  // Получить конкретный запись;
  static Future<List<Map<String, dynamic>>> queryOne(int id) async {
    Database? db = await instance.database;
    return await db!.query(tablename, where: '$columnId=?', whereArgs: [id]);
  }

  // Обновить запись;
  static Future<int> update(Map<String, dynamic> row) async {
       Database? db = await instance.database;
       int id = row[columnId];
       return await db!
         .update(tablename, row, where: '$columnId=?', whereArgs: [id]);
  }

  // Удалить запись;
  static Future<int> delete(int id) async {
    Database? db = await instance.database;
    return await db!.delete(tablename, where: '$columnId=?', whereArgs: [id]);
  }
  // Удалить все записи;
  static Future deleteAll() async {
    Database? db = await instance.database;
    return await db!.delete(tablename);
  }

  /*--------SQL запрос RAW--------*/
  // Получить запис;
  static Future queryRaw({required String sql, List? arg}) async {
    Database? db = await instance.database;
   // var res = await db!.rawQuery('SELECT * FROM $tablename WHERE id=?',[id]);
    return await db!.rawQuery(sql,arg ?? []);
  }
  // Создать SQL
  static Future insertRaw({required String sql, List? arg}) async {
    Database? db = await instance.database;
    return await db!.rawInsert(sql,arg ?? []);
  }

  // Обновить SQL
  static Future updateRaw({required String sql, List? arg}) async {
    Database? db = await instance.database;
    return await db!.rawUpdate(sql,arg ?? []);
  }

  // Удалить SQL
  static Future deleteRaw({required String sql, List? arg}) async {
    Database? db = await instance.database;
    return await db!.rawDelete(sql,arg ?? []);
  }
  // Закрыть БД;
  static Future close() async {
    Database? db = await instance.database;
    db?.close();
  }


}