abstract class LoginScreenStates{}

class LoginScreenInitialState extends LoginScreenStates{}

class ShowAndHidePasswordState extends LoginScreenStates{}

class LoginLoadingState extends LoginScreenStates{}
class LoginSuccessState extends LoginScreenStates{
  final String uId;
  final String name;
  LoginSuccessState(this.uId, this.name);
}
class LoginErrorState extends LoginScreenStates{
  final String error;
  LoginErrorState(this.error);
}

class SendPasswordResetEmailLoadingState extends LoginScreenStates{}
class SendPasswordResetEmailSuccessState extends LoginScreenStates{}
class SendPasswordResetEmailErrorState extends LoginScreenStates{
  final String error;
  SendPasswordResetEmailErrorState(this.error);
}