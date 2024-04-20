import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:daily_schedules/business_layer/daily_schedule/daily_schedule_cubit.dart';
import 'package:daily_schedules/business_layer/daily_schedule/daily_schedule_states.dart';
import 'package:daily_schedules/shared/constants/colors.dart';
import 'package:daily_schedules/shared/constants/components.dart';
import 'package:daily_schedules/shared/data_layer/models/category_model.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({super.key, required this.category,  required this.subScheduleId});
  final Category category;
  final String subScheduleId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DailyScheduleCubit, DailyScheduleState>(
    builder: (context, state) {
      var cubit = DailyScheduleCubit.get(context);
      return InkWell(
      onTap: (){
        cubit.clickOnCategory(category.id);
      },
      child: Container(
        decoration: BoxDecoration(
          color: cubit.selectedCategories.contains(category.id) ? mainColor : Colors.black45,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                onPressed: (){
                  cubit.deleteCategory(category.id);
                  getToast(
                      message: "Tag deleted",
                      bkgColor: Colors.white,
                      textColor: Colors.black
                  );
                  cubit.getAllCategories();
                  cubit.getAllDailySchedules();
                  if(cubit.allCategories.contains(category.id)){
                    cubit.allCategories.remove(category.id);
                  }
                },
                icon: const Icon(
                  Icons.close,
                  size: 20,
                ),
                alignment: Alignment.center,
              ),
              Text(category.name, style: TextStyle(color: cubit.selectedCategories.contains(category.id) ? Colors.black45 : Colors.white, fontSize: 18),),
            ],
          ),
        ),
      ),
    );
  },
   buildWhen: (prev, current) => current is CategoryClickedState && current.categoryId == category.id,
);
  }
}
