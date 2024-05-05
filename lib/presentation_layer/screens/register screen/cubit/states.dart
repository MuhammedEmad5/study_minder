abstract class RegisterScreenStates{}

class RegisterScreenInitialState extends RegisterScreenStates{}


class PasswordVisibilityChangedState extends RegisterScreenStates{}

class RegisterEmailLoadingState extends RegisterScreenStates{}
class RegisterEmailErrorState extends RegisterScreenStates{
  final String error;
  RegisterEmailErrorState(this.error);
}

class SaveUserDataSuccessState extends RegisterScreenStates{
  final String uId;

  SaveUserDataSuccessState(this.uId);
}
class SaveUserDataErrorState extends RegisterScreenStates{
  final String error;
  SaveUserDataErrorState(this.error);
}
