import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:study_minder/application_layer/alarm/alarm_service.dart';
import 'package:study_minder/presentation_layer/screens/layout/layout_screen.dart';
import 'package:study_minder/presentation_layer/screens/splash%20screen/splash_screen.dart';
import 'application_layer/app_strings.dart';
import 'application_layer/bloc_observer.dart';
import 'application_layer/shared_preferences/shared_preferences.dart';
import 'application_layer/themes.dart';
import 'firebase_options.dart';
import 'package:timezone/data/latest.dart' as tz;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  tz.initializeTimeZones();
  await CashHelper.init();
  Bloc.observer = MyBlocObserver();

  await AlarmService.mainFun();


  Widget? widget;

  bool splashScreen = CashHelper.getBoolData(key: 'splashScreen') ?? false;
  AppStrings.uId = CashHelper.getStringData(key: 'uId');
  AppStrings.name = CashHelper.getStringData(key: 'name');


  if (splashScreen) {
    widget = AppStrings.uId != null ? LayoutScreen() : SplashScreen();
  } else {
    widget = SplashScreen();
  }

  runApp(MyApp(
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.startWidget});

  final Widget? startWidget;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: lightTheme(context),
          home: startWidget,
        );
      },
    );
  }
}
