import 'package:daily_schedules/shared/data_layer/models/category_model.dart';
import 'package:daily_schedules/shared/data_layer/models/daily_schedule_model.dart';
import 'package:equatable/equatable.dart';

abstract class DailyScheduleState {}

class InitialDailyScheduleState implements DailyScheduleState{}

class GetAllDailySchedulesState extends Equatable implements DailyScheduleState{
  final List<DailySchedule> allDailySchedules;
  const GetAllDailySchedulesState({required this.allDailySchedules});
  @override
  List<Object?> get props => [allDailySchedules];
}

class GetAllDailySchedulesFoundState implements DailyScheduleState{
  final List<DailySchedule> allDailySchedulesFound;
  GetAllDailySchedulesFoundState({required this.allDailySchedulesFound});
}

class ChangeFavoriteState extends Equatable implements DailyScheduleState{
  final bool isFavorite;
  const ChangeFavoriteState({required this.isFavorite});
  @override
  List<Object?> get props => [isFavorite];
}

class ChangeFocusedDayState extends Equatable implements DailyScheduleState{
  final DateTime selectedDay;
  const ChangeFocusedDayState({required this.selectedDay});

  @override
  List<Object?> get props => [selectedDay];
}

class SaveLoadingScheduleState implements DailyScheduleState{}
class SaveSuccessScheduleState implements DailyScheduleState{}

class GetAllCategoriesState extends Equatable implements DailyScheduleState{
  final List<Category> allCategories;
  const GetAllCategoriesState({required this.allCategories});
  @override
  List<Object?> get props => [allCategories];
}

class SaveSuccessCategoryState implements DailyScheduleState{}

class CategoryClickedState extends Equatable implements DailyScheduleState{
  final String categoryId;
  const CategoryClickedState({required this.categoryId});

  @override
  List<Object?> get props => [categoryId];
}

class SaveSuccessCategoryDailyState implements DailyScheduleState{}

class GetCategoriesRelated extends Equatable implements DailyScheduleState{
  final String categoriesText, dailyScheduleId;
  final List<String> categoriesIds;

  const GetCategoriesRelated({required this.categoriesText, required this.categoriesIds, required this.dailyScheduleId});

  @override
  List<Object?> get props => [categoriesText, dailyScheduleId, categoriesIds];
}

class UpdatedFavoriteState implements DailyScheduleState {}