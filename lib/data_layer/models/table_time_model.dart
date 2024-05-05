class StudySchedule {
  final String subject;
  final String startTime;
  final String endTime;

  StudySchedule({
    required this.subject,
    required this.startTime,
    required this.endTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'subject': subject,
      'startTime': startTime,
      'endTime': endTime,
    };
  }
}
