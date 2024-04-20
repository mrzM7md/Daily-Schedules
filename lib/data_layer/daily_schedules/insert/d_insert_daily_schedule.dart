import 'package:daily_schedules/data_layer/shared/interface_insert_shared.dart';
import 'package:daily_schedules/shared/constants/tables_names.dart';
import 'package:daily_schedules/shared/local/sqldb.dart';

import '../../../shared/data_layer/models/daily_schedule_model.dart';
import '../../../shared/services/services_locator.dart';

class InsertDailyScheduleDBServices extends IInsertShared<DailySchedule> {
  @override
  Future<void> setAll(DailySchedule dailySchedule) async {
    await sl<SqlDb>().insertData("""
      INSERT INTO '$dailySchedules' VALUES (
        '${dailySchedule.id}',
        '${dailySchedule.title}',
        '${dailySchedule.description}',
        '${dailySchedule.date}',
        '${DateTime.now()}',
        ${dailySchedule.isFavorite ? 1 : 0}
      )
    """);
  }
}