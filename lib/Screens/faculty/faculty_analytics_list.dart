import 'dart:convert';
import 'dart:developer';

import 'package:feedsys/Screens/faculty/data/analytic_data.dart';
import 'package:feedsys/Screens/faculty/faculty_analytics_scaffold.dart';
import 'package:feedsys/Widgets/feedback_card.dart';
import 'package:feedsys/constants/colors.dart';
import 'package:feedsys/utils/device_info.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FacultyAnalyticsListScreen extends StatefulWidget {
  const FacultyAnalyticsListScreen({Key? key}) : super(key: key);

  @override
  _FacultyAnalyticsListScreenState createState() =>
      _FacultyAnalyticsListScreenState();
}

class _FacultyAnalyticsListScreenState extends State<FacultyAnalyticsListScreen>
    with SingleTickerProviderStateMixin {
  bool load = false;
  List<FeedbackAnalytics> feedbackAnalyticsList = [];
  List<Courses> courses = [];
  List<FeedbackAnalytics> courseFeedbackAnalytics = [];

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
  void getcoursefeedbackresponse() async {
    setState(() {
      load = true;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();

    String? institute = preferences.getString('institute');
    String? department = preferences.getString('department');
    String? token = preferences.getString('token');
    var coursesResponse = await http.get(
        Uri.parse(
          'https://sgp-feedback-system.herokuapp.com/api/courses?institute=$institute&department=$department',
        ),
        headers: {'Authorization': 'Bearer $token'});

    // print(coursesResponse.body);
    List coursesList = jsonDecode(coursesResponse.body);
    coursesList.forEach((element) {
      courses.add(Courses(
          id: element['_id'],
          name: element['name'],
          code: element['courseId']));
    });

    courses.forEach((e) async {
      var courseAnsResponse = await http.get(
          Uri.parse(
              "https://sgp-feedback-system.herokuapp.com/api/courseFeedbackAns?id=${e.id}"),
          headers: {'Authorization': 'Bearer $token'});
      List courseAnalyticresponseList = jsonDecode(courseAnsResponse.body);
      print(courseAnalyticresponseList);
      courseAnalyticresponseList.forEach((element) {
        courseFeedbackAnalytics.add(FeedbackAnalytics(
            feedbackOf: e.name,
            que: element['questions'],
            analytic: element['analytics']));
      });
      setState(() {
        load = false;
      });
    });
  }

  void getfeedbackresponse() async {
    setState(() {
      load = true;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? id = preferences.getString('_id');

    String? token = preferences.getString('token');

    var response = await http.get(
        Uri.parse(
            "https://sgp-feedback-system.herokuapp.com/api/feedbackAns?id=$id"),
        headers: {'Authorization': 'Bearer $token'});
    List responseList = jsonDecode(response.body);

    // print(coursesList);
    responseList.forEach((element) {
      feedbackAnalyticsList.add(FeedbackAnalytics(
          feedbackOf: element['feedFor'],
          que: element['questions'],
          analytic: element['analytics']));
    });
    getcoursefeedbackresponse();
  }

  @override
  void initState() {
    getfeedbackresponse();
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
    final bool isDesktop = DeviceScreen.isDesktop(context);
    final Size size = MediaQuery.of(context).size;
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: isDesktop
          ? null
          : AppBar(
              leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.chevron_left_outlined,
                  color: Colors.black,
                  size: 28.0,
                ),
              ),
              backgroundColor: kWhite,
              title: Text(
                'Feedback List',
                style: theme.textTheme.headline6,
              ),
            ),
      body: Padding(
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
                    : feedbackAnalyticsList.isEmpty
                        ? Center(
                            child: Text(
                              'No feedbacks available',
                              style: theme.textTheme.headline6,
                            ),
                          )
                        : Container(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: List.generate(
                                    feedbackAnalyticsList.length,
                                    (index) => GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        FacultyAnalyticsTabView(
                                                          title:
                                                              feedbackAnalyticsList[
                                                                      index]
                                                                  .feedbackOf,
                                                          que:
                                                              feedbackAnalyticsList[
                                                                      index]
                                                                  .que!,
                                                          analytics:
                                                              feedbackAnalyticsList[
                                                                      index]
                                                                  .analytic!,
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
                                                          feedbackAnalyticsList[
                                                                  index]
                                                              .feedbackOf,
                                                          style: theme.textTheme
                                                              .headline6,
                                                        ),
                                                        SizedBox(
                                                          height: 16.0,
                                                        ),
                                                        Text(
                                                          feedbackAnalyticsList[
                                                                  index]
                                                              .feedbackOf,
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
                    : courseFeedbackAnalytics.isEmpty
                        ? Center(
                            child: Text(
                              'No feedbacks available',
                              style: theme.textTheme.headline6,
                            ),
                          )
                        : Container(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: List.generate(
                                    courseFeedbackAnalytics.length,
                                    (index) => GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        FacultyAnalyticsTabView(
                                                          title:
                                                              courseFeedbackAnalytics[
                                                                      index]
                                                                  .feedbackOf,
                                                          que:
                                                              courseFeedbackAnalytics[
                                                                      index]
                                                                  .que!,
                                                          analytics:
                                                              courseFeedbackAnalytics[
                                                                      index]
                                                                  .analytic!,
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
                                                          courseFeedbackAnalytics[
                                                                  index]
                                                              .feedbackOf,
                                                          style: theme.textTheme
                                                              .headline6,
                                                        ),
                                                        SizedBox(
                                                          height: 16.0,
                                                        ),
                                                        Text(
                                                          courses[index].code,
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
              ])),
            ]),
      ),
    );
  }
}
