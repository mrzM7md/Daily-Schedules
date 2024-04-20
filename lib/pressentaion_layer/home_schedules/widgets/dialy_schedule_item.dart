import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:daily_schedules/business_layer/daily_schedule/daily_schedule_cubit.dart';
import 'package:daily_schedules/business_layer/daily_schedule/daily_schedule_states.dart';
import 'package:daily_schedules/business_layer/schedule_task/schedule_task_cubit.dart';
import 'package:daily_schedules/business_layer/schedule_task/schedule_task_states.dart';
import 'package:daily_schedules/shared/constants/colors.dart';
import 'package:daily_schedules/shared/constants/components.dart';
import 'package:daily_schedules/shared/constants/routes.dart';
import 'package:daily_schedules/shared/data_layer/models/daily_schedule_model.dart';

class DailyScheduleItem extends StatelessWidget {
  final DailySchedule dailySchedule;

  const DailyScheduleItem({super.key, required this.dailySchedule});

  @override
  Widget build(BuildContext context) {
    DailyScheduleCubit.get(context)
        .getAllCategoryDailyRelation(dailySchedule.id);
    ScheduleTaskCubit.get(context).getScheduleTasksCountByScheduleId(dailySchedule.id);

    List<String> categoriesIds = [''];

    return InkWell(
      onTap: () {
        navigateTo(context, scheduleDetailRoute,
            arguments: [/* is new */ false, dailySchedule, categoriesIds]);
      },
      child: Container(
        margin:
            const EdgeInsetsDirectional.symmetric(horizontal: 8, vertical: 5),
        padding: const EdgeInsetsDirectional.all(10),
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Text(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    dailySchedule.title,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      decoration: ! isCurrentDateBeforeScheduleDate()
                          ? TextDecoration.lineThrough
                          : null,
                      // decorationColor: Colors.black,
                      // decorationThickness: 2.0,
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Text(
                    textAlign: TextAlign.end,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    "${dailySchedule.date.day} ${DateFormat("EEEE | MMMM | yyyy").format(dailySchedule.date)}",
                    style: TextStyle(
                      fontSize: 11.0,
                      fontWeight: FontWeight.bold,
                      decoration: ! isCurrentDateBeforeScheduleDate()
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  CupertinoIcons.tags_solid,
                  color: mainColor,
                  size: 18,
                ),
                const SizedBox(
                  width: 7,
                ),
                BlocConsumer<DailyScheduleCubit, DailyScheduleState>(
                  listener: (BuildContext context, DailyScheduleState state) {
                    if (state is GetCategoriesRelated &&
                        state.dailyScheduleId == dailySchedule.id) {
                      categoriesIds = state.categoriesIds;
                    }
                  },
                  builder: (context, state) {
                    return SizedBox(
                      width: 280,
                      child: Text(
                        state is GetCategoriesRelated
                            ? state.categoriesText
                            : '',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                          decoration:
                          ! isCurrentDateBeforeScheduleDate()                                  ? TextDecoration.lineThrough
                                  : null,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    );
                  },
                  buildWhen: (prev, current) =>
                      current is GetCategoriesRelated &&
                      current.dailyScheduleId == dailySchedule.id,
                ),
              ],
            ),
            const Spacer(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(
                  dailySchedule.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: mainColor,
                  size: 18,
                ),
                const SizedBox(
                  width: 7,
                ),
                Text(
                  "Created At ${DateFormat("EEEE | MMMM | yyyy | HH:mm").format(dailySchedule.addedTime)}",
                  style: TextStyle(
                    fontSize: 10,
                    decoration: ! isCurrentDateBeforeScheduleDate()
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                const Spacer(),
                Container(
                    padding: const EdgeInsetsDirectional.all(5),
                    decoration: BoxDecoration(
                        color: mainColor,
                        borderRadius: BorderRadius.circular(15)),
                    child: BlocBuilder<ScheduleTaskCubit, ScheduleTaskStates>(
                      builder: (context, state) {
                        return Text(
                          state is GetTasksCountState ? state.count.toString() +" Tasks" : "0 Tasks",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            decoration:
                            ! isCurrentDateBeforeScheduleDate()                                    ? TextDecoration.lineThrough
                                    : null,
                          ),
                        );
                      },
                      buildWhen: (prev, current) => current is GetTasksCountState && current.scheduleId == dailySchedule.id,
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }

  bool isCurrentDateBeforeScheduleDate(){
    DateTime currentDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    DateTime scheduleDate = DateTime(dailySchedule.date.year, dailySchedule.date.month, dailySchedule.date.day);

    if(currentDate.isAtSameMomentAs(scheduleDate)){
      return true;
    }
    else{
      if(currentDate.isAfter(scheduleDate)){{
        return false;
      }}
      else {
          return true;
        }
    }
  }

}
