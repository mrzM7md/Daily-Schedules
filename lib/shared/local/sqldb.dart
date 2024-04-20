import 'package:daily_schedules/shared/constants/tables_names.dart';
import 'package:daily_schedules/shared/local/cache_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlDb {

  static Database? _db;

  Future<Database?> get db async {
    if(_db == null){
      _db = await initialDb();
      return _db;
    }
    else {
      return _db;
    }
  }

  Future<Database> initialDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'schedules.db');
    Database myDb = await openDatabase(path, onCreate: _onCreate, version: 1, onUpgrade: _onUpgrade);
    return myDb;
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async{
    print("--------------- DATABASE UPGRADED ---------------");
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
        CREATE TABLE '$dailySchedules' (
        id TEXT PRIMARY KEY,
        title TEXT,
        description TEXT,
        date TEXT,
        added_time TEXT,
        is_favorite INTEGER
    )
    ''');
    await db.execute("""
        CREATE TABLE '$scheduleTasks' (
        id TEXT PRIMARY KEY,
        title TEXT,
        description TEXT,
        from_time TEXT,
        to_time TEXT,
        added_time TEXT,
        daily_schedule_id TEXT,
        FOREIGN KEY(daily_schedule_id) REFERENCES $dailySchedules(id) ON DELETE CASCADE
    )
    """);
    await db.execute("""
        CREATE TABLE '$categories' (
        id TEXT PRIMARY KEY,
        name TEXT,
        added_time TEXT
    )
    """);
    await db.execute("""
        CREATE TABLE '$categoriesDailySchedules' (
        id TEXT PRIMARY KEY,
        category_id TEXT,
        daily_schedule_id TEXT,
        added_time TEXT,
        FOREIGN KEY(category_id) REFERENCES $categories(id) ON DELETE CASCADE,
        FOREIGN KEY(daily_schedule_id) REFERENCES $dailySchedules(id) ON DELETE CASCADE
    )
    """);

    await CacheHelper.setData(key: 'dateAppInstalled', value: DateTime.now().toString());

    await _setFakeData();

    print("--------------- DATABASE CREATED ---------------");
  }

  Future<List<Map>> readData(String sql) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.rawQuery(sql);

    return response;
  }

  Future<int> insertData(String sql) async {
    Database? mydb = await db;

    int? response;
    await mydb?.transaction ((txn) async {
      response = await txn.rawInsert(sql);
      return null;
    });

    return response!;
  }


  Future<int> updateData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(sql);
    return response;
  }


  Future<int> deleteData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawDelete(sql);
    return response;
  }

  Future<void> _setFakeData() async {
    insertData("""
      INSERT INTO '$dailySchedules' VALUES (
        '1',
        'Exam Study Schedule',
        'This Schedule specific to organize my study of collage in this day between study and rest time !!',
        '${DateTime.now()}',
        '${DateTime.now()}',
         0
      )
    """);

    insertData("""
      INSERT INTO '$dailySchedules' VALUES (
        '2',
        'Refactor Project Schedule',
        'This Schedule specific to make time organize refactor code time in this day, when will to edit presentation layer code? data layer?',
        '${DateTime.now()}',
        '${DateTime.now()}',
         0
      )
    """);

    insertData("""
      INSERT INTO '$scheduleTasks' VALUES (
        '1',
        'Study Math Task',
        'Study only units 1 and 2..',
        '1:22 AM',
        '3:22 AM',
        '${DateTime.now()}',
        '1'
      )
    """);

    insertData("""
      INSERT INTO '$scheduleTasks' VALUES (
        '2',
        'Rest',
        'Watch Anime...',
        '3:30 AM',
        '10:5 AM',
        '${DateTime.now()}',
        '1'
      )
    """);

    insertData("""
      INSERT INTO '$scheduleTasks' VALUES (
        '3',
        'Study English Task',
        'Training on speaking skills and hearing from us English books',
        '11:05 AM',
        '13:05 PM',
        '${DateTime.now()}',
        '1'
      )
    """);

    insertData("""
      INSERT INTO '$scheduleTasks' VALUES (
        '4',
        'Refactor presentation layer',
        'First: refactor flutter widgets code, then go to business (bloc) and rename classes names',
        '1:2 AM',
        '2:22 AM',
        '${DateTime.now()}',
        '2'
      )
    """);

    insertData("""
      INSERT INTO '$scheduleTasks' VALUES (
        '5',
        'Refactor domain layer',
        'First: refactor contracts abstract class code (base repository), then go to use-cases classes to sync it with new refactor on repository, note: do not change any things in entities',
        '15:22 PM',
        '21:22 PM',
        '${DateTime.now()}',
        '2'
      )
    """);

    insertData("""
      INSERT INTO '$categories' VALUES (
        '1',
        'programming',
        '${DateTime.now()}'
      )
    """);

    insertData("""
      INSERT INTO '$categories' VALUES (
        '2',
        'code',
        '${DateTime.now()}'
      )
    """);

    insertData("""
      INSERT INTO '$categories' VALUES (
        '3',
        'study',
        '${DateTime.now()}'
      )
    """);

    insertData("""
      INSERT INTO '$categories' VALUES (
        '4',
        'college',
        '${DateTime.now()}'
      )
    """);

    insertData("""
      INSERT INTO '$categoriesDailySchedules' VALUES (
        '1',
        '1',
        '2',
        '${DateTime.now()}'
      )
    """);

    insertData("""
      INSERT INTO '$categoriesDailySchedules' VALUES (
        '2',
        '2',
        '2',
        '${DateTime.now()}'
      )
    """);

    insertData("""
      INSERT INTO '$categoriesDailySchedules' VALUES (
        '3',
        '3',
        '1',
        '${DateTime.now()}'
      )
    """);

    insertData("""
      INSERT INTO '$categoriesDailySchedules' VALUES (
        '4',
        '4',
        '1',
        '${DateTime.now()}'
      )
    """);
  }

}