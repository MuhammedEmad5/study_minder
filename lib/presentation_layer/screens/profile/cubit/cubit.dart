import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:study_minder/presentation_layer/screens/profile/cubit/states.dart';
import '../../../../../application_layer/shared_preferences/shared_preferences.dart';
import '../../../../../data_layer/models/user_model.dart';



class UserProfileCubit extends Cubit<UserProfileStates> {

  UserProfileCubit() : super(UserProfileInitialState());

  static UserProfileCubit get(context) => BlocProvider.of(context);
  
  UserDataModel? userDataModel;
  Future<void> getUserData()async {
    emit(GetUserDataLoadingState());
    FirebaseFirestore.instance
        .collection('Users')
        .doc(CashHelper.getStringData(key: 'uId'))
        .get()
        .then((value) {
          userDataModel=UserDataModel.fromJson(value.data()!);
          emit(GetUserDataSuccessState());
    }).catchError((error){
      emit(GetUserDataErrorState(error.toString()));
    });
  }


  void updateUserData({
    required String name,
    required String phone,
}){
    emit(UpdateUserDataLoadingState());
    FirebaseFirestore.instance
        .collection('Users')
        .doc(CashHelper.getStringData(key: 'uId'))
        .update(
      {
        'name': name,
        'phone': phone,
      }
    )
        .then((value) {
      getUserData();
    }).catchError((error){
      emit(UpdateUserDataErrorState(error.toString()));
    });
  }


  bool isOpenedToPick=false;
  void isOpen(){
    isOpenedToPick=true;
    emit(IsOpenedToPickState());
  }

  File? pickedImage;
  Future<void> pickProfileImageFromGallery() async {
    isOpenedToPick=false;
    final image =
    await ImagePicker().pickImage(source: ImageSource.gallery,imageQuality: 50);
    if (image != null) {
      pickedImage = File(image.path);
      emit(PickImageSuccessState());
    } else {
      emit(PickImageErrorState());
    }
  }
  Future<void> pickProfileImageFromCamera() async {
    isOpenedToPick=false;
    final image =
    await ImagePicker().pickImage(source: ImageSource.camera,imageQuality: 50);
    if (image != null) {
      pickedImage = File(image.path);
      emit(PickImageSuccessState());
    } else {
      emit(PickImageErrorState());
    }
  }


  Future<void> upLoadProfileImage() async {
    emit(UploadProfileImageLoadingState());
    await FirebaseStorage.instance
        .ref()
        .child("UsersProfileImage/${Uri.file(pickedImage!.path).pathSegments.last}")
        .putFile(pickedImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        saveUploadedProfileImage(value);
      }).catchError((error) {
        if (kDebugMode) {
          print(error.toString());
        }
        emit(UploadProfileImageErrorState(error.toString()));
      });
    }).catchError((error) {
      if (kDebugMode) {
        print('the error${error.toString()}');
      }
      emit(UploadProfileImageErrorState(error.toString()));
    });
  }

  void saveUploadedProfileImage(uploadedProfileImageUrl) {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(CashHelper.getStringData(key: 'uId'))
        .update({
      'userImage': uploadedProfileImageUrl,
    }).then((value) {
      getUserData();
    }).catchError((error) {
      emit(SaveUserProfileImageInFireStoreErrorState(error.toString()));
    });
  }

  Future<void> logOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      if (userDataModel != null) {
        emit(LogOutSuccessState(userDataModel!));
      } else {
        emit(LogOutErrorState("User data model is null"));
      }
    } catch (error) {
      emit(LogOutErrorState(error.toString()));
    }
  }


  Future<void> deleteProfileImage()async {
   await FirebaseFirestore.instance
        .collection('Users')
        .doc(CashHelper.getStringData(key: 'uId'))
        .update({
      'userImage' :'',
    }).then((value) {
      getUserData();
    }).catchError((error){
      emit(DeleteProfileImageErrorState(error.toString()));
    });
  }



}
