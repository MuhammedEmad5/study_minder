
class TaskModel {
  String? taskName;
  String? deadline;
  String? taskUId;
  String? taskDetails;
  String? myUid;
  bool? isCompleted;
  DateTime? timestamp;

  TaskModel({
    this.taskName,
    this.deadline,
    this.timestamp,
    this.taskUId,
    this.taskDetails,
    this.isCompleted,
    this.myUid
  });

   TaskModel.fromJson(Map<String, dynamic> json) {
    taskName= json['taskName'];
    deadline= json['deadline'];
    taskDetails= json['taskDetails'];
    taskUId=json['taskUId'];
    isCompleted=json['isCompleted'];
    myUid=json['myUid'];
    timestamp= json['timestamp'].toDate();
  }

  Map<String, dynamic> toJson() {
    return {
      'taskName': taskName,
      'taskDetails': taskDetails,
      'deadline': deadline,
      'myUid':myUid,
      'isCompleted':isCompleted,
      'taskUId':taskUId,
      'timestamp': timestamp,
    };
  }
}
