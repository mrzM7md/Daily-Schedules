import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:daily_schedules/business_layer/schedule_task/schedule_task_cubit.dart';
import 'package:daily_schedules/business_layer/schedule_task/schedule_task_states.dart';
import 'package:daily_schedules/shared/constants/colors.dart';
import 'package:daily_schedules/shared/constants/components.dart';
import 'package:daily_schedules/shared/data_layer/models/schedule_task_model.dart';

class ScheduleTaskPage extends StatelessWidget {
  final ScheduleTask scheduleTask;
  final bool isNew;

  ScheduleTaskPage(this.isNew, this.scheduleTask, {super.key});

  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var scheduleTaskCubit = ScheduleTaskCubit.get(context);

    String lastTitle = scheduleTask.title;
    String lastDesc = scheduleTask.description;

    String from = scheduleTask.from;
    String to = scheduleTask.to;

    _titleController.text = lastTitle;
    _descController.text = scheduleTask.description;

    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
      save(context, from, to, lastTitle, lastDesc);
      return;
    },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mainColor,
          title: Text(scheduleTask.title),
          centerTitle: true,
          // actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.save))],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsetsDirectional.all(15),
            child: Column(
              children: [
                buildTitleWithField(
                    title: "New Task",
                    controller: _titleController,
                    placeholder: "ex: (math, play football, read book)"),
                Container(
                    margin: const EdgeInsetsDirectional.only(top: 10, bottom: 10),
                    child: const Divider()),
                Row(
                  children: [
                    const Icon(CupertinoIcons.clock),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text(
                      "from",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const Spacer(),
                    Container(
                      width: 120,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: mainColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: InkWell(
                        onTap: () {
                          showTimePicker(
                            context: context,
                            initialTime: TimeOfDay(
                                hour: DateFormat("HH")
                                    .parse(from)
                                    .hour,
                                minute: DateFormat("HH:mm a")
                                    .parse(from)
                                    .minute
                            ),
                          ).then((value) {
                            from =
                                "${value!.hour}:${value.minute} ${value.hour < 12 ? 'AM' : 'PM'}";

                            scheduleTaskCubit.changeFromTime();
                          });
                        },
                        child: BlocBuilder<ScheduleTaskCubit, ScheduleTaskStates>(
                          builder: (context, state) {
                            return Text(
                              "${DateFormat("h:mm a").parse(from).hour}:${DateFormat("h:mm a").parse(from).minute} ${DateFormat("HH").parse(from).hour < 12 ? 'AM' : 'PM'}",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            );
                          },
                          buildWhen: (prev, current) => current is ChangeFromTimeState,
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                    margin: const EdgeInsetsDirectional.only(top: 10, bottom: 10),
                    child: const Divider()),
                Row(
                  children: [
                    const Icon(CupertinoIcons.clock),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text(
                      "to",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const Spacer(),
                    Container(
                      width: 120,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: mainColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: InkWell(
                        onTap: () {
                          showTimePicker(
                            context: context,
                            initialTime: TimeOfDay(
                                hour: DateFormat("HH")
                                    .parse(to)
                                    .hour,
                                minute: DateFormat("HH:mm a")
                                    .parse(to)
                                    .minute),
                          ).then((value) {
                            to =
                            "${value!.hour}:${value.minute} ${value.hour < 12 ? 'AM' : 'PM'}";
                            scheduleTaskCubit.changeToTime();
                          });
                        },
                        child: BlocBuilder<ScheduleTaskCubit, ScheduleTaskStates>(
                          builder: (context, state) {
                            return Text(
                              "${DateFormat("h:mm a").parse(to).hour}:${DateFormat("h:mm a").parse(to).minute} ${DateFormat("HH").parse(to).hour < 12 ? 'AM' : 'PM'}",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            );
                          },
                          buildWhen: (prev, current) => current is ChangeToTimeState,
                        ),
                      ),
                    )
                  ],
                ),
                const Divider(),
                buildTitleWithField(
                    isForDescription: true,
                    title: 'Description',
                    controller: _descController,
                    placeholder: 'What will you do in this task?')
              ],
            ),
          ),
        ),
      ),
    );
  }

  void save(context, String from, String to, String lastTitle, String lastDesc){
    var scheduleTaskCubit = ScheduleTaskCubit.get(context);
    if(! isDataNotEdited(from, to, lastTitle, lastDesc)){
      ScheduleTask st = ScheduleTask(
          id: scheduleTask.id,
          dailyScheduleId: scheduleTask.dailyScheduleId,
          title: _titleController.text,
          description: _descController.text,
          from: from,
          to: to,
          addedTime: DateTime.now()
      );

      if(isNew){
        scheduleTaskCubit.insertScheduleTaskByScheduleId(
          st,
        );
      }
      else{
        scheduleTaskCubit.updateScheduleTask(
            st,
        );
      }
      getToast(
          message: "Done",
          bkgColor: Colors.white,
          textColor: Colors.black
      );
    }
  }

  bool isDataNotEdited(String from, String to, String lastTitle, String lastDesc) =>
      from == scheduleTask.from && to == scheduleTask.to && lastTitle == _titleController.text && lastDesc == _descController.text
  ;

}
