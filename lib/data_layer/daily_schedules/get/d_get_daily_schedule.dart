import 'package:intl/intl.dart';
import 'package:daily_schedules/data_layer//shared/interface_get_shared.dart';
import 'package:daily_schedules/shared/constants/tables_names.dart';
import 'package:daily_schedules/shared/data_layer/models/daily_schedule_model.dart';
import 'package:daily_schedules/shared/local/sqldb.dart';

import '../../../shared/services/services_locator.dart';

class GetDailyScheduleDBServices extends IGetShared<DailySchedule> {

  @override
  Future<List<DailySchedule>> find({required String keyWord}) async {
    List<DailySchedule> dailyTasks = await getAll();
    return dailyTasks.where((dt) => dt.title.toUpperCase().contains(keyWord.toUpperCase()) || dt.description.toUpperCase().contains(keyWord.toUpperCase())).toList();
  }


  @override
  Future<List<DailySchedule>> getAll() async {
    List<DailySchedule> items = [];

    List<Map> response = await sl<SqlDb>().readData("SELECT * FROM '$dailySchedules' ORDER BY added_time DESC");

    for (Map res in response){
      items.add(DailySchedule(
        res['is_favorite']  == 1 ? true : false,
        id: res['id'],
        title: res['title'],
        description: res['description'],
        date: DateFormat('yyyy-MM-dd HH:mm:ss').parse(res['date']),
        addedTime: DateFormat('yyyy-MM-dd HH:mm:ss').parse(res['added_time']),
      ));
    }
    print(items);
    return items;
  }

}