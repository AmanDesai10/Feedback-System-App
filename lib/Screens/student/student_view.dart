import 'package:feedsys/Screens/signup/UserDetails/view/desktop_user_details.dart';
import 'package:feedsys/Screens/signup/UserDetails/view/user_detail_screen.dart';
import 'package:feedsys/Screens/student/desktop/desktop_student_navigation.dart';
import 'package:feedsys/Screens/student/student_navigation.dart';
import 'package:feedsys/utils/device_info.dart';
import 'package:flutter/material.dart';

class StudentView extends StatelessWidget {
  const StudentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = DeviceScreen.isDesktop(context);
    return isDesktop ? DesktopStudentNavigation() : StudentNavigation();
  }
}
