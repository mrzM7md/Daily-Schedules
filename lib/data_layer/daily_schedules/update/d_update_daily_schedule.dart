import 'package:daily_schedules/data_layer/shared/interface_update_shared.dart';
import 'package:daily_schedules/shared/constants/tables_names.dart';
import 'package:daily_schedules/shared/data_layer/models/daily_schedule_model.dart';
import 'package:daily_schedules/shared/local/sqldb.dart';

import '../../../shared/services/services_locator.dart';

class UpdateDailyScheduleDBServices extends IUpdateShared<DailySchedule> {
  @override
  Future<void> update(DailySchedule dailySchedule) async {
    await sl<SqlDb>().updateData(
      """
        UPDATE '$dailySchedules' SET 
          title = '${dailySchedule.title}', 
          description = '${dailySchedule.description}', 
          date = '${dailySchedule.date}'
        WHERE id = '${dailySchedule.id}'
      """
    );
  }

  @override
  Future<void> updateIsFavorite({required bool isFavorite, required String modelId}) async {
    await sl<SqlDb>().updateData(
        """
        UPDATE '$dailySchedules'
          SET is_favorite = ${isFavorite ? 1 : 0}
        WHERE id = '$modelId'
      """
    );
  }


}
