import 'package:daily_schedules/shared/data_layer/models/interface_shared.dart';
import 'package:equatable/equatable.dart';

class Category extends Equatable implements IShared{
  @override
  final String id;

  final String name;

  @override
  final DateTime addedTime;

  const Category({
    required this.id,
    required this.name,
    required this.addedTime,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [id, name, addedTime];


}