import 'package:intl/intl.dart';
import 'package:daily_schedules/shared/constants/tables_names.dart';
import 'package:daily_schedules/shared/data_layer/models/category_daily_schedule_model.dart';
import 'package:daily_schedules/shared/local/sqldb.dart';

import '../../../shared/services/services_locator.dart';

class GetCategoriesDailyScheduleDBServices{
    Future<List<CategoryDailySchedule>> getAll() async {
    List<CategoryDailySchedule> items = [];

    List<Map> response = await sl<SqlDb>().readData("SELECT * FROM '$categoriesDailySchedules'");

    for (Map res in response){
      items.add(CategoryDailySchedule(
        id: res['id'],
        categoryId: res['category_id'],
        dailyScheduleId: res['daily_schedule_id'],
        addedTime: DateFormat('yyyy-MM-dd HH:mm:ss').parse(res['added_time']),
      ));
    }

    return items;
  }

}