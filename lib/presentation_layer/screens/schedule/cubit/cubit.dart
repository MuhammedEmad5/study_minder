import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_minder/presentation_layer/screens/schedule/cubit/states.dart';


class ScheduleScreenCubit extends Cubit<ScheduleScreenStates> {
  ScheduleScreenCubit() : super(ScheduleScreenInitialState());

  static ScheduleScreenCubit get(context) => BlocProvider.of(context);

  int currentIndex=0;

  void changeIndex(index){
    currentIndex=index;
    emit(ChangeIndexState());
  }

  Future<void> addLecToFireBase({
    required String date,
    required String name,
    required String startTime,
    required String endTime,
}) async {
    emit(AddLecToFirebaseLoadingState());
    try{
      await FirebaseFirestore.instance
          .collection('Schedule')
          .doc(date)
          .collection('lectures')
          .add({
        'name': name,
        'start_time': startTime,
        'end_time': endTime,
      });
      emit(AddLecToFirebaseSuccessState());
      getLecturesForDay(date);
    }catch(error){
      emit(AddLecToFirebaseErrorState(error.toString()));
    }
  }


  List<String> documentIds=[];
  List<DocumentSnapshot> lecturesData = [];
  Future<void> getLecturesForDay(String selectedDate) async {
    emit(GetLecToFirebaseLoadingState());
    try{
      QuerySnapshot<Map<String, dynamic>> querySnapshot=await FirebaseFirestore.instance
          .collection('Schedule')
          .doc(selectedDate)
          .collection('lectures')
          .get();
      lecturesData = querySnapshot.docs;
      documentIds = querySnapshot.docs.map((doc) => doc.id).toList();
      emit(GetLecToFirebaseSuccessState());
    }catch(error){
      emit(GetLecToFirebaseErrorState(error.toString()));
    }

  }

  void removeLecture(int index, String date) async {
    emit(RemoveLecFromFirebaseLoadingState());
    lecturesData.removeAt(index);
    try {
      await FirebaseFirestore.instance
          .collection('Schedule')
          .doc(date)
          .collection('lectures')
          .doc(documentIds[index])
          .delete();
      documentIds.removeAt(index);
      emit(RemoveLecFromFirebaseSuccessState());
      getLecturesForDay(date);
    } catch (error) {
      emit(RemoveLecFromFirebaseErrorState(error.toString()));
    }
  }


}
