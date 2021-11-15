import 'dart:convert';
import 'dart:developer';

import 'package:feedsys/Screens/student/data/feedback_data.dart';
import 'package:feedsys/Screens/student/data/feedback_list.dart';
import 'package:feedsys/Screens/student/student_feedback_question_screen.dart';
import 'package:feedsys/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DesktopStudentFeedbackScreen extends StatefulWidget {
  const DesktopStudentFeedbackScreen({Key? key}) : super(key: key);

  @override
  _DesktopStudentFeedbackScreenState createState() =>
      _DesktopStudentFeedbackScreenState();
}

class _DesktopStudentFeedbackScreenState
    extends State<DesktopStudentFeedbackScreen>
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
    return Container(
      color: kBackgroundColor,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0).copyWith(top: 4.0),
        child: Column(
          children: [
            TabBar(
              tabs: list,
              controller: _tabController,
              labelColor: kPrimary,
              unselectedLabelColor: Colors.grey,
              indicatorColor: kPrimary,
            ),
            SizedBox(
              height: 18.0,
            ),
            Container(
              color: kBackgroundColor,
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: FeedbackTableText(text: 'Name'),
                  ),
                  Expanded(
                    flex: 3,
                    child: FeedbackTableText(text: 'Description'),
                  ),
                  Expanded(
                    flex: 2,
                    child: FeedbackTableText(text: 'Created By'),
                  ),
                  Expanded(
                    flex: 2,
                    child: FeedbackTableText(text: 'Due in'),
                  ),
                  Expanded(
                    flex: 2,
                    child: FeedbackTableText(text: 'Give\nFeedback'),
                  )
                ],
              ),
            ),
            Divider(
              color: Colors.black,
              thickness: 2.0,
            ),
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
                                  mainAxisSize: MainAxisSize.min,
                                  children: List.generate(
                                      facultyfeedbackList.length,
                                      (index) => Column(
                                            children: [
                                              MouseRegion(
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    setState(() {
                                                      load = true;
                                                    });
                                                    SharedPreferences
                                                        preferences =
                                                        await SharedPreferences
                                                            .getInstance();
                                                    String? token = preferences
                                                        .getString('token');
                                                    log(token.toString());
                                                    var response = await http.get(
                                                        Uri.parse(
                                                            'https://sgp-feedback-system.herokuapp.com/api/getfeedbackque?id=${facultyfeedbackList[index]['feedbackQuestions']['_id']}'),
                                                        headers: {
                                                          'Authorization':
                                                              'Bearer $token'
                                                        });
                                                    // questions = jsonDecode(response.body)['questions'];
                                                    List questions = jsonDecode(
                                                            response.body)[0]
                                                        ['questions'];
                                                    setState(() {
                                                      load = false;
                                                    });
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                StudentFeedbackQuestionScreen(
                                                                  isCourse:
                                                                      false,
                                                                  questions:
                                                                      questions,
                                                                  id: facultyfeedbackData[
                                                                          index]
                                                                      .feedbackId,
                                                                  callback:
                                                                      (value) {
                                                                    reload =
                                                                        value;
                                                                    setState(
                                                                        () {});
                                                                  },
                                                                )));
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 20.0,
                                                            horizontal: 12.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Expanded(
                                                            flex: 2,
                                                            child: FeedbackTableText(
                                                                text: facultyfeedbackData[
                                                                        index]
                                                                    .title)),
                                                        SizedBox(
                                                          width: 8.0,
                                                        ),
                                                        Expanded(
                                                          flex: 3,
                                                          child: Text(
                                                            facultyfeedbackData[
                                                                    index]
                                                                .desc,
                                                            style: theme
                                                                .textTheme
                                                                .headline6!
                                                                .copyWith(
                                                                    fontSize:
                                                                        16.0),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 1,
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 8.0,
                                                        ),
                                                        Expanded(
                                                          flex: 2,
                                                          child: FeedbackTableText(
                                                              text: facultyfeedbackData[
                                                                      index]
                                                                  .createdBy),
                                                        ),
                                                        SizedBox(
                                                          width: 8.0,
                                                        ),
                                                        Expanded(
                                                            flex: 2,
                                                            child: FeedbackTableText(
                                                                text:
                                                                    '${facultyfeedbackData[index].days} days')),
                                                        SizedBox(
                                                          width: 8.0,
                                                        ),
                                                        Expanded(
                                                          flex: 2,
                                                          child: Center(
                                                            child: Icon(
                                                              Icons
                                                                  .open_in_new_outlined,
                                                              color:
                                                                  Colors.blue,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Divider(
                                                color: Colors.grey,
                                                thickness: 1.5,
                                              )
                                            ],
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
                      : Container(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(
                                  coursefeedbackList.length,
                                  (index) => Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              setState(() {
                                                load = true;
                                              });
                                              SharedPreferences preferences =
                                                  await SharedPreferences
                                                      .getInstance();
                                              String? token = preferences
                                                  .getString('token');
                                              log(token.toString());
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
                                                  vertical: 20.0,
                                                  horizontal: 12.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                      flex: 2,
                                                      child: FeedbackTableText(
                                                          text:
                                                              coursefeedbackData[
                                                                      index]
                                                                  .title)),
                                                  SizedBox(
                                                    width: 8.0,
                                                  ),
                                                  Expanded(
                                                    flex: 3,
                                                    child: SizedBox(
                                                      child: Text(
                                                        coursefeedbackData[
                                                                index]
                                                            .desc,
                                                        style: theme.textTheme
                                                            .headline6!
                                                            .copyWith(
                                                                fontSize: 16.0),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 8.0,
                                                  ),
                                                  Expanded(
                                                      flex: 2,
                                                      child: FeedbackTableText(
                                                          text:
                                                              coursefeedbackData[
                                                                      index]
                                                                  .createdBy)),
                                                  SizedBox(
                                                    width: 8.0,
                                                  ),
                                                  Expanded(
                                                      flex: 2,
                                                      child: FeedbackTableText(
                                                          text:
                                                              '${coursefeedbackData[index].days} days')),
                                                  SizedBox(
                                                    width: 8.0,
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Center(
                                                      child: Icon(
                                                        Icons
                                                            .open_in_new_outlined,
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Divider(
                                            color: Colors.grey,
                                            thickness: 1.5,
                                          )
                                        ],
                                      )),
                            ),
                          ),
                        ),
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FeedbackTableText extends StatelessWidget {
  const FeedbackTableText({Key? key, required this.text, this.color})
      : super(key: key);

  final String text;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Text(
      text,
      style: theme.textTheme.headline6!.copyWith(fontSize: 16.0, color: color),
      textAlign: TextAlign.center,
    );
  }
}
