import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:daily_schedules/business_layer/daily_schedule/daily_schedule_states.dart';
import 'package:daily_schedules/data_layer/categories/delete/d_delete_categories.dart';
import 'package:daily_schedules/data_layer/categories/get/d_get_categories.dart';
import 'package:daily_schedules/data_layer/categories/insert/d_insert_categories.dart';
import 'package:daily_schedules/data_layer/categories_daily_schedule/delete/d_delete_categories_daily_schedule.dart';
import 'package:daily_schedules/data_layer/categories_daily_schedule/get/d_get_categories_daily_schedule.dart';
import 'package:daily_schedules/data_layer/categories_daily_schedule/insert/d_insert_categories_daily_schedule.dart';
import 'package:daily_schedules/data_layer/daily_schedules/delete/d_delete_daily_schedule.dart';
import 'package:daily_schedules/data_layer/daily_schedules/get/d_get_daily_schedule.dart';
import 'package:daily_schedules/data_layer/daily_schedules/insert/d_insert_daily_schedule.dart';
import 'package:daily_schedules/data_layer/daily_schedules/update/d_update_daily_schedule.dart';
import 'package:daily_schedules/shared/data_layer/models/category_daily_schedule_model.dart';
import 'package:daily_schedules/shared/data_layer/models/category_model.dart';
import 'package:daily_schedules/shared/data_layer/models/daily_schedule_model.dart';
import 'package:uuid/uuid.dart';


class DailyScheduleCubit extends Cubit<DailyScheduleState> {
  final GetDailyScheduleDBServices getDailySchedulesDBServices;
  final GetCategoriesDBServices getCategoriesDBServices;
  final GetCategoriesDailyScheduleDBServices getCategoriesDailySchedulesDBServices;

  final InsertDailyScheduleDBServices insertDailySchedulesDBServices;
  final InsertCategoriesDBServices insertCategoriesDBServices;
  final InsertCategoriesDailyScheduleDBServices insertCategoriesDailySchedulesDBServices;

  final UpdateDailyScheduleDBServices updateDailySchedulesDBServices;

  final DeleteDailyScheduleDBServices deleteDailySchedulesDBServices;
  final DeleteCategoriesDailyScheduleDBServices deleteCategoriesDailySchedulesDBServices;
  final DeleteCategoriesDBServices deleteCategoriesDBServices;

  DailyScheduleCubit(this.getDailySchedulesDBServices, this.insertDailySchedulesDBServices, this.getCategoriesDBServices, this.insertCategoriesDBServices, this.insertCategoriesDailySchedulesDBServices, this.getCategoriesDailySchedulesDBServices, this.deleteCategoriesDailySchedulesDBServices, this.updateDailySchedulesDBServices, this.deleteCategoriesDBServices, this.deleteDailySchedulesDBServices) : super(InitialDailyScheduleState());

  static DailyScheduleCubit get(context) => BlocProvider.of(context);

  DateTime choseDay = DateTime.now();

  List<DailySchedule> allDailySchedules = [];
  List<Category> allCategories = [];

  List<DailySchedule> getAllDailySchedules() {
    getDailySchedulesDBServices.getAll().then((allDailySchedules){
      emit(GetAllDailySchedulesState(allDailySchedules: allDailySchedules));
      this.allDailySchedules = allDailySchedules;
    });
    return allDailySchedules;
  }

  List<DailySchedule> findAllDailySchedules(String keyword) {
    getDailySchedulesDBServices.find(keyWord: keyword).then((allDailySchedules){
      emit(GetAllDailySchedulesState(allDailySchedules: allDailySchedules));
      this.allDailySchedules = allDailySchedules;
    });
    return allDailySchedules;
  }

  bool isFavorite = false;

  void changeFavoriteValue(){
    isFavorite = !isFavorite;
    emit(ChangeFavoriteState(isFavorite: isFavorite));
  }

  void changeChoseDay(selectedDay){
    choseDay = selectedDay;
    emit(ChangeFocusedDayState(selectedDay: selectedDay));
  }

  void insertDailyScheduleData(DailySchedule dailySchedule) async {
    emit(SaveLoadingScheduleState());
    insertDailySchedulesDBServices.setAll(dailySchedule).then((value) =>
        emit(SaveSuccessScheduleState()
    ));
  }

  void updateDailyScheduleData(DailySchedule dailySchedule) async {
    emit(SaveLoadingScheduleState());
    await updateDailySchedulesDBServices.update(dailySchedule).then((value) =>
        emit(SaveSuccessScheduleState()
        ));
  }

  void updateIsFavorite(bool isFavorite,String dailyScheduleId) async {
    await updateDailySchedulesDBServices.updateIsFavorite(isFavorite: isFavorite, modelId: dailyScheduleId)
        .then((value) => emit(UpdatedFavoriteState()))
    ;
  }

  void deleteDailySchedule(String id) async {
    await deleteDailySchedulesDBServices.deleteById(id);
  }


  List<Category> getAllCategories() {
    getCategoriesDBServices.getAll().then((allCategories){
      emit(GetAllCategoriesState(allCategories: allCategories));
      this.allCategories = allCategories;
    });
    return allCategories;
  }

  void setCategory(Category category){
    insertCategoriesDBServices.setAll(category).then((value) =>
        emit(SaveSuccessCategoryState())
    );
  }


  List<String> selectedCategories = [];
  void clickOnCategory(String categoryId){
    if(selectedCategories.contains(categoryId)){
      selectedCategories.remove(categoryId);
    }
    else{
      selectedCategories.add(categoryId);
    }
    emit(CategoryClickedState(categoryId: categoryId));
  }

  void setCategoryDailySchedule(CategoryDailySchedule categoryDailySchedule){ // relationship
    insertCategoriesDailySchedulesDBServices.setAll(categoryDailySchedule);
  }

  void deleteAllCategoryDailyRelation(String dailyScheduleId){
    deleteCategoriesDailySchedulesDBServices.deleteById(
        dailyScheduleId
    );
  }

  void deleteCategory(String categoryId) async {
    await deleteCategoriesDBServices.deleteById(categoryId) ;
  }

    void getAllCategoryDailyRelation(String dailyScheduleId) async {
    List<String> catText = [];
    List<String> catIds = [];
    await getCategoriesDBServices.getCategoriesRelated(dailyScheduleId).then((categories) => {
      // categories.map((e) => f.write("${e.name}x|x")),

      for (Category c in categories){
        catText.add(c.name),
        catIds.add(c.id)
      },
      emit(GetCategoriesRelated(categoriesText: catText.join(" - "), dailyScheduleId: dailyScheduleId, categoriesIds: catIds))
    });
  }




}
