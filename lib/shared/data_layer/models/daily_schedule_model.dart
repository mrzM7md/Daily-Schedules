import 'package:daily_schedules/shared/data_layer/models/interface_shared.dart';
import 'package:equatable/equatable.dart';

class DailySchedule extends Equatable implements IShared{
  @override
  final String id;

  final String title, description;
  final DateTime date;

  final bool isFavorite;

  @override
  final DateTime addedTime;

  DailySchedule(this.isFavorite,
      {
        required this.id,
        required this.title,
        required this.description,
        required this.date,
        required this.addedTime,
      });

  @override
  List<Object?> get props => [isFavorite, id, title, description, date, addedTime];



}
