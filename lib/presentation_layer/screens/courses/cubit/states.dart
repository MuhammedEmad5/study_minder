abstract class CoursesScreenStates{}

class CoursesScreenInitialState extends CoursesScreenStates{}


class AddCoursesToFirebaseLoadingState extends CoursesScreenStates{}
class AddCoursesToFirebaseSuccessState extends CoursesScreenStates{}
class AddCoursesToFirebaseErrorState extends CoursesScreenStates{
  final String error;
  AddCoursesToFirebaseErrorState(this.error);
}


class GetCoursesToFirebaseLoadingState extends CoursesScreenStates{}
class GetCoursesToFirebaseSuccessState extends CoursesScreenStates{}
class GetCoursesToFirebaseErrorState extends CoursesScreenStates{
  final String error;
  GetCoursesToFirebaseErrorState(this.error);
}

class RemoveCoursesFromFirebaseLoadingState extends CoursesScreenStates{}
class RemoveCoursesFromFirebaseSuccessState extends CoursesScreenStates{}
class RemoveCoursesFromFirebaseErrorState extends CoursesScreenStates{
  final String error;
  RemoveCoursesFromFirebaseErrorState(this.error);
}



class PickPdfFileSuccessState extends CoursesScreenStates{}
class PickPdfFileErrorState extends CoursesScreenStates{}


class AddPdfToCourseLoadingState extends CoursesScreenStates{}
class AddPdfToCourseSuccessState extends CoursesScreenStates{}
class AddPdfToCourseErrorState extends CoursesScreenStates{
  final String error;
  AddPdfToCourseErrorState(this.error);
}


class GetPdfFilesByCourseLoadingState extends CoursesScreenStates{}
class GetPdfFilesByCourseSuccessState extends CoursesScreenStates{}
class GetPdfFilesByCourseErrorState extends CoursesScreenStates{
  final String error;
  GetPdfFilesByCourseErrorState(this.error);
}


class DeletePdfFileByCourseLoadingState extends CoursesScreenStates{}
class DeletePdfFileByCourseSuccessState extends CoursesScreenStates{}
class DeletePdfFileByCourseErrorState extends CoursesScreenStates{
  final String error;
  DeletePdfFileByCourseErrorState(this.error);
}


class DeleteAllPdfFileByCourseLoadingState extends CoursesScreenStates{}
class DeleteAllPdfFileByCourseSuccessState extends CoursesScreenStates{}
class DeleteAllPdfFileByCourseErrorState extends CoursesScreenStates{
  final String error;
  DeleteAllPdfFileByCourseErrorState(this.error);
}


