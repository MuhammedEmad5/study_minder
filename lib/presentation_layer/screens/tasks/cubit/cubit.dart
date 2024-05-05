import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_minder/application_layer/app_strings.dart';
import 'package:study_minder/presentation_layer/screens/tasks/cubit/states.dart';
import '../../../../data_layer/models/task_model.dart';


class TaskScreenCubit extends Cubit<TaskScreenStates> {
  TaskScreenCubit() : super(TaskScreenInitialState());

  static TaskScreenCubit get(context) => BlocProvider.of(context);

  List<TaskModel> allTask = [];
  Future<void> getAllTasks() async {
    emit(GetAllTaskLoadingState());
    try {
      QuerySnapshot<Map<String, dynamic>> assignments = await FirebaseFirestore
          .instance
          .collection('AllTasks')
          .orderBy('timestamp')
          .get();
      allTask.clear();
      for (var doc in assignments.docs) {
        TaskModel task = TaskModel.fromJson(doc.data());
        if(task.myUid==AppStrings.uId){
          allTask.add(task);
        }
      }
      emit(GetAllTaskSuccessState());
    } catch (error) {
      emit(GetAllTaskErrorState(error.toString()));
    }
  }


  Future<void> addTask({
    required String taskName,
    required String taskDetails,
    required String deadline,
  }) async {
    emit(AddTaskTaskLoadingState());

    TaskModel taskModel = TaskModel(
      taskName: taskName,
      timestamp: DateTime.now(),
      deadline: deadline,
      taskDetails: taskDetails,
      isCompleted: false,
      myUid: AppStrings.uId,
      taskUId: '',
    );

    try {
      DocumentReference docRef = await FirebaseFirestore.instance
          .collection('AllTasks')
          .add(taskModel.toJson());
      String docId = docRef.id;
      taskModel.taskUId = docId;

      await FirebaseFirestore.instance
          .collection('AllTasks')
          .doc(docId)
          .update(taskModel.toJson());

      emit(AddTaskTaskSuccessState());
    } catch (error) {
      emit(AddTaskTaskErrorState(error.toString()));
    }
  }


  Future<void> completeTask(docId,bool isCompleted) async {
    emit(CompleteTaskTaskLoadingState());
    try {
      if(isCompleted){
        await FirebaseFirestore.instance
            .collection('AllTasks')
            .doc(docId)
            .update({'isCompleted': false});
      }
      else{
        await FirebaseFirestore.instance
            .collection('AllTasks')
            .doc(docId)
            .update({'isCompleted': true});
      }
      emit(CompleteTaskTaskSuccessState());
      getAllTasks();
    } catch (error) {
      emit(CompleteTaskTaskErrorState(error.toString()));
    }
  }





}
