import 'dart:convert';
import 'dart:developer';

import 'package:feedsys/Screens/student/data/feedback_list.dart';
import 'package:feedsys/Screens/student/student_feedbackscreen.dart';
import 'package:feedsys/Screens/student/student_homescreen.dart';
import 'package:feedsys/Screens/student/student_profile.dart';
import 'package:feedsys/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';
import 'package:http/http.dart' as http;

class StudentNavigation extends StatefulWidget {
  const StudentNavigation({Key? key}) : super(key: key);

  @override
  _StudentNavigationState createState() => _StudentNavigationState();
}

class _StudentNavigationState extends State<StudentNavigation> {
  int selectedIndex = 0;
  List feedbackList = [];

  void getFeedbacks() async {
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
  }

  @override
  void initState() {
    getFeedbacks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData theme = Theme.of(context);

    List pages = [
      StudentHomeScreen(),
      StudentFeedbackScreen(
        feedbackResponseList: feedbackList,
      ),
      ProfilePage()
    ];
    List pageTitle = ['Home', 'Feedbacks', 'Profile'];
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(pageTitle[selectedIndex]),
          backgroundColor: kPrimary,
        ),
        bottomNavigationBar: SlidingClippedNavBar(
          backgroundColor: kBackgroundColor,
          onButtonPressed: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          iconSize: 30,
          activeColor: kPrimary,
          selectedIndex: selectedIndex,
          barItems: [
            BarItem(
              icon: Icons.home,
              title: 'Home',
            ),
            BarItem(
              icon: Icons.feedback_outlined,
              title: 'Feedback',
            ),
            BarItem(
              icon: Icons.person_outline,
              title: 'Profile',
            ),
          ],
        ),
        body: pages[selectedIndex]);
  }
}
