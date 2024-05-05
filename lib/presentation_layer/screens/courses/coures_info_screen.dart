import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:study_minder/presentation_layer/screens/courses/cubit/cubit.dart';
import 'package:study_minder/presentation_layer/screens/courses/cubit/states.dart';
import '../../../application_layer/App_colors.dart';
import '../../../application_layer/app_functions.dart';
import '../../../application_layer/app_images.dart';
import '../../../application_layer/my_icons.dart';
import '../../../application_layer/sqflite/sqflite.dart';
import '../../widgets/default_button.dart';
import '../../widgets/loading.dart';


class CourseInfoScreen extends StatelessWidget {
  const CourseInfoScreen({super.key, required this.courseName});

  final String courseName;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => CoursesScreenCubit()..getPdfFilesByCourse(courseName),
      child: BlocConsumer<CoursesScreenCubit, CoursesScreenStates>(
        listener: (BuildContext context, state) {
          if(state is DeletePdfFileByCourseSuccessState){
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
                courseName,
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    color: AppColors.thirdColor, fontWeight: FontWeight.w600),
              ),
              leading: AppFunctions.backButton(context),
            ),
            body: Column(
              children: [
                Expanded(
                  child: state is GetPdfFilesByCourseLoadingState
                      ? const Center(child: LoadingWidget())
                      : cubit.pdfFiles.isEmpty
                          ? Center(child: emptyList(context))
                          : ListView.separated(
                              itemBuilder: (context, index) =>
                                  pdfFileItemBuilder(context,cubit.pdfFiles[index],cubit,index),
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 8.h),
                              itemCount: cubit.pdfFiles.length,
                            ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) {
                    return BlocProvider.value(
                      value: cubit,
                      child:
                          BlocConsumer<CoursesScreenCubit, CoursesScreenStates>(
                        listener:
                            (BuildContext context, CoursesScreenStates state) {
                          if (state is AddPdfToCourseSuccessState) {
                            Navigator.pop(context);
                            cubit.getPdfFilesByCourse(courseName);
                            cubit.pickedFileName = null;
                            cubit.pickedFilePath = null;
                          }
                        },
                        builder:
                            (BuildContext context, CoursesScreenStates state) {
                          return Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: Container(
                              color: Colors.white,
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  uploadFileTextButton(cubit),
                                  SizedBox(height: 20.h),
                                  state is AddPdfToCourseLoadingState
                                      ? Padding(
                                          padding: EdgeInsets.only(left: 160.w),
                                          child: const LoadingWidget(),
                                        )
                                      : saveButton(context, cubit, state),
                                ],
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

  Widget pdfFileItemBuilder(context, Map<String, dynamic> pdfFile,CoursesScreenCubit cubit,index) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            Icon(
              Icons.picture_as_pdf_rounded,
              size: 30,
              color: AppColors.thirdColor,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                '${pdfFile[DatabaseHelper.columnName]}',
                style: TextStyle(fontSize: 16), // Adjust font size as needed
              ),
            ),
            IconButton(
              icon: Icon(MyIcons.delete,color: AppColors.fifthColor,),
              onPressed: () {
                cubit.deletePdfFileByCourse(courseName,pdfFile[DatabaseHelper.columnId] );
              },
            ),
          ],
        ),
      ),
    );
  }


  Widget uploadFileTextButton(CoursesScreenCubit cubit) {
    return Row(
      children: [
        TextButton(
          onPressed: () {
            cubit.pickFile();
          },
          child: const Text('upload file'),
        ),
        SizedBox(width: 30.w),
        cubit.pickedFileName == null
            ? const SizedBox.shrink()
            : Expanded(child: Text(cubit.pickedFileName!))
      ],
    );
  }

  Widget saveButton(context, CoursesScreenCubit cubit, state) {
    return Padding(
      padding: EdgeInsets.only(left: 160.w),
      child: DefaultButton(
        onPressed: () {
          if (cubit.pickedFilePath != null) {
            cubit.addPdfToCourse(courseName);
             AppFunctions.progressAddAll(DateFormat('yyyy-MM-dd').format(DateTime.now()), 'lecProgress');
             AppFunctions.progressAddCompleted(DateFormat('yyyy-MM-dd').format(DateTime.now()), 'lecProgress');
          } else {
            AppFunctions.showSnackBar(context, 'please upload file',
                error: true);
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

  Widget emptyList(context) {
    return Column(
      children: [
        Lottie.asset(AppAnimation.empty, height: 300.h, width: 150),
        Text(
          'no pdf files yet',
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              color: AppColors.secondColor, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
