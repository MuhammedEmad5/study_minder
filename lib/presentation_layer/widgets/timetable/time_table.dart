import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../application_layer/App_colors.dart';
import '../../../data_layer/models/table_time_model.dart';


class TableTimeScreen extends StatelessWidget {
  final String grade;

  const TableTimeScreen({super.key, required this.grade});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text('Table time',
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                fontWeight: FontWeight.w500, color: AppColors.thirdColor)),
      ),
      body: StudyTable(grade: grade,),
    );
  }
}

class StudyTable extends StatefulWidget {
  final String grade;
  const StudyTable({super.key, required this.grade});
  @override
  _StudyTableState createState() => _StudyTableState();
}

class _StudyTableState extends State<StudyTable> {
  Map<String, List<StudySchedule>> studySchedules = {
    'Sunday': [],
    'Monday': [],
    'Tuesday': [],
    'Wednesday': [],
    'Thursday': [],
  };

  final List<String> subjects = [
    'Arabic',
    'English',
    'Math',
    'Sciences',
    'Geography',
    'Religious Education',
  ];

  int selectedWeek = 1; // Default value for the week dropdown
  bool isGettingData = false; // Track if data is being get

  @override
  void initState() {
    super.initState();
    _fetchDataFromFirestore();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(size.width * 0.05),
          child: DropdownButtonFormField<int>(
            value: selectedWeek,
            onChanged: (value) {
              setState(() {
                selectedWeek = value!;
                _fetchDataFromFirestore(); // Fetch data when week changes
              });
            },
            items: List.generate(20, (index) => index + 1).map((week) {
              return DropdownMenuItem<int>(
                value: week,
                child: Text('Week $week'),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: size.height * 0.02),
        Expanded(
          child: ListView.builder(
            itemCount: studySchedules.length,
            itemBuilder: (context, index) {
              String day = studySchedules.keys.elementAt(index);
              return ExpansionTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(day),
                  ],
                ),
                children: _buildStudyScheduleList(day),
              );
            },
          ),
        ),
      ],
    );
  }

  List<Widget> _buildStudyScheduleList(String day) {
    return studySchedules[day]!.map((schedule) {
      return ListTile(
        title: Text(
            '${schedule.subject} (${schedule.startTime} - ${schedule.endTime})'),
      );
    }).toList();
  }

  void _fetchDataFromFirestore() async {
    setState(() {
      studySchedules = {
        'Sunday': [],
        'Monday': [],
        'Tuesday': [],
        'Wednesday': [],
        'Thursday': [],
      };
    });

    final snapshot = await FirebaseFirestore.instance
        .collection('Grade ${widget.grade}')
        .doc('Time Table')
        .collection('Week $selectedWeek')
        .doc('Week $selectedWeek')
        .get();

    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;
      if (data.containsKey('studySchedules')) {
        final studySchedulesData =
        data['studySchedules'] as Map<String, dynamic>;

        setState(() {
          studySchedulesData.forEach((key, value) {
            final List<dynamic> schedules = value;
            studySchedules[key] = schedules
                .map((schedule) => StudySchedule(
              subject: schedule['subject'],
              startTime: schedule['startTime'],
              endTime: schedule['endTime'],
            ))
                .toList();
          });
        });
      }
    }
  }
}

class StudyTableData {
  final Map<String, List<StudySchedule>> studySchedules;

  StudyTableData({required this.studySchedules});

  Map<String, dynamic> toJson() {
    return {
      'studySchedules': studySchedules.map((key, value) =>
          MapEntry(key, value.map((schedule) => schedule.toJson()).toList())),
    };
  }
}
