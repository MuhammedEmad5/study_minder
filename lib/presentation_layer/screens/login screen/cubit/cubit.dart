import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_minder/presentation_layer/screens/login%20screen/cubit/states.dart';

import '../../../../application_layer/app_functions.dart';
import '../../../../data_layer/models/user_model.dart';


class LoginScreenCubit extends Cubit<LoginScreenStates> {
  LoginScreenCubit() : super(LoginScreenInitialState());

  static LoginScreenCubit get(context) => BlocProvider.of(context);

  bool isPasswordVisible = false;

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    emit(ShowAndHidePasswordState());
  }

  Future<void> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    emit(LoginLoadingState());
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      await getUserName(userCredential.user!.uid).then((value) {
        emit(LoginSuccessState(userCredential.user!.uid,value!));
      });
    } catch (error) {
      emit(LoginErrorState(error.toString()));
    }
  }

  Future<String?> getUserName(uId) async {
    try {
      var documentSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(uId)
          .get();
      if (documentSnapshot.exists) {
        var userData = UserDataModel.fromJson(documentSnapshot.data()!);
        return userData.name;
      } else {
        return null;
      }
    } catch (error) {
      throw Exception(error.toString());
    }
  }


  Future<void> sendPasswordResetEmail(context, String email) async {
    emit(SendPasswordResetEmailLoadingState());
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      AppFunctions.showSnackBar(
          context, 'Password reset email sent. Check your inbox.',
          error: false);
      emit(SendPasswordResetEmailSuccessState());
    } catch (error) {
      AppFunctions.showSnackBar(context, 'Error: $error', error: true);
      emit(SendPasswordResetEmailErrorState(error.toString()));
    }
  }
}
