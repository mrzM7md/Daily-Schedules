import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:daily_schedules/shared/business_lasyer/app_states.dart';
import 'package:daily_schedules/shared/constants/routes.dart';
import 'package:uuid/uuid.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  int currentPageIndex = 0;

  List mainRoutes= [
    schedulesRoute,
    favoriteRoute,
    searchRoute,
  ];

  static AppCubit get(context) => BlocProvider.of(context);

  //###################### START BottomNav Business ######################//
  void changeBottomNavPage({required int index}){
    currentPageIndex = index;
    emit(ChangeBottomNavState(index: index));
  //###################### END BottomNav Business ######################//
  }
}