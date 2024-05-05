import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_minder/presentation_layer/screens/progress/cubit/states.dart';

import '../../../../application_layer/app_strings.dart';

class ProgressScreenCubit extends Cubit<ProgressScreenStates> {
  ProgressScreenCubit() : super(ProgressScreenInitialState());

  static ProgressScreenCubit get(context) => BlocProvider.of(context);

  Map<String, List<String>> allProgressMap = {};
  Map<String, List<String>> completedProgressMap = {};

  Future<void> getProgressData(String dateNow) async {
    emit(GetProgressLoadingState());
    try {
      List<String> dates = _generateDateRange(dateNow, 10); // Generate date range for the last 6 dates including dateNow

      for (String date in dates) {
        DocumentSnapshot<Map<String, dynamic>> progressDoc =
        await FirebaseFirestore.instance.collection('Progress').doc(date).get();

        Map<String, dynamic> allData = progressDoc.data() ?? {};

        if (allData.containsKey('all${AppStrings.uId}')) {
          allProgressMap[date] = List.from(allData['all${AppStrings.uId}']);
        } else {
          allProgressMap[date] = [];
        }

        if (allData.containsKey('completed${AppStrings.uId}')) {
          completedProgressMap[date] = List.from(allData['completed${AppStrings.uId}']);
        } else {
          completedProgressMap['completed${AppStrings.uId}'] = [];
        }
      }

      await calculateProgressPercentage();
      emit(GetProgressSuccessState());
    } catch (error) {
      print('Error getting progress data: $error');
      emit(GetProgressErrorState(error.toString()));
    }
  }

  List<Map<String, dynamic>> percentageList = [];

  Future<void> calculateProgressPercentage() async {
    percentageList.clear(); // Clear existing percentageList before calculating new percentages

    allProgressMap.forEach((date, allList) {
      double percentage = 0.0;

      List<String>? completedList = completedProgressMap[date];
      int completedCount = completedList?.length ?? 0;
      int allCount = allList.length;

      if (allCount > 0) {
        percentage = (completedCount / allCount) * 100;
      }

      percentageList.add({'date': date, 'percentage': percentage});
      print(percentageList);
    });
  }

  List<String> _generateDateRange(String dateNow, int count) {
    List<String> dates = [];
    DateTime currentDate = DateTime.parse(dateNow);

    for (int i = 0; i < count; i++) {
      dates.add(currentDate.subtract(Duration(days: i)).toString().substring(0, 10));
    }
    return dates;
  }
}
