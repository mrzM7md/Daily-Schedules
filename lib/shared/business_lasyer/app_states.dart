abstract class AppStates{}

class AppInitialState extends AppStates{}

//###################### START BottomNav State ######################//
class ChangeBottomNavState extends AppStates{
  final int index;

  ChangeBottomNavState({required this.index});
}
//###################### END BottomNav State ######################//
