import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:daily_schedules/business_layer/daily_schedule/daily_schedule_cubit.dart';
import 'package:daily_schedules/business_layer/daily_schedule/daily_schedule_states.dart';
import 'package:daily_schedules/pressentaion_layer/home_schedules/widgets/dialy_schedule_item.dart';
import 'package:daily_schedules/shared/constants/components.dart';
import 'package:daily_schedules/shared/constants/images.dart';
import 'package:daily_schedules/shared/data_layer/models/daily_schedule_model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<DailySchedule> allDailySchedules = [];
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: buildField(
              isTherePrefixSearchIcon: true,
                controller: _searchController,
                placeholder: "Search by title or description",
                onChange:(value){
                    DailyScheduleCubit.get(context).findAllDailySchedules(value.trim());
                }
            ),
          ),
          BlocConsumer<DailyScheduleCubit, DailyScheduleState>(
            listener: (BuildContext context, DailyScheduleState state) {
              if(state is GetAllDailySchedulesState){
                allDailySchedules = state.allDailySchedules;
              }
            },
            builder: (mainContext, state) {
              if(state is GetAllDailySchedulesState){
                return ConditionalBuilder(
                  condition: state.allDailySchedules.isNotEmpty,
                  builder: (BuildContext context) => ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (ctx, index) => Dismissible(
                      key: ValueKey<String>(state.allDailySchedules[index].id),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (direction) async {
                        final bool res = await showDialog(
                            context: mainContext,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: const Text("Are you sure you want to remove this schedule"),
                                actions: <Widget>[
                                  MaterialButton(
                                    child: const Text(
                                      "Cancel",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                  ),
                                  MaterialButton(
                                    child: const Text(
                                      "Remove",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop(true);
                                      DailyScheduleCubit.get(mainContext).deleteDailySchedule(allDailySchedules[index].id);
                                    },
                                  ),
                                ],
                              );
                            });
                        return res;
                      },
                      background: Container(
                        height: double.infinity,
                        color: Colors.red,
                        padding: const EdgeInsetsDirectional.only(end: 20.0),
                        alignment: AlignmentDirectional.centerEnd,
                        child: const Icon(Icons.delete, color: Colors.white,),
                      ),
                      child: DailyScheduleItem(
                        dailySchedule: state.allDailySchedules[index],
                      ),
                    ),
                    itemCount: state.allDailySchedules.length,
                  ),
                  fallback: (BuildContext context) => buildNoData(text: 'Empty', image: no_search_data),
                );
              }

              return const Center(child: CircularProgressIndicator());
            },
            buildWhen: (prev, current) => current is GetAllDailySchedulesState,
          ),
        ],
      ),
    );
  }
  @override
  void initState() {
    super.initState();
    DailyScheduleCubit.get(context).findAllDailySchedules("");
  }
}
