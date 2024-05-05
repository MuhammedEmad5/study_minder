import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:study_minder/application_layer/app_functions.dart';
import 'package:study_minder/presentation_layer/screens/schedule/cubit/cubit.dart';
import 'package:study_minder/presentation_layer/screens/schedule/cubit/states.dart';
import 'package:study_minder/presentation_layer/widgets/loading.dart';
import '../../../application_layer/App_colors.dart';
import '../../../application_layer/app_images.dart';
import '../../../application_layer/my_icons.dart';
import '../../widgets/default_button.dart';
import '../../widgets/default_text_form_field.dart';

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

TextEditingController lectureNameController = TextEditingController();
TextEditingController startTimeController = TextEditingController();
TextEditingController endTimeController = TextEditingController();
final formKey = GlobalKey<FormState>();

class _ScheduleScreenState extends State<ScheduleScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ScheduleScreenCubit()
        ..getLecturesForDay(DateFormat('yyyy-MM-dd').format(DateTime.now())),
      child: BlocConsumer<ScheduleScreenCubit, ScheduleScreenStates>(
        listener: (BuildContext context, state) {
          if(state is RemoveLecFromFirebaseSuccessState){
            AppFunctions.showSnackBar(context, 'deleted successfully', error: false);
          }
        },
        builder: (BuildContext context, Object? state) {
          ScheduleScreenCubit cubit = ScheduleScreenCubit.get(context);
          return Scaffold(
            appBar: appBar(context),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    DateFormat('MMMM yyyy').format(DateTime.now()),
                    // Display dynamic month name
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.fifthColor),
                  ),
                ),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 30,
                    itemBuilder: (context, index) {
                      DateTime currentDate =
                          DateTime.now().add(Duration(days: index));
                      String dayName = DateFormat.E().format(currentDate);
                      int dayNumber = currentDate.day;

                      return Card(
                        color: AppColors.fifthColor,
                        elevation: 5,
                        child: SizedBox(
                          width: 65.w,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                String date = DateFormat('yyyy-MM-dd')
                                    .format(currentDate);
                                cubit.changeIndex(index);
                                cubit.getLecturesForDay(date);
                              },
                              splashColor: Colors.transparent,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    dayName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall!
                                        .copyWith(
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.firstColor),
                                  ),
                                  Text(
                                    '$dayNumber', // Display day number
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall!
                                        .copyWith(
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.secondColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 10.h),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    DateFormat('yyyy-MM-dd').format(
                        DateTime.now().add(Duration(days: cubit.currentIndex))),
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.fifthColor),
                  ),
                ),
                state is GetLecToFirebaseLoadingState
                    ? Expanded(child: Center(child: LoadingWidget()))
                    : cubit.lecturesData.isEmpty
                        ? emptyList(context, 'no added lecture at this day')
                        : Expanded(
                            child: ListView.builder(
                              itemCount: cubit.lecturesData.length,
                              itemBuilder: (context, index) {
                                var lecture = cubit.lecturesData[index];
                                String lectureName = lecture['name'];
                                String startTime = lecture['start_time'];
                                String endTime = lecture['end_time'];

                                return lecItemBuilder(context,lectureName, startTime, endTime,cubit,index);
                              },
                            ),
                          ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: AppColors.fifthColor,
              onPressed: () {
                DateTime currentDate =
                    DateTime.now().add(Duration(days: cubit.currentIndex));
                _showAddLectureBottomSheet(context, currentDate, cubit, state);
              },
              child: Icon(Icons.add,color: AppColors.white,),
            ),
          );
        },
      ),
    );
  }

  AppBar appBar(context) {
    return AppBar(
      titleSpacing: 15,
      title: Text(
        'schedule',
        style: Theme.of(context)
            .textTheme
            .displayLarge!
            .copyWith(fontWeight: FontWeight.w600, color: AppColors.thirdColor),
      ),
    );
  }

  void _showAddLectureBottomSheet(BuildContext context, DateTime selectedDate,
      ScheduleScreenCubit cubit, state) {
    String date = DateFormat('yyyy-MM-dd').format(selectedDate);

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return BlocProvider.value(
          value: cubit,
          child: BlocConsumer<ScheduleScreenCubit, ScheduleScreenStates>(
            listener: (BuildContext context, state) {
              if (state is AddLecToFirebaseSuccessState) {
                Navigator.pop(context);
              }
            },
            builder: (BuildContext context, state) {
              Widget lectureNameField() {
                return DefaultTextFormField(
                  controller: lectureNameController,
                  inputType: TextInputType.name,
                  labelText: 'Assignment name',
                  prefixIcon: MyIcons.document,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter lecture name';
                    }
                    return null;
                  },
                );
              }

              Widget startTimeField(context) {
                return DefaultTextFormField(
                  controller: startTimeController,
                  inputType: TextInputType.datetime,
                  labelText: 'start Time',
                  prefixIcon: MyIcons.timeCircle,
                  readOnly: true,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'start Time can\'t be Empty';
                    }
                    return null;
                  },
                  onTap: () {
                    showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    ).then((value) {
                      if (value != null) {
                        String formattedHour =
                            value.hour.toString().padLeft(2, '0');
                        String formattedMinute =
                            value.minute.toString().padLeft(2, '0');
                        String formattedTime =
                            "$formattedHour:$formattedMinute";
                        startTimeController.text = formattedTime;
                      }
                    });
                  },
                );
              }

              Widget endTimeField(context) {
                return DefaultTextFormField(
                  controller: endTimeController,
                  inputType: TextInputType.datetime,
                  labelText: 'end Time',
                  prefixIcon: MyIcons.timeCircle,
                  readOnly: true,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'end Time can\'t be Empty';
                    }
                    return null;
                  },
                  onTap: () {
                    showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    ).then((value) {
                      if (value != null) {
                        String formattedHour =
                            value.hour.toString().padLeft(2, '0');
                        String formattedMinute =
                            value.minute.toString().padLeft(2, '0');
                        String formattedTime =
                            "$formattedHour:$formattedMinute";
                        endTimeController.text = formattedTime;
                      }
                    });
                  },
                );
              }

              Widget saveButton(context, ScheduleScreenCubit cubit) {
                return Padding(
                  padding: EdgeInsets.only(left: 160.w),
                  child: DefaultButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        cubit
                            .addLecToFireBase(
                          date: date,
                          name: lectureNameController.text,
                          startTime: startTimeController.text,
                          endTime: endTimeController.text,
                        )
                            .then((value) {
                          lectureNameController.text = '';
                          startTimeController.text = '';
                          endTimeController.text = '';
                        });
                      }
                    },
                    child: Text(
                      'Save',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(
                              color: AppColors.firstColor,
                              fontWeight: FontWeight.w500),
                    ),
                  ),
                );
              }

              return Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        lectureNameField(),
                        SizedBox(height: 20.h),
                        startTimeField(context),
                        SizedBox(height: 20.h),
                        endTimeField(context),
                        SizedBox(height: 20.h),
                        state is AddLecToFirebaseLoadingState
                            ? Padding(
                                padding: EdgeInsets.only(left: 160.w),
                                child: const LoadingWidget(),
                              )
                            : saveButton(context, cubit),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget lecItemBuilder(
      BuildContext context, String lectureName,
      String startTime, String endTime,
      ScheduleScreenCubit cubit, int index) {
    return Dismissible(
      key: Key(cubit.documentIds[index]),
      onDismissed: (direction) {
        // Remove the item from the list and update the UI
        cubit.removeLecture(index, DateFormat('yyyy-MM-dd').format(
            DateTime.now().add(Duration(days: cubit.currentIndex))));
      },
      child: Card(
        margin: EdgeInsets.all(8),
        color: AppColors.thirdColor,
        elevation: 5,
        child: ListTile(
          title: Text(
            lectureName,
            style: Theme.of(context)
                .textTheme
                .displaySmall!
                .copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.white),
          ),
          subtitle: Text(
            '$startTime - $endTime',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(
                fontWeight: FontWeight.w300,
                color: AppColors.fifthColor),
          ),
        ),
      ),
    );
  }


  Widget emptyList(context, String text) {
    return SizedBox(
      height: 140.h,
      child: Column(
        children: [
          Lottie.asset(AppAnimation.empty, height: 90.h),
          Center(
            child: Text(
              text,
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: AppColors.secondColor, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
