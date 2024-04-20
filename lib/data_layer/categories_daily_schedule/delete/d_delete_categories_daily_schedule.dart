import 'package:daily_schedules/data_layer/shared/interface_delete_shared.dart';
import 'package:daily_schedules/data_layer/shared/interface_insert_shared.dart';
import 'package:daily_schedules/shared/constants/tables_names.dart';
import 'package:daily_schedules/shared/data_layer/models/category_daily_schedule_model.dart';

import '../../../shared/local/sqldb.dart';
import '../../../shared/services/services_locator.dart';

class DeleteCategoriesDailyScheduleDBServices extends IDeleteShared<CategoryDailySchedule> {
  @override
  Future<void> deleteById(String scheduleId) async {
    await sl<SqlDb>().deleteData("""
      DELETE FROM '$categoriesDailySchedules' WHERE daily_schedule_id = '$scheduleId'
    """) ;
  }

  @override
  void deleteAll() {}

}