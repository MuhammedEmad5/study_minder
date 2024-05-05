import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:study_minder/application_layer/app_strings.dart';

import 'my_icons.dart';

class AppFunctions {
  static Future<dynamic> navigateTo(context, Widget newScreen) {
    return Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => newScreen,
        ));
  }

  static Future<dynamic> navigateToAndRemove(context, Widget newScreen) {
    return  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => newScreen,maintainState: false),
          (route) => false, // Remove all routes except the new one
    );
  }

  static Widget backButton(context) {
    return IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          MyIcons.arrowLeftCircle,
          size: 32.w,
          shadows: [
            BoxShadow(
              color: Theme.of(context).disabledColor,
              spreadRadius: 4,
              blurRadius: 1,
              offset: Offset(0, 2),
            ),
          ],
        ));
  }

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
      BuildContext context, String content,
      {required bool error}) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          content,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Theme.of(context).disabledColor),
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: error ? Colors.red : Colors.green,
      ),
    );
  }


  static Future<void> progressAddAll(String date, String title) async {
    try {
      // Get the current progress document
      DocumentSnapshot<Map<String, dynamic>> progressDoc =
      await FirebaseFirestore.instance.collection('Progress').doc(date).get();

      // Check if the document exists
      if (!progressDoc.exists) {
        // Create the document with an empty "all" array
        await FirebaseFirestore.instance.collection('Progress').doc(date).set({
          'all${AppStrings.uId}': [],
        });
      }

      // Get the current "all" array or initialize it to an empty array if it doesn't exist
      List<String> all = List.from(progressDoc.data()?['all${AppStrings.uId}'] ?? []);

      // Add the new name to the "all" array
      all.add(title);

      // Update the document with the modified "all" array
      await FirebaseFirestore.instance.collection('Progress').doc(date).update({'all${AppStrings.uId}': all});
    } catch (error) {
      print('Error adding title: $error');
    }
  }


  static Future<void> progressAddCompleted(String date, String title) async {
    try {
      // Get the current progress document
      DocumentSnapshot<Map<String, dynamic>> progressDoc =
      await FirebaseFirestore.instance.collection('Progress').doc(date).get();

      // Get the current "all" array or initialize it to an empty array if it doesn't exist
      List<String> completed = List.from(progressDoc.data()?['completed${AppStrings.uId}'] ?? []);

      // Add the new name to the "completed" array
      completed.add(title);

      // Update the document with the modified "completed" array
      await FirebaseFirestore.instance
          .collection('Progress')
          .doc(date)
          .update({'completed${AppStrings.uId}': completed});
    } catch (error) {
      print('Error adding title: $error');
    }
  }


  static Future<void> progressRemoveCompleted(String date, String title) async {
    try {
      // Get the current progress document
      DocumentSnapshot<Map<String, dynamic>> progressDoc =
      await FirebaseFirestore.instance.collection('Progress').doc(date).get();

      // Get the current "completed" array or initialize it to an empty array if it doesn't exist
      List<String> completed = List.from(progressDoc.data()?['completed${AppStrings.uId}'] ?? []);

      // Remove the name from the "completed" array
      completed.remove(title);

      // Update the document with the modified "completed" array
      await FirebaseFirestore.instance
          .collection('Progress')
          .doc(date)
          .update({'completed${AppStrings.uId}': completed});
    } catch (error) {
      print('Error removing title: $error');
    }
  }

}
