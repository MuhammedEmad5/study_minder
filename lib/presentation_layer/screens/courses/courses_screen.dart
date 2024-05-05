import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:study_minder/presentation_layer/screens/courses/coures_info_screen.dart';

import '../../../application_layer/App_colors.dart';
import '../../../application_layer/app_functions.dart';
import '../../../application_layer/app_images.dart';
import '../../../application_layer/my_icons.dart';
import '../../widgets/default_button.dart';
import '../../widgets/default_text_form_field.dart';
import '../../widgets/loading.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class CoursesScreen extends StatelessWidget {
  CoursesScreen({super.key});

  final TextEditingController addCourseController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => CoursesScreenCubit()..getCourses(),
      child: BlocConsumer<CoursesScreenCubit, CoursesScreenStates>(
        listener: (BuildContext context, state) {
          if (state is RemoveCoursesFromFirebaseSuccessState) {
            AppFunctions.showSnackBar(context, 'deleted successfully',
                error: false);
          }
        },
        builder: (BuildContext context, Object? state) {
          CoursesScreenCubit cubit = CoursesScreenCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              titleSpacing: 0,
              title: Text(
                'Courses',
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    color: AppColors.thirdColor, fontWeight: FontWeight.w600),
              ),
              leading: AppFunctions.backButton(context),
            ),
            body: Column(
              children: [
                state is GetCoursesToFirebaseLoadingState
                    ? Expanded(child: Center(child: LoadingWidget()))
                    : cubit.courses.isEmpty
                        ? emptyList(context, 'no added courses yet')
                        : Expanded(
                            child: ListView.builder(
                              itemBuilder: (context, index) =>
                                  courseCardBuilder(
                                      context, cubit.courses[index], cubit),
                              itemCount: cubit.courses.length,
                            ),
                          ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: AppColors.fifthColor,
              onPressed: () {
                _showBottomSheet(context, cubit);
              },
              child: Icon(Icons.add, color: AppColors.white),
            ),
          );
        },
      ),
    );
  }

  Widget courseCardBuilder(context, String courseName,CoursesScreenCubit cubit) {
    return Dismissible(
      key: Key(courseName),
      onDismissed: (direction) {
        cubit.removeCourses(courseName);
        cubit.deleteAllPdfFilesByCourse(courseName);
      },
      child: InkWell(
        onTap: (){
          AppFunctions.navigateTo(context, CourseInfoScreen(courseName: courseName));
        },
        child: Card(
          margin: EdgeInsets.all(10),
          elevation: 10,
          color: AppColors.fifthColor,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(courseName,
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          color: AppColors.firstColor,
                          fontWeight: FontWeight.w600,
                        )),
                Icon(MyIcons.arrowRight_2,color: AppColors.secondColor,)
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context, CoursesScreenCubit cubit) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return BlocProvider.value(
          value: cubit,
          child: BlocConsumer<CoursesScreenCubit, CoursesScreenStates>(
            listener: (BuildContext context, state) {
              if (state is AddCoursesToFirebaseSuccessState) {
                Navigator.pop(context);
              }
            },
            builder: (BuildContext context, state) {
              Widget addCourseFieldField() {
                return DefaultTextFormField(
                  controller: addCourseController,
                  inputType: TextInputType.name,
                  labelText: 'course name',
                  prefixIcon: MyIcons.document,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter course name';
                    }
                    return null;
                  },
                );
              }

              Widget saveButton(context, CoursesScreenCubit cubit) {
                return Padding(
                  padding: EdgeInsets.only(left: 160.w),
                  child: DefaultButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        cubit
                            .addCoursesToFireBase(addCourseController.text)
                            .then((value) {
                          addCourseController.text = '';
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
                        addCourseFieldField(),
                        SizedBox(height: 20.h),
                        state is AddCoursesToFirebaseLoadingState
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

  Widget emptyList(context, String text) {
    return Expanded(
      child: Center(
        child: SizedBox(
          height: 140.h,
          child: Column(
            children: [
              Lottie.asset(AppAnimation.empty, height: 90.h),
              Center(
                child: Text(
                  text,
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: AppColors.secondColor,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
