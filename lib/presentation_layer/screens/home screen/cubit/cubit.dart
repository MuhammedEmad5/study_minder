import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:study_minder/application_layer/app_strings.dart';
import 'package:study_minder/presentation_layer/screens/home%20screen/cubit/states.dart';
import '../../../../application_layer/app_functions.dart';
import '../../../../application_layer/shared_preferences/shared_preferences.dart';
import '../../../../data_layer/models/task_model.dart';


class HomeScreenCubit extends Cubit<HomeScreenStates> {

  HomeScreenCubit() : super(HomeScreenInitialState());

  static HomeScreenCubit get(context) => BlocProvider.of(context);

  List<TaskModel> completedTasks = [];
  List<TaskModel> onGoingTasks = [];

  Future<void> getAllTasks() async {
    emit(GetAllTaskLoadingState());
    try {
      await FirebaseFirestore.instance
          .collection('AllTasks')
          .orderBy('timestamp')
          .snapshots()
          .listen((QuerySnapshot<Map<String, dynamic>> assignments) {
        completedTasks.clear();
        onGoingTasks.clear();
        for (var doc in assignments.docs) {
          TaskModel task = TaskModel.fromJson(doc.data());
          if(task.myUid==AppStrings.uId){
            if (task.isCompleted!) {
              completedTasks.add(task);
            } else {
              onGoingTasks.add(task);
            }
          }
        }
        emit(GetAllTaskSuccessState());
      });
    } catch (error) {
      emit(GetAllTaskErrorState(error.toString()));
    }
  }

  Future<void> addOpenedProgress()async {
    emit(AddProgressLoadingState());
    bool todayProgressOpened = CashHelper.getBoolData(
        key: DateFormat('yyyy-MM-dd').format(DateTime.now())) ?? false;
    try{
      if (!todayProgressOpened) {
        await AppFunctions.progressAddAll(
            DateFormat('yyyy-MM-dd').format(DateTime.now()), 'openedProgress');

        await AppFunctions.progressAddCompleted(
            DateFormat('yyyy-MM-dd').format(DateTime.now()), 'openedProgress')
            .then((value) {
          CashHelper.deleteData(
              key: DateFormat('yyyy-MM-dd')
                  .format(DateTime.now().subtract(Duration(days: 1))));
          CashHelper.putBoolData(
              key: DateFormat('yyyy-MM-dd').format(DateTime.now()), value: true);
        });
      }
      emit(AddProgressSuccessState());
    }catch(error){
      emit(AddProgressErrorState(error.toString()));
    }
  }




  Future<void> openGps() async {
    try {
      Location gps = Location();
      bool isOn = await gps.serviceEnabled();
      if (!isOn) {
        await gps.requestService();
        emit(OpenGpsSuccessState());
      }
    } catch (e) {
      print('Error enabling GPS: $e');
      emit(OpenGpsErrorState());
    }
  }

  Position? position;
  Future<void> getLocationLatAndLon() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');

      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {

          throw Exception('Location permissions are denied.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

       position = await Geolocator.getCurrentPosition();
      emit(GetLocationSuccessState());
    } catch (e) {
      print('Error getting location: $e');
      emit(GetLocationErrorState());
      throw e;

    }
  }

  String? cityName;
  Future<void> getCityNameFromLocation(Position position) async {
    try {
      List<geocoding.Placemark> placeMarks = await geocoding.placemarkFromCoordinates(
          position.latitude, position.longitude);

      cityName = placeMarks[0].locality!;
      emit(GetCityNameSuccessState());
    } catch (e) {
      print('Error getting city name: $e');
      emit(GetCityNameErrorState(e.toString()));
    }
  }

  Future<void> getAllData() async {
    try {
      await openGps();
      await getLocationLatAndLon();
      await getCityNameFromLocation(position!);
    } catch (e) {
      print('Error fetching all data: $e');
    }
  }

}
