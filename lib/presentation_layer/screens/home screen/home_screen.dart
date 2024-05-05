import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:study_minder/application_layer/app_functions.dart';
import 'package:study_minder/application_layer/app_strings.dart';
import 'package:study_minder/application_layer/my_icons.dart';
import 'package:study_minder/application_layer/shared_preferences/shared_preferences.dart';
import 'package:study_minder/data_layer/models/task_model.dart';
import 'package:study_minder/presentation_layer/screens/courses/courses_screen.dart';
import 'package:study_minder/presentation_layer/screens/home%20screen/cubit/cubit.dart';
import 'package:study_minder/presentation_layer/screens/home%20screen/cubit/states.dart';
import 'package:study_minder/presentation_layer/screens/tasks/tasks_screen.dart';
import 'package:study_minder/presentation_layer/widgets/loading.dart';
import '../../../application_layer/App_colors.dart';
import '../../../application_layer/app_images.dart';
import '../progress/progress_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final TextEditingController postController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => HomeScreenCubit()..getAllTasks()..getAllData()..addOpenedProgress(),
      child: BlocConsumer<HomeScreenCubit, HomeScreenStates>(
        listener: (BuildContext context, state) {},
        builder: (BuildContext context, Object? state) {
          HomeScreenCubit cubit = HomeScreenCubit.get(context);
          if(cubit.cityName!=null){
            CashHelper.putStringData(key: 'cityName', value: cubit.cityName!);
          }
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
                child: Column(
                  children: [
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        appBarTitle(context),
                        CashHelper.getStringData(key: 'cityName')==null
                            ? LoadingWidget(size: 30)
                            : Row(
                                children: [
                                  Icon(MyIcons.location,color: AppColors.fourthColor,),
                                  SizedBox(width: 4),
                                  Text(
                                    CashHelper.getStringData(key: 'cityName')!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium!
                                        .copyWith(
                                            color: AppColors.fourthColor,
                                            fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                      ],
                    ),
                    SizedBox(height: 25.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Completed tasks',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                  color: AppColors.thirdColor,
                                  fontWeight: FontWeight.w500),
                        ),
                        seeAllButton(context),
                      ],
                    ),
                    state is GetAllTaskLoadingState
                        ? LoadingWidget()
                        : cubit.completedTasks.isEmpty
                            ? emptyList(context,'Let\' do your tasks')
                            : SizedBox(
                                height: 150.h,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) =>
                                      competedTasksItemBuilder(
                                          context, cubit.completedTasks[index]),
                                  separatorBuilder: (context, index) =>
                                      SizedBox(width: 6.h),
                                  itemCount: cubit.completedTasks.length,
                                ),
                              ),
                    SizedBox(height: 25.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          iconBuilder(context, AppAnimation.task, 'tasks', () {
                            AppFunctions.navigateTo(context, TasksScreen());
                          }),
                          iconBuilder(
                              context, AppAnimation.courses, 'courses', () {
                            AppFunctions.navigateTo(context, CoursesScreen());
                          }),
                          iconBuilder(context, AppAnimation.progress,
                              'progress', () {
                                AppFunctions.navigateTo(context, ProgressScreen());
                              }),
                        ],
                      ),
                    ),
                    SizedBox(height: 25.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ongoing tasks',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                  color: AppColors.thirdColor,
                                  fontWeight: FontWeight.w500),
                        ),
                        seeAllButton(context),
                      ],
                    ),
                    state is GetAllTaskLoadingState
                        ? LoadingWidget()
                        : cubit.onGoingTasks.isEmpty
                            ? emptyList(context,'no ongoing tasks yet')
                            : SizedBox(
                                height: 130.h,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) =>
                                      onGoingTasksItemBuilder(
                                          context, cubit.onGoingTasks[index]),
                                  separatorBuilder: (context, index) =>
                                      SizedBox(width: 6.h),
                                  itemCount: cubit.onGoingTasks.length,
                                ),
                              ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget appBarTitle(context) {
    return Column(
      children: [
        Text(
          'Hi, ${AppStrings.name}',
          style: Theme.of(context)
              .textTheme
              .displaySmall!
              .copyWith(fontWeight: FontWeight.w600),
        ),
        Text(
          'Here is your activity',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontWeight: FontWeight.w300),
        ),
      ],
    );
  }

  Widget seeAllButton(context) {
    return TextButton(
      onPressed: () {
        AppFunctions.navigateTo(context, TasksScreen());
      },
      child: Text(
        'see all',
        style: Theme.of(context)
            .textTheme
            .headlineSmall!
            .copyWith(color: Colors.blueGrey, fontWeight: FontWeight.w400),
      ),
    );
  }

  Widget competedTasksItemBuilder(context, TaskModel model) {
    return Card(
      color: AppColors.fourthColor,
      child: SizedBox(
        width: 180.w,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      model.taskName!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          color: AppColors.firstColor, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      model.taskDetails!,
                      textAlign: TextAlign.left,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: AppColors.firstColor, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Completed',
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          color: AppColors.firstColor,
                        ),
                  ),
                  Text(
                    '100 %',
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          color: AppColors.firstColor,
                        ),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              Container(
                height: 3.h,
                width: double.infinity,
                color: AppColors.secondColor,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget iconBuilder(
      context, String animation, String title, VoidCallback function) {
    return InkWell(
      onTap: function,
      child: Card(
        elevation: 5,
        child: Column(
          children: [
            Lottie.asset(animation, height: 60.h, width: 80.w),
            SizedBox(height: 4.h),
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  fontWeight: FontWeight.w600, color: AppColors.thirdColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget onGoingTasksItemBuilder(context, TaskModel model) {
    return Card(
      color: AppColors.secondColor,
      child: SizedBox(
        width: 250.w,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      model.taskName!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          color: AppColors.firstColor, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      model.taskDetails!,
                      textAlign: TextAlign.left,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: AppColors.firstColor, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Due on : ${model.deadline}',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: AppColors.firstColor,
                        ),
                  ),
                  Text(
                    '75 %',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: AppColors.firstColor,
                        ),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              Stack(
                children: [
                  Container(
                    height: 3.h,
                    width: 250.w,
                    color: AppColors.white,
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 65.w),
                    height: 3.h,
                    width: 250.w,
                    color: AppColors.fourthColor,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget emptyList(context,String text) {
    return SizedBox(
      height: 140.h,
      child: Column(
        children: [
          Lottie.asset(AppAnimation.empty,height: 90.h),
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
