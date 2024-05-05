import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application_layer/App_colors.dart';
import '../../../application_layer/my_icons.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>LayoutCubit(),
      child: BlocBuilder<LayoutCubit,LayoutStates>(
        builder: (BuildContext context, state) {
          LayoutCubit cubit=LayoutCubit.get(context);
          return Scaffold(
            body: cubit.layoutScreens[cubit.selectedIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.selectedIndex,
              selectedItemColor: AppColors.fourthColor,
              onTap: (index) {
                cubit.changeNavBar(index);
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(MyIcons.home),label:'Home' ),
                BottomNavigationBarItem(icon: Icon(MyIcons.calendar),label:'Schedule' ),
                BottomNavigationBarItem(icon: Icon(MyIcons.profile),label:'profile' ),
              ],
            ),
          );
        },
      ),
    );
  }

}
