import 'package:daily_schedules/data_layer/shared/interface_update_shared.dart';
import 'package:daily_schedules/shared/constants/tables_names.dart';
import 'package:daily_schedules/shared/data_layer/models/schedule_task_model.dart';
import 'package:daily_schedules/shared/local/sqldb.dart';

import '../../../shared/services/services_locator.dart';

class UpdateScheduleTasksDBServices extends IUpdateShared<ScheduleTask> {
  @override
  Future<void> update(ScheduleTask scheduleTask) async {
    await sl<SqlDb>().updateData(
      """
        UPDATE '$scheduleTasks' SET 
          title = '${scheduleTask.title}', 
          description = '${scheduleTask.description}', 
          from_time = '${scheduleTask.from}', 
          to_time = '${scheduleTask.to}'
        WHERE id = '${scheduleTask.id}'
      """
    );
  }

  @override
  Future<void> updateIsFavorite({required bool isFavorite, required String modelId}) async {}
}
