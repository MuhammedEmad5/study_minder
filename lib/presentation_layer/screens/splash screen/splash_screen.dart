import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:study_minder/application_layer/App_colors.dart';
import 'package:study_minder/application_layer/app_functions.dart';
import 'package:study_minder/application_layer/app_strings.dart';
import 'package:study_minder/application_layer/my_icons.dart';
import 'package:study_minder/application_layer/shared_preferences/shared_preferences.dart';
import 'package:study_minder/presentation_layer/screens/login%20screen/login_screen.dart';
import 'package:study_minder/presentation_layer/widgets/default_button.dart';


class SplashScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.firstColor,
                    AppColors.secondColor,
                  ],
                stops: [0.05,0.9]
              )
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.book_outlined,color: AppColors.thirdColor,),
                    SizedBox(width: 5.w),
                    Text(
                      'study',
                      style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.thirdColor
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 260.h,),
                Text(
                  AppStrings.splashTitle,
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.firstColor
                  ),
                ),
                SizedBox(height: 40.h,),
                Text(
                  AppStrings.splashSubTitle,
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.w500,
                      color: AppColors.firstColor
                  ),
                ),
                SizedBox(height: 60.h,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: DefaultButton(
                      onPressed: (){
                        CashHelper.putBoolData(key: 'splashScreen', value: true);
                        AppFunctions.navigateToAndRemove(context,LoginScreen());
                      },
                      child: Text(
                        'Let\'s go',
                        style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          fontWeight: FontWeight.w500,
                            color: AppColors.firstColor
                        ),
                      ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
