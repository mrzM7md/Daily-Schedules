import 'package:daily_schedules/business_layer/daily_schedule/daily_schedule_cubit.dart';
import 'package:daily_schedules/business_layer/schedule_task/schedule_task_cubit.dart';
import 'package:daily_schedules/business_layer/schedule_task/schedule_task_states.dart';
import 'package:daily_schedules/data_layer/categories/delete/d_delete_categories.dart';
import 'package:daily_schedules/data_layer/categories/get/d_get_categories.dart';
import 'package:daily_schedules/data_layer/categories/insert/d_insert_categories.dart';
import 'package:daily_schedules/data_layer/categories_daily_schedule/delete/d_delete_categories_daily_schedule.dart';
import 'package:daily_schedules/data_layer/categories_daily_schedule/get/d_get_categories_daily_schedule.dart';
import 'package:daily_schedules/data_layer/categories_daily_schedule/insert/d_insert_categories_daily_schedule.dart';
import 'package:daily_schedules/data_layer/daily_schedules/delete/d_delete_daily_schedule.dart';
import 'package:daily_schedules/data_layer/daily_schedules/get/d_get_daily_schedule.dart';
import 'package:daily_schedules/data_layer/daily_schedules/insert/d_insert_daily_schedule.dart';
import 'package:daily_schedules/data_layer/daily_schedules/update/d_update_daily_schedule.dart';
import 'package:daily_schedules/data_layer/schedule_tasks/delete/d_delete_schedule_task.dart';
import 'package:daily_schedules/data_layer/schedule_tasks/get/d_get_daily_schedule.dart';
import 'package:daily_schedules/data_layer/schedule_tasks/insert/d_insert_sub_daily_tasks.dart';
import 'package:daily_schedules/data_layer/schedule_tasks/update/d_update_schedule_task.dart';

class DailyScheduleHelper {
  late GetDailyScheduleDBServices getDailyScheduleDBServices;
  late GetCategoriesDBServices getCategoriesDBServices;
  late GetCategoriesDailyScheduleDBServices getCategoriesDailyScheduleDBServices;

  late InsertDailyScheduleDBServices insertDailyScheduleDBServices;
  late InsertCategoriesDBServices insertCategoriesDBServices;
  late InsertCategoriesDailyScheduleDBServices insertCategoriesDailyScheduleDBServices;

  late UpdateDailyScheduleDBServices updateDailyScheduleDBServices;

  late DeleteDailyScheduleDBServices deleteDailyScheduleDBServices;
  late DeleteCategoriesDailyScheduleDBServices deleteCategoriesDailyScheduleDBServices;
  late DeleteCategoriesDBServices deleteCategoriesDBServices;

  late DailyScheduleCubit dailyTaskCubit;

  DailyScheduleHelper(){
    {
      getDailyScheduleDBServices = GetDailyScheduleDBServices();
      getCategoriesDBServices = GetCategoriesDBServices();
      getCategoriesDailyScheduleDBServices = GetCategoriesDailyScheduleDBServices();

      insertDailyScheduleDBServices = InsertDailyScheduleDBServices();
      insertCategoriesDBServices = InsertCategoriesDBServices();
      insertCategoriesDailyScheduleDBServices = InsertCategoriesDailyScheduleDBServices();

      updateDailyScheduleDBServices = UpdateDailyScheduleDBServices();

      deleteDailyScheduleDBServices = DeleteDailyScheduleDBServices();
      deleteCategoriesDailyScheduleDBServices = DeleteCategoriesDailyScheduleDBServices();
      deleteCategoriesDBServices = DeleteCategoriesDBServices();

      dailyTaskCubit =
          DailyScheduleCubit(getDailyScheduleDBServices, insertDailyScheduleDBServices, getCategoriesDBServices, insertCategoriesDBServices, insertCategoriesDailyScheduleDBServices, getCategoriesDailyScheduleDBServices, deleteCategoriesDailyScheduleDBServices, updateDailyScheduleDBServices, deleteCategoriesDBServices, deleteDailyScheduleDBServices);
    }
  }
  dailyTaskValue() => dailyTaskCubit;
}

class ScheduleTaskHelper {
  late GetScheduleTasksDBServices getScheduleTasksDBServices;
  late ScheduleTaskCubit scheduleTaskCubit;
  late InsertScheduleTasksDBServices insertScheduleTasksDBServices;
  late UpdateScheduleTasksDBServices updateScheduleTasksDBServices;
  late DeleteScheduleTasksDBServices deleteScheduleTasksDBServices;

  ScheduleTaskHelper() {
    getScheduleTasksDBServices = GetScheduleTasksDBServices();
    insertScheduleTasksDBServices = InsertScheduleTasksDBServices();
    updateScheduleTasksDBServices = UpdateScheduleTasksDBServices();
    deleteScheduleTasksDBServices = DeleteScheduleTasksDBServices();

    scheduleTaskCubit = ScheduleTaskCubit(getScheduleTasksDBServices, insertScheduleTasksDBServices, updateScheduleTasksDBServices, deleteScheduleTasksDBServices);
  }
  scheduleTaskValue() => scheduleTaskCubit;
}