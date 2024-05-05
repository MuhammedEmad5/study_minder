import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_minder/presentation_layer/screens/courses/cubit/states.dart';

import '../../../../application_layer/app_strings.dart';
import '../../../../application_layer/sqflite/sqflite.dart';


class CoursesScreenCubit extends Cubit<CoursesScreenStates> {
  CoursesScreenCubit() : super(CoursesScreenInitialState());

  static CoursesScreenCubit get(context) => BlocProvider.of(context);


  Future<void> addCoursesToFireBase(String courseName) async {
    emit(AddCoursesToFirebaseLoadingState());
    try {
      await FirebaseFirestore.instance
          .collection('Courses')
          .doc(courseName)
          .set({'uId': AppStrings.uId});
      emit(AddCoursesToFirebaseSuccessState());
      await getCourses(); // Wait for getCourses to complete before emitting state
    } catch (error) {
      emit(AddCoursesToFirebaseErrorState(error.toString()));
    }
  }

  List<String> courses = [];

  Future<void> getCourses() async {
    emit(GetCoursesToFirebaseLoadingState());
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance
          .collection('Courses')
          .where('uId', isEqualTo: AppStrings.uId) // Filter by uId
          .get();
      courses = querySnapshot.docs.map((doc) => doc.id).toList();
      emit(GetCoursesToFirebaseSuccessState());
    } catch (error) {
      emit(GetCoursesToFirebaseErrorState(error.toString()));
    }
  }

  void removeCourses(String courseName) async {
    emit(RemoveCoursesFromFirebaseLoadingState());
    try {
      await FirebaseFirestore.instance
          .collection('Courses')
          .doc(courseName)
          .delete();
      courses.remove(courseName);
      emit(RemoveCoursesFromFirebaseSuccessState());
      await getCourses(); // Wait for getCourses to complete before emitting state
    } catch (error) {
      emit(RemoveCoursesFromFirebaseErrorState(error.toString()));
    }
  }



  String? pickedFilePath;
  String? pickedFileName;

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
      ], // Adjust allowed file types as needed
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      pickedFilePath = file.path;
      pickedFileName = file.name;
      emit(PickPdfFileSuccessState());
    } else {
      emit(PickPdfFileErrorState());
    }
  }

  // Add PDF file to a specific course
  Future<void> addPdfToCourse(String courseId) async {
    emit(AddPdfToCourseLoadingState());
    try {
      if (pickedFilePath != null) {
        Map<String, dynamic> pdf = {
          DatabaseHelper.columnName: pickedFileName,
          DatabaseHelper.columnPath: pickedFilePath,
          DatabaseHelper.columnCourseId: courseId,
        };
        await DatabaseHelper.instance.insertPdf(pdf);
        emit(AddPdfToCourseSuccessState());
        getPdfFilesByCourse(courseId);
      } else {
        emit(AddPdfToCourseErrorState('an error'));
      }
    } catch (error) {
      emit(AddPdfToCourseErrorState(error.toString()));
    }
  }

  // Get all PDF files associated with a specific course
  List<Map<String, dynamic>> pdfFiles=[];
  void getPdfFilesByCourse(String courseId) async {
    emit(GetPdfFilesByCourseLoadingState());
    try {
      pdfFiles = await DatabaseHelper.instance.queryRowsByCourseId(courseId);
      emit(GetPdfFilesByCourseSuccessState());
    } catch (error) {
      emit(GetPdfFilesByCourseErrorState(error.toString()));
    }
  }

  // Delete a PDF file associated with a specific course
  void deletePdfFileByCourse(String courseId, int id) async {
    emit(DeletePdfFileByCourseLoadingState());
    try {
      await DatabaseHelper.instance.deletePdfByCourseId(courseId, id);
      emit(DeletePdfFileByCourseSuccessState());
      getPdfFilesByCourse(courseId);
    } catch (error) {
      emit(DeletePdfFileByCourseErrorState(error.toString()));
    }
  }


  // Delete all PDF files associated with a specific course ID
  void deleteAllPdfFilesByCourse(String courseId) async {
    emit(DeleteAllPdfFileByCourseLoadingState());
    try {
      // Get all PDF files associated with the course ID
      List<Map<String, dynamic>> pdfFiles =
          await DatabaseHelper.instance.queryRowsByCourseId(courseId);

      // Iterate through each PDF file and delete it
      for (Map<String, dynamic> pdfFile in pdfFiles) {
        int id = pdfFile[DatabaseHelper.columnId];
        await DatabaseHelper.instance.deletePdfByCourseId(courseId, id);
      }

      // Update the state and notify listeners
      emit(DeleteAllPdfFileByCourseSuccessState());

      // Optionally, you can reload the PDF files for the course after deletion
      getPdfFilesByCourse(courseId);
    } catch (error) {
      emit(DeleteAllPdfFileByCourseErrorState(error.toString()));
    }
  }


}
