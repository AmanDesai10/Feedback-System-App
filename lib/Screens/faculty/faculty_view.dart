import 'package:feedsys/Screens/faculty/desktop/desktop_faculty_navigation.dart';
import 'package:feedsys/Screens/faculty/faculty_navigation.dart';
import 'package:feedsys/utils/device_info.dart';
import 'package:flutter/material.dart';

class FacultyView extends StatelessWidget {
  const FacultyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = DeviceScreen.isDesktop(context);
    return isDesktop ? DesktopFacultyNavigation() : FacultyNavigation();
  }
}
