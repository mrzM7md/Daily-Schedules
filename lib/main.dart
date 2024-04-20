import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:daily_schedules/block_observer.dart';
import 'package:daily_schedules/business_layer/cubit_helpers/values.dart';
import 'package:daily_schedules/shared/constants/colors.dart';
import 'package:daily_schedules/shared/local/sqldb.dart';
import 'package:daily_schedules/shared/services/services_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:intl/intl.dart';
import 'package:daily_schedules/pressentaion_layer/on_boarding/on_boarding_page.dart';
import 'package:daily_schedules/routes.dart';
import 'package:daily_schedules/shared/business_lasyer/app_cubit.dart';
import 'package:daily_schedules/shared/business_lasyer/app_states.dart';
import 'package:daily_schedules/shared/constants/components.dart';
import 'package:daily_schedules/shared/constants/images.dart';
import 'package:daily_schedules/shared/constants/routes.dart';
import 'package:daily_schedules/shared/data_layer/models/daily_schedule_model.dart';
import 'package:daily_schedules/shared/local/cache_helper.dart';
import 'package:uuid/uuid.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // ensure that everything in this function already finished then start application `runApp()`

  Bloc.observer = MyBlocObserver();

  await CacheHelper.init();

  ServicesLocator().init();

  sl<SqlDb>().initialDb();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (BuildContext context) => AppCubit(),
          ),
          BlocProvider(
            create: (BuildContext context) => DailyScheduleHelper().dailyTaskCubit,
          ),
          BlocProvider(
            create: (BuildContext context) => ScheduleTaskHelper().scheduleTaskCubit,
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: ConditionalBuilder(
            condition: (CacheHelper.getBool(key: "isBoardingPageShaw") ?? false) ,
            builder: (BuildContext context) => AppPages().generatePage(const RouteSettings(name: mainRoute)) ,
            fallback: (BuildContext context) => const OnBoardingPage(),
          ),
          // AppPages().generatePage(const RouteSettings(name: mainRoute)),
            theme: ThemeData(
              progressIndicatorTheme: ProgressIndicatorThemeData(
                color: mainColor,
              ),
            )));
  }
}

class MainPage extends StatelessWidget {
  MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
  return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: SizedBox(
              height: 60,
              child: GNav(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  backgroundColor: Colors.black54,
                  color: Colors.white,
                  activeColor: Colors.white,
                  tabBackgroundColor: const Color(0x40ffd859),
                  gap: 8,
                  padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 15, vertical: 8),
                  onTabChange: (index) {
                    cubit.changeBottomNavPage(index: index);
                  },
                  tabs: const [
                    GButton(
                      icon: Icons.add_home_outlined,
                      text: "Home",
                    ),
                    GButton(
                      icon: Icons.favorite,
                      text: "Fav",
                    ),
                    GButton(
                      icon: Icons.search,
                      text: "Search",
                    ),
                  ]),
            ),
          ),
          appBar: AppBar(
            title: const Text('Daily Schedules'),
            centerTitle: true,
            backgroundColor: const Color(0xffffd859),
            leading: Padding(
              padding: const EdgeInsetsDirectional.only(start: 10),
              child: Image.asset(logo_image),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  navigateTo(context,
                      scheduleDetailRoute,
                    arguments: [true /*is new*/ ,DailySchedule(false,
                      id: "${sl<Uuid>().v4()}-${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}",
                      title: "",
                      description: "",
                      date: DateTime.now(),
                      addedTime: DateTime.now()), [''] /* categoriesId */ ],
                  );
                },
                icon: const Icon(
                  Icons.add,
                  size: 28,
                ),
              ),
            ],
          ),
          body: StreamBuilder<Object>(
            stream: null,
            builder: (context, snapshot) {
              return AppPages().generatePage(RouteSettings(name: cubit.mainRoutes[cubit.currentPageIndex]));
            }
          ),
        );
      },
    );
  }
}
