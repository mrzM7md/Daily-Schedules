import 'package:intl/intl.dart';
import 'package:daily_schedules/shared/constants/tables_names.dart';
import 'package:daily_schedules/shared/data_layer/models/schedule_task_model.dart';
import 'package:daily_schedules/shared/local/sqldb.dart';

import '../../../shared/services/services_locator.dart';

class GetScheduleTasksDBServices {
  Future<List<ScheduleTask>> getAllTasksByScheduleId(String scheduleId) async {
    List<ScheduleTask> items = [];

    List<Map> response = await sl<SqlDb>().readData("SELECT * FROM '$scheduleTasks' WHERE daily_schedule_id='$scheduleId' ORDER BY added_time DESC");

    for (Map res in response){
      items.add(ScheduleTask(
        id: res['id'],
        title: res['title'],
        description: res['description'],
        from: res['from_time'],
        to: res['to_time'],
        dailyScheduleId: res['daily_schedule_id'],
        addedTime: DateFormat('yyyy-MM-dd HH:mm:ss').parse(res['added_time']),
      ));
    }
    return items;
  }

  Future<int> getScheduleTasksCountByScheduleId(String scheduleId) async {
     List<Map> response = await sl<SqlDb>().readData("SELECT COUNT(*) as count FROM '$scheduleTasks' WHERE daily_schedule_id='$scheduleId'");
     return response[0]['count'];
  }

}