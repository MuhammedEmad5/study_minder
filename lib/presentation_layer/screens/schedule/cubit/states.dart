abstract class ScheduleScreenStates{}

class ScheduleScreenInitialState extends ScheduleScreenStates{}

class ChangeIndexState extends ScheduleScreenStates{}


class AddLecToFirebaseLoadingState extends ScheduleScreenStates{}
class AddLecToFirebaseSuccessState extends ScheduleScreenStates{}
class AddLecToFirebaseErrorState extends ScheduleScreenStates{
  final String error;
  AddLecToFirebaseErrorState(this.error);
}


class GetLecToFirebaseLoadingState extends ScheduleScreenStates{}
class GetLecToFirebaseSuccessState extends ScheduleScreenStates{}
class GetLecToFirebaseErrorState extends ScheduleScreenStates{
  final String error;
  GetLecToFirebaseErrorState(this.error);
}

class RemoveLecFromFirebaseLoadingState extends ScheduleScreenStates{}
class RemoveLecFromFirebaseSuccessState extends ScheduleScreenStates{}
class RemoveLecFromFirebaseErrorState extends ScheduleScreenStates{
  final String error;
  RemoveLecFromFirebaseErrorState(this.error);
}