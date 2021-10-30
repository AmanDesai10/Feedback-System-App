import 'package:feedsys/Screens/student/student_feedbackscreen.dart';
import 'package:feedsys/Screens/student/student_homescreen.dart';
import 'package:feedsys/Screens/student/student_profile.dart';
import 'package:feedsys/constants/colors.dart';
import 'package:feedsys/faculty/faculty_homescreen.dart';
import 'package:flutter/material.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';

class FacultyNavigation extends StatefulWidget {
  const FacultyNavigation({Key? key}) : super(key: key);

  @override
  _FacultyNavigationState createState() => _FacultyNavigationState();
}

class _FacultyNavigationState extends State<FacultyNavigation> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData theme = Theme.of(context);

    List pages = [FacultyHomeScreen(), StudentFeedbackScreen(), ProfilePage()];
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
