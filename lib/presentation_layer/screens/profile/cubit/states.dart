import '../../../../data_layer/models/user_model.dart';

abstract class UserProfileStates{}

class UserProfileInitialState extends UserProfileStates{}

class GetUserDataLoadingState extends UserProfileStates{}
class GetUserDataSuccessState extends UserProfileStates{}
class GetUserDataErrorState extends UserProfileStates{
  final String error;

  GetUserDataErrorState(this.error);
}

class UpdateUserDataLoadingState extends UserProfileStates{}
class UpdateUserDataErrorState extends UserProfileStates{
  final String error;

  UpdateUserDataErrorState(this.error);

}

class IsOpenedToPickState extends UserProfileStates{}


class PickImageSuccessState extends UserProfileStates{}
class PickImageErrorState extends UserProfileStates{}

class UploadProfileImageLoadingState extends UserProfileStates{}
class UploadProfileImageErrorState extends UserProfileStates{
  final String error;
  UploadProfileImageErrorState(this.error);
}

class SaveUserProfileImageInFireStoreErrorState extends UserProfileStates{
  final String error;
  SaveUserProfileImageInFireStoreErrorState(this.error);
}

class LogOutSuccessState extends UserProfileStates{
   UserDataModel userDataModel;

  LogOutSuccessState(this.userDataModel);
}
class LogOutErrorState extends UserProfileStates{
  final String error;
  LogOutErrorState(this.error);
}

class DeleteProfileImageSuccessState extends UserProfileStates{}
class DeleteProfileImageErrorState extends UserProfileStates{
  final String error;
  DeleteProfileImageErrorState(this.error);
}

class DeletePickedImageSuccessState extends UserProfileStates{}


























