import 'package:daily_schedules/shared/data_layer/models/schedule_task_model.dart';
import 'package:equatable/equatable.dart';

class ScheduleTaskStates{}

class InitialScheduleTaskState implements ScheduleTaskStates{}

class GetAllScheduleTasksState extends Equatable implements ScheduleTaskStates {
  final List<ScheduleTask> allScheduleTasks;
  const GetAllScheduleTasksState({required this.allScheduleTasks});

  @override
  List<Object?> get props => [allScheduleTasks];
}

class ChangeFromTimeState implements ScheduleTaskStates {}
class ChangeToTimeState implements ScheduleTaskStates {}

class GetTasksCountState extends Equatable implements ScheduleTaskStates{
  final int count;
  final String scheduleId;

  const GetTasksCountState({required this.count, required this.scheduleId});

  @override
  List<Object?> get props => [count, scheduleId];
}