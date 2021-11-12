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
  // final List feedbackResponseList;

  @override
  _StudentFeedbackScreenState createState() => _StudentFeedbackScreenState();
}

class _StudentFeedbackScreenState extends State<StudentFeedbackScreen> {
  List<String> categoryList = ['Faculty', 'Course', 'Other'];
  String? selectedCategory;
  List feedbackList = [];
  List<FeedbackData> feedbackData = [];
  bool load = false;
  bool reload = false;

  void extractFeedbackData() {
    feedbackData = [];
    feedbackList.forEach((element) {
      int feedbackEndDate =
          DateTime.parse(element['dueTo']).difference(DateTime.now()).inDays;
      log(feedbackEndDate.toString());
      feedbackData.add(FeedbackData(
          title: element['name'],
          date: feedbackEndDate,
          feedbackId: element['_id']));
    });
  }

  void getFeedbacks() async {
    setState(() {
      load = true;
    });
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    // String? id = preferences.getString('_id');
    // // String? institute = preferences.getString('institute');
    // // String? department = preferences.getString('department');
    // // int? sem = preferences.getInt('sem');
    // // log(sem.toString());

    // var UserResponse = await http.get(
    //     Uri.parse("https://sgp-feedback-system.herokuapp.com/api/user?id=$id"));
    // String institute = jsonDecode(UserResponse.body)['institute'];
    // String dept = jsonDecode(UserResponse.body)['department'];
    // int sem = jsonDecode(UserResponse.body)['sem'];

    // var feedbackListResponse = await http.get(Uri.parse(
    //     "https://sgp-feedback-system.herokuapp.com/api/getfeedbacklist?institute=$institute&department=$dept&sem=$sem"));

    // feedbackList = jsonDecode(feedbackListResponse.body);
    // print(feedbackList[0]['feedbackQuestions']);
    // log(jsonDecode(feedbackListResponse.body).toString());

    feedbackList = await getFeedbackList();
    print(feedbackList.toString());
    extractFeedbackData();
    setState(() {
      load = false;
      reload = false;
    });
  }

  @override
  void initState() {
    getFeedbacks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (reload) {
      getFeedbacks();
    }
    print('reload');
    final Size size = MediaQuery.of(context).size;
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Container(
            //   padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 4.0),
            //   decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(16.0),
            //       border: Border.all(color: Colors.grey)),
            //   child: d.DropdownButtonHideUnderline(
            //     child: d.DropdownButton<String>(
            //       borderRadius: BorderRadius.vertical(
            //         bottom: Radius.circular(12),
            //       ),
            //       focusColor: kBackgroundColor,
            //       value: selectedCategory,
            //       icon: Icon(Icons.expand_more_outlined),
            //       style: theme.textTheme.headline6!.copyWith(fontSize: 16.0),
            //       iconEnabledColor: Colors.black,
            //       items:
            //           categoryList.map<d.DropdownMenuItem<String>>((String value) {
            //         return d.DropdownMenuItem<String>(
            //           value: value,
            //           child: Text(
            //             value,
            //             style: theme.textTheme.headline6!.copyWith(fontSize: 16.0),
            //           ),
            //         );
            //       }).toList(),
            //       hint: Text(
            //         "Select category",
            //         style: TextStyle(
            //             color: Colors.grey,
            //             fontSize: 14,
            //             fontWeight: FontWeight.w500),
            //       ),
            //       onChanged: (value) {
            //         setState(() {
            //           selectedCategory = value!;
            //         });
            //       },
            //     ),
            //   ),
            // ),
            // SizedBox(
            //   height: 16.0,
            // ),
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
                : feedbackList.isEmpty
                    ? Center(
                        child: Text(
                          'No pending feedbacks!!',
                          style: theme.textTheme.headline6,
                        ),
                      )
                    : Expanded(
                        child: Container(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: List.generate(
                                  feedbackData.length,
                                  (index) => GestureDetector(
                                        onTap: () async {
                                          setState(() {
                                            load = true;
                                          });
                                          SharedPreferences preferences =
                                              await SharedPreferences
                                                  .getInstance();
                                          String? token =
                                              preferences.getString('token');
                                          var response = await http.get(
                                              Uri.parse(
                                                  'https://sgp-feedback-system.herokuapp.com/api/getfeedbackque?id=${feedbackList[index]['feedbackQuestions']['_id']}'),
                                              headers: {
                                                'Authorization': 'Bearer $token'
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
                                                        questions: questions,
                                                        id: feedbackData[index]
                                                            .feedbackId,
                                                        callback: (value) {
                                                          reload = value;
                                                          setState(() {});
                                                        },
                                                      )));
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16.0, vertical: 12.0),
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 16.0, vertical: 8.0),
                                          height: 110,
                                          width: size.width - 50,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              border:
                                                  Border.all(color: kPrimary),
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
                                                        feedbackData[index]
                                                            .title,
                                                        style: theme.textTheme
                                                            .headline6,
                                                      ),
                                                      SizedBox(
                                                        height: 16.0,
                                                      ),
                                                      Text(
                                                        'Due in ${feedbackData[index].date} days',
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
                      ),
          ]),
    );
  }
}
