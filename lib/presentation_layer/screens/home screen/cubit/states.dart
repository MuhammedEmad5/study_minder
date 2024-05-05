
abstract class HomeScreenStates{}

class HomeScreenInitialState extends HomeScreenStates{}


class GetAllTaskLoadingState extends HomeScreenStates{}
class GetAllTaskSuccessState extends HomeScreenStates{}
class GetAllTaskErrorState extends HomeScreenStates{
  final String error;
  GetAllTaskErrorState(this.error);
}

class AddProgressLoadingState extends HomeScreenStates{}
class AddProgressSuccessState extends HomeScreenStates{}
class AddProgressErrorState extends HomeScreenStates{
  final String error;
  AddProgressErrorState(this.error);
}



class OpenGpsSuccessState extends HomeScreenStates{}
class OpenGpsErrorState extends HomeScreenStates{}

class GetLocationSuccessState extends HomeScreenStates{}
class GetLocationErrorState extends HomeScreenStates{}

class GetCityNameSuccessState extends HomeScreenStates{}
class GetCityNameErrorState extends HomeScreenStates{
  final String error;

  GetCityNameErrorState(this.error);
}





























