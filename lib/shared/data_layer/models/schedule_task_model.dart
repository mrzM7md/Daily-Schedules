import 'package:daily_schedules/shared/data_layer/models/interface_shared.dart';
import 'package:equatable/equatable.dart';

class ScheduleTask extends Equatable implements IShared{
  @override
  final String id;

  final String dailyScheduleId, title, description, from, to;

  @override
  final DateTime addedTime;

  const ScheduleTask({
      required this.id,
      required this.dailyScheduleId,
      required this.title,
      required this.description,
      required this.from,
      required this.to,
      required this.addedTime,
  });

  @override
  List<Object?> get props => [id, dailyScheduleId, title, description, from, to, addedTime];

}
