import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:daily_schedules/business_layer/daily_schedule/daily_schedule_cubit.dart';
import 'package:daily_schedules/business_layer/daily_schedule/daily_schedule_states.dart';
import 'package:daily_schedules/business_layer/schedule_task/schedule_task_cubit.dart';
import 'package:daily_schedules/business_layer/schedule_task/schedule_task_states.dart';
import 'package:daily_schedules/pressentaion_layer/schedule_tasks/widgets/categoriy_item.dart';
import 'package:daily_schedules/pressentaion_layer/schedule_tasks/widgets/schedule_task_item.dart';
import 'package:daily_schedules/shared/constants/colors.dart';
import 'package:daily_schedules/shared/constants/images.dart';
import 'package:daily_schedules/shared/constants/routes.dart';
import 'package:daily_schedules/shared/data_layer/models/category_model.dart';
import 'package:daily_schedules/shared/data_layer/models/category_daily_schedule_model.dart';
import 'package:daily_schedules/shared/data_layer/models/daily_schedule_model.dart';
import 'package:daily_schedules/shared/data_layer/models/schedule_task_model.dart';
import 'package:daily_schedules/shared/local/cache_helper.dart';
import 'package:daily_schedules/shared/constants/components.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:uuid/uuid.dart';

import '../../shared/services/services_locator.dart';

class SchedulePage extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  late DailySchedule dailySchedule;
  final List<String> categoriesIds;

  late final TextEditingController _titleController = TextEditingController();
  late final TextEditingController _descriptionController = TextEditingController();
  late final TextEditingController _textCategoryController = TextEditingController();

  late String _lastTitle;
  late String _lastDescription;

  late bool _isNewNotUpdate;

  late DateTime _date;

  SchedulePage(isNewNotUpdate,
      this.dailySchedule,
      this.categoriesIds,
      {
        super.key,
      }) {
    _isNewNotUpdate = isNewNotUpdate;
  }

  @override
  Widget build(BuildContext context) {
    ScheduleTaskCubit.get(context).getAllTasksByScheduleId(dailySchedule.id);

    _titleController.text = dailySchedule.title;
    _descriptionController.text = dailySchedule.description;

    _lastTitle = dailySchedule.title;
    _lastDescription = dailySchedule.description;
    _date = dailySchedule.date;

    var cubit = DailyScheduleCubit.get(context)
      ..getAllCategories();
    cubit.choseDay = dailySchedule.date;
    cubit.isFavorite = dailySchedule.isFavorite;
    cubit.selectedCategories = [...categoriesIds];

    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
      // floatingActionButton: FloatingActionButton.extended(
      //     onPressed: (){},
      //     label: const Text("New Timed Schedule"),
      //   backgroundColor: mainColor,
      //   icon: const Icon(Icons.add),
      // ),
      appBar: AppBar(
        title: Text(dailySchedule.title),
        centerTitle: true,
        backgroundColor: mainColor,
        actions: [
          BlocBuilder<DailyScheduleCubit, DailyScheduleState>(
            builder: (context, state) {
              return IconButton(
                  onPressed: () {
                    cubit.changeFavoriteValue();
                    if (isThisDailyScheduleForUpdate()) {
                      cubit.updateIsFavorite(
                          cubit.isFavorite, dailySchedule.id);
                      getToast(
                          message: "Done",
                          bkgColor: Colors.white,
                          textColor: Colors.black
                      );
                      cubit.getAllDailySchedules();
                    }
                  },
                  icon: BlocBuilder<DailyScheduleCubit, DailyScheduleState>(
                    builder: (ctx, state) {
                      return ConditionalBuilder(
                          condition: cubit.isFavorite,
                          builder: (ctx) =>
                          const Icon(
                            Icons.favorite,
                            color: Colors.black,
                          ),
                          fallback: (ctx) =>
                          const Icon(
                            Icons.favorite_border,
                            color: Colors.black,
                          ));
                    },
                    buildWhen: (prev, current) => prev is ChangeFavoriteState,
                  ));
            },
          ),
          BlocBuilder<DailyScheduleCubit, DailyScheduleState>(
            builder: (ctx, state) {
              if (state is SaveSuccessScheduleState) {
                getToast(
                    message: "Done",
                    bkgColor: Colors.white,
                    textColor: Colors.black
                );
              }
              return IconButton(
                onPressed: () {
                  saveThisDailyScheduleIfAlreadyTheContentWasChanged(context);
                },
                icon: ConditionalBuilder(
                    condition: state is! SaveLoadingScheduleState,
                    builder: (BuildContext context) =>
                    const Icon(
                      Icons.save,
                      color: Colors.black,
                    ),
                    fallback: (BuildContext context) =>
                    const SizedBox(
                      height: 15,
                      width: 15,
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    )),
              );
            },
            buildWhen: (prev, current) =>
            (current is SaveLoadingScheduleState ||
                current is SaveSuccessScheduleState),
          )
        ],
      ),
      body: WillPopScope(
        onWillPop: () async { // on back pressed
          saveThisDailyScheduleIfAlreadyTheContentWasChanged(context);
          return true;
        },
        child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 50.0,
                      padding: const EdgeInsetsDirectional.all(5),
                      child: Row(
                        children: [
                          Expanded(
                            child: BlocBuilder<
                                DailyScheduleCubit,
                                DailyScheduleState>(
                              builder: (context, state) {
                                cubit.allCategories;
                                return ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: cubit.allCategories.length,
                                  itemBuilder: (BuildContext context,
                                      int index) {
                                    return CategoryItem(
                                        category: cubit.allCategories[index],
                                        subScheduleId: dailySchedule.id);
                                  },
                                  separatorBuilder: (BuildContext context,
                                      int index) =>
                                  const SizedBox(
                                    width: 5,
                                  ),
                                );
                              },
                              buildWhen: (prev,
                                  current) => current is GetAllCategoriesState,
                            ),
                          ),
                          IconButton(onPressed: () {
                            scaffoldKey.currentState!.showBottomSheet(
                                  (context) =>
                                  SingleChildScrollView(
                                    child: Container(
                                      color: Colors.white30,
                                      height: 220,
                                      padding: const EdgeInsetsDirectional.all(
                                          15),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          buildTitleWithField(title: "New Tag",
                                              controller: _textCategoryController,
                                              placeholder: "Tag Name"),
                                          Container(
                                            margin: const EdgeInsetsDirectional
                                                .only(top: 10),
                                            child: FloatingActionButton
                                                .extended(
                                              backgroundColor: mainColor,
                                              onPressed: () {
                                                if (_textCategoryController.text
                                                    .isNotEmpty) {
                                                  addCategoryThenCleanTextField(
                                                      context);
                                                  cubit.getAllCategories();
                                                }
                                              },
                                              label: const Text("Add"),
                                              icon: const Icon(Icons.done),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                            ).closed.then((value) {
                              if (_textCategoryController.text.isNotEmpty) {
                                addCategoryThenCleanTextField(context);
                                cubit.getAllCategories();
                              }
                            });
                          }, icon: const Row(children: [
                            Icon(Icons.add),
                            Icon(CupertinoIcons.tag_fill)
                          ],))
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildTitleWithField(
                              controller: _titleController,
                              title: 'Title',
                              placeholder: 'Schedule Name'),
                          const SizedBox(
                            height: 20,
                          ),
                          buildTitleWithField(
                              isForDescription: true,
                              controller: _descriptionController,
                              title: 'Description',
                              placeholder: 'Schedule Description'),
                          const SizedBox(
                            height: 20,
                          ),
                          buildTitle(title: 'Schedule Day'),
                          BlocBuilder<DailyScheduleCubit, DailyScheduleState>(
                            builder: (context, state) {
                              return TableCalendar(
                                focusedDay: cubit.choseDay,
                                firstDay: DateFormat('yyyy-MM-dd HH:mm:ss').parse(CacheHelper.getString(key: "dateAppInstalled")!),
                                lastDay: DateTime(DateTime.now().year + 20, 1, 1),
                                headerStyle: const HeaderStyle(
                                    titleCentered: true,
                                    formatButtonVisible: false),
                                availableGestures: AvailableGestures.all,
                                selectedDayPredicate: (day) => isSameDay(day, cubit.choseDay),
                                onDaySelected:
                                    (
                                    DateTime selectedDay,
                                    DateTime focusedDay
                                    ) {
                                  cubit.changeChoseDay(DateTime(selectedDay.year, selectedDay.month, selectedDay.day, ));
                                },
                              );
                            },
                            buildWhen: (previous, current) =>
                            current is ChangeFocusedDayState,
                          ),

                          Container(
                            width: double.infinity,
                            color: mainColor,
                            margin: const EdgeInsetsDirectional.only(
                                top: 20, bottom: 5.0),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text("All timed tasks".toUpperCase(),
                                style: const TextStyle(fontWeight: FontWeight.bold),),
                            ),
                          ),

                          BlocBuilder<ScheduleTaskCubit, ScheduleTaskStates>(
                            builder: (context, state) {
                              if(state is GetAllScheduleTasksState){
                                return ConditionalBuilder(
                                  condition: state.allScheduleTasks.isNotEmpty,
                                  builder: (BuildContext context) => ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) =>
                                          ScheduleTaskItem(
                                            key: ValueKey<String>(state.allScheduleTasks[index].id),
                                            scheduleTask: state.allScheduleTasks[index],
                                            index: index,
                                            dailyScheduleDate: cubit.choseDay,
                                          ),
                                      itemCount: state.allScheduleTasks.length),
                                  fallback: (BuildContext context) => buildNoData(text: 'No Timed Tasks For This Schedule Yet', image: no_tasks),
                                );
                              }
                              else{
                                return const Center(child: CircularProgressIndicator());
                              }
                            },
                            buildWhen: (prev, current) => current is GetAllScheduleTasksState,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  saveThisDailyScheduleIfAlreadyTheContentWasChangedOnlyAtUpdate(context);
                  navigateTo(context, newTaskRoute, arguments:
                  [/*Is New*/ true,
                    ScheduleTask(
                        id: "${sl<Uuid>().v4()}-${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}",
                        dailyScheduleId: dailySchedule.id, title: '', description: '',
                        from: '${DateTime.now().hour}:${DateTime.now().minute} ${DateTime.now().hour < 12 ? 'AM' : 'PM'}' ,
                        to: '${DateTime.now().hour}:${DateTime.now().minute} ${DateTime.now().hour < 12 ? 'AM' : 'PM'}' ,
                        addedTime: DateTime.now()
                    )]);
                },
                child: Container(width: double.infinity,
                  height: 45,
                  color: mainColor,
                  padding: const EdgeInsetsDirectional.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.add),
                      Text("New Timed Task".toUpperCase())
                    ],
                  ),
                ),
              )
            ]
        ),
      ),
    );
  }

  void addCategoryThenCleanTextField(context) {
    var cubit = DailyScheduleCubit.get(context);
    cubit.setCategory(
        Category(
            id: "${sl<Uuid>().v4()}-${DateFormat('yyyyMMddHHmmss').format(
                DateTime.now())}",
            name: _textCategoryController.text,
            addedTime: DateTime.now())
    );
    _textCategoryController.text = "";
  }

  void saveThisDailyScheduleIfAlreadyTheContentWasChanged(context) {
    if (! isDataNotEdited(context)) {
      saveThisDailySchedule(context).then((value) => ScheduleTaskCubit.get(context).getAllTasksByScheduleId(dailySchedule.id)) ;
    }
  }

  Future<void> saveThisDailySchedule(context) async {
    if (isThisDailyScheduleNew()) {
      addNewDailySchedule(context);
      _isNewNotUpdate = false;
    }
    else {
      updateDailySchedule(context);
    }
    replaceAllOldCategoriesByDeleteThenAddNewSelected(context);
    DailyScheduleCubit.get(context).getAllDailySchedules();
  }

  void saveThisDailyScheduleIfAlreadyTheContentWasChangedOnlyAtUpdate(context) {
    if(isThisDailyScheduleNew()){
      saveThisDailySchedule(context);
    }
    else {
      if (!isDataNotEdited(context)) {
        saveThisDailySchedule(context);
      }
    }

  }

  bool isDataNotEdited(context) =>
      _lastTitle.trim() == _titleController.text.trim() &&
          _lastDescription.trim() == _descriptionController.text.trim() &&
          (Set.from(categoriesIds).containsAll(DailyScheduleCubit
              .get(context)
              .selectedCategories) && Set.from(DailyScheduleCubit
              .get(context)
              .selectedCategories).containsAll(categoriesIds)) &&
          _date == DailyScheduleCubit
              .get(context)
              .choseDay;


  bool isThisDailyScheduleNew() {
    return _isNewNotUpdate;
  }

  bool isThisDailyScheduleForUpdate() {
    return !_isNewNotUpdate;
  }

  void addNewDailySchedule(context) {
    var cubit = DailyScheduleCubit.get(context);
    _date = cubit.choseDay;
    cubit.insertDailyScheduleData(
        getCurrentDailySchedule(context)
    );
  }

  void updateDailySchedule(context) {
    var cubit = DailyScheduleCubit.get(context);
    _date = cubit.choseDay;
    cubit.updateDailyScheduleData(
        getCurrentDailySchedule(context)
    );
  }

  DailySchedule getCurrentDailySchedule(context){
    var cubit = DailyScheduleCubit.get(context);
    return DailySchedule(
      cubit.isFavorite,
      id: dailySchedule.id,
      title: _titleController.text,
      description: _descriptionController.text,
      date: cubit.choseDay,
      addedTime: dailySchedule.addedTime,
    );
  }


  // DateTime getSameDateButWithLastHourAtDay(DateTime dateTime, context){
  //   final choseDay = DateTime.fromMillisecondsSinceEpoch(
  //     dateTime.millisecondsSinceEpoch - DateTime.now().hour * 3600 * 1000 + 12 * 3600 * 1000,
  //   );
  //
  //   return choseDay;
  // }

  void replaceAllOldCategoriesByDeleteThenAddNewSelected(context) {
    var cubit = DailyScheduleCubit.get(context);
    cubit.deleteAllCategoryDailyRelation(dailySchedule.id);

    // Add New
    if (cubit.selectedCategories.isNotEmpty) {
      for (String id in cubit.selectedCategories) {
        cubit.setCategoryDailySchedule(
            CategoryDailySchedule(
                id: "${sl<Uuid>().v4()}-${DateFormat('yyyyMMddHHmmss').format(
                    DateTime.now())}",
                categoryId: id,
                dailyScheduleId: dailySchedule.id,
                addedTime: DateTime.now()
            )
        );
      }
    }
  }
}
