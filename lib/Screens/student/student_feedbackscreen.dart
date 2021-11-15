import 'dart:convert';
import 'dart:developer';

import 'package:feedsys/Screens/student/data/feedback_data.dart';
import 'package:feedsys/Screens/student/data/feedback_list.dart';
import 'package:feedsys/Screens/student/student_feedback_question_screen.dart';
import 'package:feedsys/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:feedsys/Widgets/dropdown.dart' as d;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentFeedbackScreen extends StatefulWidget {
  const StudentFeedbackScreen({Key? key}) : super(key: key);

  @override
  _StudentFeedbackScreenState createState() => _StudentFeedbackScreenState();
}

class _StudentFeedbackScreenState extends State<StudentFeedbackScreen>
    with SingleTickerProviderStateMixin {
  List<String> categoryList = ['Faculty', 'Course', 'Other'];
  String? selectedCategory;
  List facultyfeedbackList = [];
  List coursefeedbackList = [];
  List<FeedbackData> facultyfeedbackData = [];
  List<FeedbackData> coursefeedbackData = [];
  bool load = false;
  bool reload = false;
  late TabController _tabController;

  List<Widget> list = [
    Tab(
        icon: Text(
      'Faculty',
      style: TextStyle(fontSize: 18.0),
    )),
    Tab(
        icon: Text(
      'Course',
      style: TextStyle(fontSize: 18.0),
    )),
  ];

  void extractfacultyFeedbackData() {
    facultyfeedbackData = [];
    facultyfeedbackList.forEach((element) {
      int feedbackEndDate =
          DateTime.parse(element['dueTo']).difference(DateTime.now()).inDays;
      log(feedbackEndDate.toString());
      facultyfeedbackData.add(FeedbackData(
          title: element['name'],
          days: feedbackEndDate,
          createdBy: element['createdBy']['userName'],
          desc: element['description'],
          feedbackId: element['_id']));
    });
  }

  void extractcourseFeedbackData() {
    coursefeedbackData = [];
    coursefeedbackList.forEach((element) {
      int feedbackEndDate =
          DateTime.parse(element['dueTo']).difference(DateTime.now()).inDays;
      log(feedbackEndDate.toString());
      coursefeedbackData.add(FeedbackData(
          title: element['name'],
          days: feedbackEndDate,
          createdBy: element['createdBy']['userName'],
          desc: element['description'],
          feedbackId: element['_id']));
    });
  }

  void getFeedbacks() async {
    setState(() {
      load = true;
    });

    facultyfeedbackList = await getfacultyFeedbackList();
    coursefeedbackList = await getcourseFeedbackList();
    print(facultyfeedbackList.toString());
    extractfacultyFeedbackData();
    extractcourseFeedbackData();
    setState(() {
      load = false;
      reload = false;
    });
  }

  @override
  void initState() {
    getFeedbacks();
    _tabController = TabController(length: list.length, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (reload) {
      getFeedbacks();
    }
    final Size size = MediaQuery.of(context).size;
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!load) ...[
              TabBar(
                tabs: list,
                controller: _tabController,
                labelColor: kPrimary,
                unselectedLabelColor: Colors.grey,
                indicatorColor: kPrimary,
              ),
              SizedBox(
                height: 16.0,
              ),
            ],
            Expanded(
              child: Container(
                child: TabBarView(controller: _tabController, children: [
                  load
                      ? Center(
                          child: SizedBox(
                            height: 45,
                            width: 45,
                            child: CircularProgressIndicator(
                              color: kPrimary,
                            ),
                          ),
                        )
                      : facultyfeedbackList.isEmpty
                          ? Center(
                              child: Text(
                                'No pending feedbacks!!',
                                style: theme.textTheme.headline6,
                              ),
                            )
                          : Container(
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: List.generate(
                                      facultyfeedbackData.length,
                                      (index) => GestureDetector(
                                            onTap: () async {
                                              setState(() {
                                                load = true;
                                              });
                                              SharedPreferences preferences =
                                                  await SharedPreferences
                                                      .getInstance();
                                              String? token = preferences
                                                  .getString('token');
                                              var response = await http.get(
                                                  Uri.parse(
                                                      'https://sgp-feedback-system.herokuapp.com/api/getfeedbackque?id=${facultyfeedbackList[index]['feedbackQuestions']['_id']}'),
                                                  headers: {
                                                    'Authorization':
                                                        'Bearer $token'
                                                  });
                                              // questions = jsonDecode(response.body)['questions'];
                                              List questions =
                                                  jsonDecode(response.body)[0]
                                                      ['questions'];
                                              setState(() {
                                                load = false;
                                              });
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          StudentFeedbackQuestionScreen(
                                                            isCourse: false,
                                                            questions:
                                                                questions,
                                                            id: facultyfeedbackData[
                                                                    index]
                                                                .feedbackId,
                                                            callback: (value) {
                                                              reload = value;
                                                              setState(() {});
                                                            },
                                                          )));
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16.0,
                                                  vertical: 12.0),
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 16.0,
                                                  vertical: 8.0),
                                              height: 110,
                                              width: size.width - 50,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  border: Border.all(
                                                      color: kPrimary),
                                                  color: kBackgroundColor),
                                              child: Row(
                                                children: [
                                                  CircleAvatar(
                                                    radius: 32.0,
                                                  ),
                                                  SizedBox(width: 16.0),
                                                  Expanded(
                                                    child: Container(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            facultyfeedbackData[
                                                                    index]
                                                                .title,
                                                            style: theme
                                                                .textTheme
                                                                .headline6,
                                                          ),
                                                          SizedBox(
                                                            height: 16.0,
                                                          ),
                                                          Text(
                                                            'Due in ${facultyfeedbackData[index].days} days',
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )),
                                ),
                              ),
                            ),
                  load
                      ? Center(
                          child: SizedBox(
                            height: 45,
                            width: 45,
                            child: CircularProgressIndicator(
                              color: kPrimary,
                            ),
                          ),
                        )
                      : coursefeedbackList.isEmpty
                          ? Center(
                              child: Text(
                                'No pending feedbacks!!',
                                style: theme.textTheme.headline6,
                              ),
                            )
                          : Container(
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: List.generate(
                                      coursefeedbackData.length,
                                      (index) => GestureDetector(
                                            onTap: () async {
                                              setState(() {
                                                load = true;
                                              });
                                              SharedPreferences preferences =
                                                  await SharedPreferences
                                                      .getInstance();
                                              String? token = preferences
                                                  .getString('token');
                                              var response = await http.get(
                                                  Uri.parse(
                                                      'https://sgp-feedback-system.herokuapp.com/api/getfeedbackque?id=${coursefeedbackList[index]['feedbackQuestions']['_id']}'),
                                                  headers: {
                                                    'Authorization':
                                                        'Bearer $token'
                                                  });
                                              // questions = jsonDecode(response.body)['questions'];
                                              List questions =
                                                  jsonDecode(response.body)[0]
                                                      ['questions'];
                                              setState(() {
                                                load = false;
                                              });
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          StudentFeedbackQuestionScreen(
                                                            isCourse: true,
                                                            questions:
                                                                questions,
                                                            id: coursefeedbackData[
                                                                    index]
                                                                .feedbackId,
                                                            callback: (value) {
                                                              reload = value;
                                                              setState(() {});
                                                            },
                                                          )));
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16.0,
                                                  vertical: 12.0),
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 16.0,
                                                  vertical: 8.0),
                                              height: 110,
                                              width: size.width - 50,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  border: Border.all(
                                                      color: kPrimary),
                                                  color: kBackgroundColor),
                                              child: Row(
                                                children: [
                                                  CircleAvatar(
                                                    radius: 32.0,
                                                  ),
                                                  SizedBox(width: 16.0),
                                                  Expanded(
                                                    child: Container(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            coursefeedbackData[
                                                                    index]
                                                                .title,
                                                            style: theme
                                                                .textTheme
                                                                .headline6,
                                                          ),
                                                          SizedBox(
                                                            height: 16.0,
                                                          ),
                                                          Text(
                                                            'Due in ${coursefeedbackData[index].days} days',
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )),
                                ),
                              ),
                            ),
                ]),
              ),
            ),
          ]),
    );
  }
}
