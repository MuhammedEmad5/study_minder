abstract class TaskScreenStates{}

class TaskScreenInitialState extends TaskScreenStates{}

class GetAllTaskLoadingState extends TaskScreenStates{}
class GetAllTaskSuccessState extends TaskScreenStates{}
class GetAllTaskErrorState extends TaskScreenStates{
  final String error;
  GetAllTaskErrorState(this.error);
}

class AddTaskTaskLoadingState extends TaskScreenStates{}
class AddTaskTaskSuccessState extends TaskScreenStates{}
class AddTaskTaskErrorState extends TaskScreenStates{
  final String error;
  AddTaskTaskErrorState(this.error);
}

class CompleteTaskTaskLoadingState extends TaskScreenStates{}
class CompleteTaskTaskSuccessState extends TaskScreenStates{}
class CompleteTaskTaskErrorState extends TaskScreenStates{
  final String error;
  CompleteTaskTaskErrorState(this.error);
}