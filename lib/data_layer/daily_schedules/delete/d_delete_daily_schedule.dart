import 'package:daily_schedules/data_layer//shared/interface_delete_shared.dart';
import 'package:daily_schedules/shared/constants/tables_names.dart';
import 'package:daily_schedules/shared/data_layer/models/daily_schedule_model.dart';
import 'package:daily_schedules/shared/local/sqldb.dart';

import '../../../shared/services/services_locator.dart';

class DeleteDailyScheduleDBServices extends IDeleteShared<DailySchedule> {
  @override
  void deleteAll() {
    // TODO: implement deleteAll
  }

  @override
  Future<void> deleteById(String id) async {
    await sl<SqlDb>().deleteData("""
      DELETE FROM '$dailySchedules' WHERE id = '$id'
    """);
  }

}
