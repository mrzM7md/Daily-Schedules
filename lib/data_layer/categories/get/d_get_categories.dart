import 'package:intl/intl.dart';
import 'package:daily_schedules/shared/constants/tables_names.dart';
import 'package:daily_schedules/shared/data_layer/models/category_model.dart';
import 'package:daily_schedules/shared/local/sqldb.dart';

import '../../../shared/services/services_locator.dart';

class GetCategoriesDBServices{
  @override
  Future<List<Category>> getAll() async {
    List<Category> items = [];

    List<Map> response = await sl<SqlDb>().readData("SELECT * FROM '$categories' ORDER BY added_time DESC");

    for (Map res in response){
      items.add(Category(
        id: res['id'],
        name: res['name'],
        addedTime: DateFormat('yyyy-MM-dd HH:mm:ss').parse(res['added_time']),
      ));
    }

    return items;
  }

  Future<List<Category>> getCategoriesRelated(String dailyTaskId) async {
    List<Category> items = [];

    List<Map> response = await sl<SqlDb>().readData("""
      SELECT c.id, c.name, c.added_time, d.title, cd.daily_schedule_id
      FROM 
      $categories c INNER JOIN  $categoriesDailySchedules cd
      ON cd.category_id = c.id
      INNER JOIN $dailySchedules d
      ON cd.daily_schedule_id = d.id AND cd.category_id = c.id
      WHERE d.id = '$dailyTaskId'
    """);

    for (Map res in response){
      items.add(Category(
        id: res['id'],
        name: res['name'],
        addedTime: DateFormat('yyyy-MM-dd HH:mm:ss').parse(res['added_time']),
      ));

      // print("dailyTaskId: " + dailyTaskId + " Name: " + res['name'] + "\n" + " id: "+res["id"]);
    }
    // print("--------------------");

    return items;
  }
}