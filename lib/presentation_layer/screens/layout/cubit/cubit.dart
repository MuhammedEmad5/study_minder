import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_minder/presentation_layer/screens/layout/cubit/states.dart';

import '../../home screen/home_screen.dart';
import '../../profile/profile_screen.dart';
import '../../schedule/schcdule_screen.dart';

class LayoutCubit extends Cubit<LayoutStates> {

  LayoutCubit() : super(LayoutInitialState());

  static LayoutCubit get(context) => BlocProvider.of(context);


  List<Widget>layoutScreens=[
    HomeScreen(),
    ScheduleScreen(),
    UserProfileScreen(),
  ];

  List<String>titles=[
    'Home',
    'Schedule',
    'Profile',
  ];

  int selectedIndex = 0;
  void changeNavBar(int index){
    selectedIndex=index;
    emit(ChangeNavBarState());
  }




}
