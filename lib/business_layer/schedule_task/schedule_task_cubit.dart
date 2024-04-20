import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:daily_schedules/business_layer/schedule_task/schedule_task_states.dart';
import 'package:daily_schedules/data_layer/schedule_tasks/delete/d_delete_schedule_task.dart';
import 'package:daily_schedules/data_layer/schedule_tasks/get/d_get_daily_schedule.dart';
import 'package:daily_schedules/data_layer/schedule_tasks/insert/d_insert_sub_daily_tasks.dart';
import 'package:daily_schedules/data_layer/schedule_tasks/update/d_update_schedule_task.dart';
import 'package:daily_schedules/shared/data_layer/models/schedule_task_model.dart';
import 'package:uuid/uuid.dart';

class ScheduleTaskCubit extends Cubit<ScheduleTaskStates> {
  GetScheduleTasksDBServices getScheduleTasksDBServices;
  InsertScheduleTasksDBServices insertScheduleTasksDBServices;
  UpdateScheduleTasksDBServices updateScheduleTasksDBServices;
  DeleteScheduleTasksDBServices deleteScheduleTasksDBServices;

  ScheduleTaskCubit(
      this.getScheduleTasksDBServices,
      this.insertScheduleTasksDBServices,
      this.updateScheduleTasksDBServices,
      this.deleteScheduleTasksDBServices)
      : super(InitialScheduleTaskState());

  static ScheduleTaskCubit get(context) => BlocProvider.of(context);

  List<ScheduleTask> allScheduleTasks = [];

  Future<List<ScheduleTask>> getAllTasksByScheduleId(id) async {
    await getScheduleTasksDBServices.getAllTasksByScheduleId(id).then((allScheduleTasks) {
      this.allScheduleTasks = allScheduleTasks;
      emit(GetAllScheduleTasksState(allScheduleTasks: allScheduleTasks));
    }) ;
    return allScheduleTasks;
  }

  int _count = 0;
  int getScheduleTasksCountByScheduleId(String scheduleId) {
    getScheduleTasksDBServices.getScheduleTasksCountByScheduleId(scheduleId).then(
        (value) {
          _count = value;
          emit(GetTasksCountState(count: _count, scheduleId: scheduleId));
        }
    );
    return _count;
  }

  void insertScheduleTaskByScheduleId(ScheduleTask scheduleTask){
    insertScheduleTasksDBServices.insertTaskByScheduleId(scheduleTask).then((value) =>
      getAllTasksByScheduleId(scheduleTask.dailyScheduleId)
    );
  }

  void updateScheduleTaskByScheduleId(ScheduleTask scheduleTask){
    insertScheduleTasksDBServices.insertTaskByScheduleId(scheduleTask).then((value) =>
        getAllTasksByScheduleId(scheduleTask.dailyScheduleId)
    );
  }

  void changeFromTime(){
    emit(ChangeFromTimeState());
  }

  void changeToTime(){
    emit(ChangeToTimeState());
  }

  void updateScheduleTask(ScheduleTask scheduleTask){
    updateScheduleTasksDBServices.update(scheduleTask).then((value) => getAllTasksByScheduleId(scheduleTask.dailyScheduleId));
  }

  void deleteScheduleTask(ScheduleTask scheduleTask){
    deleteScheduleTasksDBServices.deleteById(scheduleTask.id).then((value) => getAllTasksByScheduleId(scheduleTask.dailyScheduleId));
  }


}