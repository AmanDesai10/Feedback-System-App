import 'package:feedsys/Screens/admin/admin_add_feedback.dart';
import 'package:feedsys/Screens/admin/admin_all_feedback_list.dart';
import 'package:feedsys/Screens/admin/admin_homescreen.dart';
import 'package:feedsys/Screens/admin/admin_question_list.dart';
import 'package:feedsys/Screens/admin/desktop/desktop_admin_all_feedback_list.dart';
import 'package:feedsys/Screens/faculty/faculty_analytics_list.dart';
import 'package:feedsys/Screens/faculty/faculty_homescreen.dart';
import 'package:feedsys/Screens/student/student_feedbackscreen.dart';
import 'package:feedsys/Screens/student/student_homescreen.dart';
import 'package:feedsys/Screens/student/student_profile.dart';
import 'package:feedsys/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';

class DesktopFacultyNavigation extends StatefulWidget {
  const DesktopFacultyNavigation({Key? key}) : super(key: key);

  @override
  _DesktopFacultyNavigationState createState() =>
      _DesktopFacultyNavigationState();
}

class _DesktopFacultyNavigationState extends State<DesktopFacultyNavigation> {
  int selectedIndex = 0;
  String? username = 'Guest';

  void getUserDetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('name');
    });
  }

  @override
  void initState() {
    getUserDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData theme = Theme.of(context);
    bool isFullScreen = size.width > 1125;

    List pages = [FacultyAnalyticsListScreen(), ProfilePage()];
    List pageTitle = ['Analytics', 'Profile'];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome, $username',
          style: theme.textTheme.headline6!.copyWith(color: kWhite),
        ),
        backgroundColor: kPrimary,
      ),
      body: Container(
        color: kWhite,
        child: Row(
          children: [
            SizedBox(
              width: 200,
              child: Drawer(
                elevation: 0,
                child: Column(
                  children: [
                    buildsideCard(theme, Icons.analytics_outlined, pageTitle[0],
                        0, isFullScreen),
                    buildsideCard(theme, Icons.person_outline_outlined,
                        pageTitle[1], 1, isFullScreen),
                  ],
                ),
              ),
            ),
            const VerticalDivider(
              width: 1,
              thickness: 1,
              indent: 0,
            ),
            Expanded(child: pages[selectedIndex]),
          ],
        ),
      ),
    );
  }

  Card buildsideCard(
      ThemeData theme, IconData icon, String title, int i, bool isFullScreen) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 2),
      child: ListTile(
        contentPadding: EdgeInsets.all(8.0),
        tileColor: kWhite,
        selected: i == selectedIndex,
        selectedTileColor: kPrimary.withOpacity(0.15),
        leading: Transform.translate(
          offset: const Offset(6, 0),
          child: Icon(
            icon,
            color: Colors.black,
            size: isFullScreen ? 22 : 32,
          ),
        ),
        title: isFullScreen
            ? Text(
                title,
                style: theme.textTheme.headline6!.copyWith(fontSize: 16.0),
              )
            : null,
        onTap: () {
          setState(() {
            selectedIndex = i;
          });
        },
      ),
    );
  }
}
