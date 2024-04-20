import 'package:daily_schedules/data_layer/shared/interface_insert_shared.dart';
import 'package:daily_schedules/shared/constants/tables_names.dart';
import 'package:daily_schedules/shared/data_layer/models/schedule_task_model.dart';
import 'package:daily_schedules/shared/local/sqldb.dart';

import '../../../shared/services/services_locator.dart';

class InsertScheduleTasksDBServices {
  Future<void> insertTaskByScheduleId(ScheduleTask scheduleTask) async {
    await sl<SqlDb>().insertData("""
      INSERT INTO '$scheduleTasks' VALUES (
        '${scheduleTask.id}',
        '${scheduleTask.title}',
        '${scheduleTask.description}',
        '${scheduleTask.from}',
        '${scheduleTask.to}',
        '${DateTime.now()}',
        '${scheduleTask.dailyScheduleId}'
      )
    """);
  }
}