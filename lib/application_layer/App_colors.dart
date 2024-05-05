import 'package:flutter/material.dart';

class AppColors{
 static Color white= const Color(0xFFFFFFFF);
 static Color black= const Color(0xFF000000);
 static Color firstColor=const Color(0xFFDFF5FF);
 static Color secondColor=const Color(0xFF67C6E3);
 static Color thirdColor=const Color(0xFF378CE7);
 static Color fourthColor=const Color(0xFF5356FF);
 static Color fifthColor=const Color(0xFF112D4E);


 static MaterialColor getMaterialColor(Color color) {
  final int red = color.red;
  final int green = color.green;
  final int blue = color.blue;

  final Map<int, Color> shades = {
   50: Color.fromRGBO(red, green, blue, .1),
   100: Color.fromRGBO(red, green, blue, .2),
   200: Color.fromRGBO(red, green, blue, .3),
   300: Color.fromRGBO(red, green, blue, .4),
   400: Color.fromRGBO(red, green, blue, .5),
   500: Color.fromRGBO(red, green, blue, .6),
   600: Color.fromRGBO(red, green, blue, .7),
   700: Color.fromRGBO(red, green, blue, .8),
   800: Color.fromRGBO(red, green, blue, .9),
   900: Color.fromRGBO(red, green, blue, 1),
  };

  return MaterialColor(color.value, shades);
 }

}
