import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:study_minder/application_layer/App_colors.dart';
import 'package:study_minder/application_layer/app_images.dart';
import 'package:study_minder/application_layer/my_icons.dart';
import 'package:study_minder/presentation_layer/widgets/default_button.dart';
import 'package:study_minder/presentation_layer/widgets/default_text_form_field.dart';
import 'package:study_minder/presentation_layer/widgets/loading.dart';
import '../../../application_layer/app_functions.dart';
import '../../../data_layer/models/task_model.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class TasksScreen extends StatelessWidget {
  TasksScreen({super.key});

  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController taskDetailsController = TextEditingController();
  final TextEditingController taskDeadLineController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => TaskScreenCubit()..getAllTasks(),
      child: BlocConsumer<TaskScreenCubit, TaskScreenStates>(
        listener: (BuildContext context, state) {},
        builder: (BuildContext context, Object? state) {
          TaskScreenCubit cubit = TaskScreenCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              titleSpacing: 0,
              title: Text(
                'Tasks',
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  color: AppColors.thirdColor,fontWeight: FontWeight.w600
                ),
              ),
              leading: AppFunctions.backButton(context),
            ),
            body: Column(
              children: [
                Expanded(
                  child: state is GetAllTaskLoadingState
                      ? const Center(child: LoadingWidget())
                      : cubit.allTask.isEmpty
                          ? Center(child: emptyList(context))
                          : ListView.separated(
                              itemBuilder: (context, index) => taskBuilder(
                                  context, cubit, cubit.allTask[index]),
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 8.h),
                              itemCount: cubit.allTask.length,
                            ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: AppColors.thirdColor,
              onPressed: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) {
                    return BlocProvider.value(
                      value: cubit,
                      child: BlocConsumer<TaskScreenCubit, TaskScreenStates>(
                        listener:
                            (BuildContext context, TaskScreenStates state) {
                          if (state is AddTaskTaskSuccessState) {
                            Navigator.pop(context);
                            cubit.getAllTasks();
                          }
                        },
                        builder:
                            (BuildContext context, TaskScreenStates state) {
                          TaskScreenCubit cubit = TaskScreenCubit.get(context);
                          return Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: Container(
                              color: Colors.white,
                              padding: const EdgeInsets.all(20.0),
                              child: Form(
                                key: formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    taskNameField(),
                                    SizedBox(height: 20.h),
                                    taskDetailsField(),
                                    SizedBox(height: 20.h),
                                    deadlineField(context, cubit),
                                    SizedBox(height: 20.h),
                                    state is AddTaskTaskLoadingState
                                        ? Padding(
                                            padding:
                                                EdgeInsets.only(left: 160.w),
                                            child: const LoadingWidget(),
                                          )
                                        : saveButton(context, cubit, state),
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
              },
              child: Icon(
                MyIcons.paperUpload,
                color: AppColors.firstColor,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget emptyList(context) {
    return Column(
      children: [
        Lottie.asset(AppAnimation.empty, height: 300.h, width: 150),
        Text(
          'add task now',
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              color: AppColors.secondColor, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget taskBuilder(context, TaskScreenCubit cubit, TaskModel model) {
    return Card(
      color: AppColors.fourthColor,
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.taskName!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        color: AppColors.firstColor, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    model.taskDetails!,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Colors.white70, fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ),
            SizedBox(width: 15.h),
            Column(
              children: [
                Text(
                  'deadLine',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: AppColors.fifthColor, fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 30.h),
                Text(
                  model.deadline!,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: AppColors.fifthColor, fontWeight: FontWeight.w300),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () async {
                     await cubit.completeTask(model.taskUId, model.isCompleted!);
                     !model.isCompleted!
                         ? AppFunctions.progressAddCompleted(model.deadline!, 'taskProgress')
                         : AppFunctions.progressRemoveCompleted(model.deadline!, 'taskProgress');
                    },
                    icon: Icon(
                      Icons.check_circle,
                      size: 30.w,
                      color: model.isCompleted!
                          ? Colors.green
                          : Colors.grey,
                    )
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget taskNameField() {
    return DefaultTextFormField(
      controller: taskNameController,
      inputType: TextInputType.name,
      labelText: 'Task name',
      prefixIcon: MyIcons.document,
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter task name';
        }
        return null;
      },
    );
  }

  Widget taskDetailsField() {
    return DefaultTextFormField(
      controller: taskDetailsController,
      inputType: TextInputType.multiline,
      labelText: 'Task details',
      prefixIcon: MyIcons.infoSquare,
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter task details';
        }
        return null;
      },
    );
  }

  Widget deadlineField(context, TaskScreenCubit cubit) {
    return DefaultTextFormField(
      controller: taskDeadLineController,
      inputType: TextInputType.datetime,
      labelText: 'deadLine',
      prefixIcon: MyIcons.calendar,
      validator: (value) {
        if (value.isEmpty) {
          return 'deadline can\'t be Empty';
        }
        return null;
      },
      onTap: () {
        showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.parse('2100-05-03'),
        ).then((value) {
          taskDeadLineController.text = DateFormat('yyyy-MM-dd').format(value!);
        });
      },
    );
  }

  Widget saveButton(context, TaskScreenCubit cubit, state) {
    return Padding(
      padding: EdgeInsets.only(left: 160.w),
      child: DefaultButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            cubit
                .addTask(
                    taskName: taskNameController.text,
                    taskDetails: taskDetailsController.text,
                    deadline: taskDeadLineController.text)
                .then((value) {
              taskNameController.text = '';
              taskDeadLineController.text = '';
              taskDetailsController.text = '';
            });
            AppFunctions.progressAddAll(taskDeadLineController.text, 'taskProgress');
          }
        },
        child: Text(
          'Save',
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              color: AppColors.firstColor, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
