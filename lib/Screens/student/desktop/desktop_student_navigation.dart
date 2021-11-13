import 'package:feedsys/Screens/student/desktop/desktop_student_feedbackscreen.dart';
import 'package:feedsys/Screens/student/student_feedbackscreen.dart';
import 'package:feedsys/Screens/student/student_profile.dart';
import 'package:feedsys/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DesktopStudentNavigation extends StatefulWidget {
  const DesktopStudentNavigation({Key? key}) : super(key: key);

  @override
  _DesktopStudentNavigationState createState() =>
      _DesktopStudentNavigationState();
}

class _DesktopStudentNavigationState extends State<DesktopStudentNavigation> {
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
    List pages = [DesktopStudentFeedbackScreen(), ProfilePage()];

    List pageTitle = ['Feedbacks', 'Profile'];

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
              child: Drawer(
                elevation: 0,
                child: Column(
                  children: [
                    buildsideCard(theme, Icons.feedback_outlined, pageTitle[0],
                        0, isFullScreen),
                    buildsideCard(theme, Icons.person_outline, pageTitle[1], 1,
                        isFullScreen),
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
            size: isFullScreen ? 27.5 : 32,
          ),
        ),
        title: isFullScreen
            ? Text(
                title,
                style: theme.textTheme.headline6,
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
