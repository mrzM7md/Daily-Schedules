import 'package:daily_schedules/shared/data_layer/models/interface_shared.dart';
import 'package:equatable/equatable.dart';

class CategoryDailySchedule extends Equatable implements IShared{

  @override
  final String id;

  final String categoryId, dailyScheduleId;

  @override
  final DateTime addedTime;

  CategoryDailySchedule(
      {
        required this.id,
        required this.categoryId,
        required this.dailyScheduleId,
        required this.addedTime,
      });

  @override
  List<Object?> get props => [id, categoryId, dailyScheduleId, addedTime,];

}