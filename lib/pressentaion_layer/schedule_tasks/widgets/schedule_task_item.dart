import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:daily_schedules/business_layer/schedule_task/schedule_task_cubit.dart';
import 'package:daily_schedules/shared/constants/colors.dart';
import 'package:daily_schedules/shared/constants/components.dart';
import 'package:daily_schedules/shared/constants/routes.dart';
import 'package:daily_schedules/shared/data_layer/models/schedule_task_model.dart';

class ScheduleTaskItem extends StatelessWidget {
  final ScheduleTask scheduleTask;
  final int index;
  final DateTime dailyScheduleDate;

  const ScheduleTaskItem({this.index = 0, required this.scheduleTask, required this.dailyScheduleDate, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        navigateTo(context, newTaskRoute, arguments:
            [false /* Is New */,  scheduleTask]
        );
        },
      child: Container(
        padding: const EdgeInsetsDirectional.only(start: 10, end: 10, top: 5, bottom: 5),
        margin: const EdgeInsetsDirectional.only(top: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 3,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Container(
                  height: 25 ,
                  width: 25,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 3,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text("${index+1}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                ),
                const Spacer(),
                IconButton(
                    onPressed: (){
                      ScheduleTaskCubit.get(context).deleteScheduleTask(scheduleTask);
                    },
                    icon: const Icon(Icons.close))                                ],
            ),
            Text(scheduleTask.title.toUpperCase(), maxLines: null, style: const TextStyle(fontSize: 18),),
            const Divider(),
            Row(
              children: [
                const Row(
                  children: [
                    Icon(CupertinoIcons.clock) ,
                    SizedBox(width: 5,),
                    Text("from", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                  ],
                ),
                const Spacer(),
                Container(
                  padding: EdgeInsetsDirectional.symmetric(horizontal: 5, vertical: 3),
                  color: mainColor,
                  child: Text(
                    "${DateFormat("HH:mm a").parse(scheduleTask.from).hour}:${DateFormat("HH:mm a").parse(scheduleTask.from).minute} ${DateFormat("HH").parse(scheduleTask.from).hour < 12 ? 'AM' : 'PM'} ",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                )
              ],
            ),
            const Divider(),
            Row(
              children: [
                const Row(
                  children: [
                    Icon(CupertinoIcons.clock) ,
                    SizedBox(width: 5,),
                    Text("to", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                  ],
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsetsDirectional.symmetric(horizontal: 5, vertical: 3),
                  color: mainColor,
                  child: Text(
                      "${DateFormat("HH:mm a").parse(scheduleTask.to).hour}:${DateFormat("HH:mm a").parse(scheduleTask.to).minute} ${DateFormat("HH").parse(scheduleTask.to).hour < 12 ? 'AM' : 'PM'} ",
                     style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                )
              ],
            ),
            const Divider(),
            Text(scheduleTask.description),
            Container(
              margin: const EdgeInsetsDirectional.only(top: 10),
              padding: const EdgeInsetsDirectional.all(5),
              decoration: BoxDecoration(
                color: getSentenceOfWhenTimeWillStart() == "Finished" ? Colors.redAccent : getSentenceOfWhenTimeWillStart() == "Started" ? Colors.green : CupertinoColors.link,
              ),
              child: Text(getSentenceOfWhenTimeWillStart(),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
            ),
            ConditionalBuilder(
              condition: getSentenceOfHowManyTimeToFinish() != null,
              builder: (BuildContext context) =>
                  Container(
                    margin: const EdgeInsetsDirectional.only(top: 10),
                    padding: const EdgeInsetsDirectional.all(5),
                    decoration: const BoxDecoration(
                      color: Colors.green,
                    ),
                    child: Text(getSentenceOfHowManyTimeToFinish()!,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  ),
              fallback: (BuildContext context) => Container(),
            ),
          ],
        ),
      ),
    );
  }

  bool isCurrentDateBeforeScheduleDate(){
    DateTime currentDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    DateTime scheduleDate = DateTime(dailyScheduleDate.year, dailyScheduleDate.month, dailyScheduleDate.day);

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

  String getSentenceOfWhenTimeWillStart(){
    String sentence;
  if(! isCurrentDateBeforeScheduleDate()){
    sentence = "Finished";
    return sentence;
    }
    else{
      Duration differentBetweenFromAndCurrentDate = DateTime(dailyScheduleDate.year, dailyScheduleDate.month, dailyScheduleDate.day, DateFormat("HH").parse(scheduleTask.from).hour, DateFormat("HH:mm a").parse(scheduleTask.from).minute, DateFormat("HH:mm a").parse(scheduleTask.from).second).difference(DateTime.now());
      Duration differentBetweenToAndCurrentDate = DateTime(dailyScheduleDate.year, dailyScheduleDate.month, dailyScheduleDate.day, DateFormat("HH").parse(scheduleTask.to).hour, DateFormat("HH:mm a").parse(scheduleTask.to).minute, DateFormat("HH:mm a").parse(scheduleTask.to).second).difference(DateTime.now());

      return differentBetweenToAndCurrentDate.inMinutes < 0 ? "Finished" : differentBetweenFromAndCurrentDate.inMinutes <= 0 ? "Started" : "Start in ${differentBetweenFromAndCurrentDate.inMinutes < 60 ? "${ differentBetweenFromAndCurrentDate.inMinutes } Minutes" : "${differentBetweenFromAndCurrentDate.inMinutes~/60} Hours"}";
    }
  }

  String? getSentenceOfHowManyTimeToFinish(){
    String sentence = getSentenceOfWhenTimeWillStart();
    if(sentence == "Started"){
      DateTime currentTime = DateTime.now();
      DateTime toTime = DateTime(dailyScheduleDate.year, dailyScheduleDate.month, dailyScheduleDate.day, DateFormat("HH").parse(scheduleTask.to).hour, DateFormat("HH:mm a").parse(scheduleTask.to).minute, DateFormat("HH:mm a").parse(scheduleTask.to).second);

      Duration differentBetweenToAndcurrentDate = toTime.difference(currentTime);

      if(differentBetweenToAndcurrentDate.inMinutes <= 0){
        return null;
      }
      else{
        return
          "Remain ${differentBetweenToAndcurrentDate.inMinutes < 60 ? "${ differentBetweenToAndcurrentDate.inMinutes } Minutes" : "${differentBetweenToAndcurrentDate.inMinutes~/60} Hours"} to finish";
      }
    }
    else{
      return null;
    }
  }

  }
