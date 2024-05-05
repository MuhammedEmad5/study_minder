abstract class ProgressScreenStates{}

class ProgressScreenInitialState extends ProgressScreenStates{}

class GetProgressLoadingState extends ProgressScreenStates{}
class GetProgressSuccessState extends ProgressScreenStates{}
class GetProgressErrorState extends ProgressScreenStates{
  final String error;
  GetProgressErrorState(this.error);
}
