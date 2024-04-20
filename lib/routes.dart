import 'package:flutter/material.dart';
import 'package:daily_schedules/main.dart';
import 'package:daily_schedules/pressentaion_layer/favorite/favorite_page.dart';
import 'package:daily_schedules/pressentaion_layer/home_schedules/home_schedules_page.dart';
import 'package:daily_schedules/pressentaion_layer/schedule_tasks/schedule_page.dart';
import 'package:daily_schedules/pressentaion_layer/schedule_tasks/schedule_task_page.dart';
import 'package:daily_schedules/pressentaion_layer/search_schedules/search_schedules_page.dart';
import 'package:daily_schedules/shared/constants/routes.dart';
import 'package:daily_schedules/shared/data_layer/models/daily_schedule_model.dart';
import 'package:daily_schedules/shared/data_layer/models/schedule_task_model.dart';

class AppPages {


  Widget generatePage(RouteSettings settings) {
    switch (settings.name) {
      case mainRoute:
        return MainPage();

      case schedulesRoute:
        final DailySchedule? dailyTask =
        settings.arguments == null ? null : settings.arguments as DailySchedule;

        return
          HomeSchedulesPage();

      case scheduleDetailRoute:
        final bool isNew = (settings.arguments as List) [0] as bool;
        final DailySchedule dailyTask = (settings.arguments as List) [1] as DailySchedule;
        final List<String> categoriesIds = (settings.arguments as List) [2] as List<String>;

        return SchedulePage(isNew, dailyTask, categoriesIds);

      case favoriteRoute:
        return FavoritePage();

      case searchRoute:
        return const SearchPage();

      case newTaskRoute:
        final bool isNew = (settings.arguments as List) [0] as bool;
        ScheduleTask scheduleTask = (settings.arguments as List)[1]  as ScheduleTask;
        return ScheduleTaskPage(isNew, scheduleTask);

      default:
        return Container();
    }
  }
}
