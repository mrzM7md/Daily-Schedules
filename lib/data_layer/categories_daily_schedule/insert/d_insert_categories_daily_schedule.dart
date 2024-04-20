import 'package:daily_schedules/data_layer/shared/interface_insert_shared.dart';
import 'package:daily_schedules/shared/constants/tables_names.dart';
import 'package:daily_schedules/shared/data_layer/models/category_daily_schedule_model.dart';
import 'package:daily_schedules/shared/local/sqldb.dart';

import '../../../shared/services/services_locator.dart';

class InsertCategoriesDailyScheduleDBServices extends IInsertShared<CategoryDailySchedule> {
  @override
  Future<void> setAll(CategoryDailySchedule categoryDailySchedule) async {
    await sl<SqlDb>().insertData("""
      INSERT INTO '$categoriesDailySchedules' VALUES (
        '${categoryDailySchedule.id}',
        '${categoryDailySchedule.categoryId}',
        '${categoryDailySchedule.dailyScheduleId}',
        '${DateTime.now()}'
      )
    """);
  }
}