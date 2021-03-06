import 'package:feedsys/Screens/admin/admin_navigation.dart';
import 'package:feedsys/Screens/admin/admin_view.dart';
import 'package:feedsys/Screens/faculty/faculty_navigation.dart';
import 'package:feedsys/Screens/faculty/faculty_view.dart';
import 'package:feedsys/Screens/home/homeScreen.dart';
import 'package:feedsys/Screens/student/student_view.dart';
import 'package:flutter/widgets.dart';

//TODO: Add specific view for each category
Widget CategoryForwarding(String role) {
  switch (role) {
    case 'student':
      return StudentView();
    case 'faculty':
      return FacultyView();
    case 'admin':
      return AdminView();
    default:
      return HomeScreen(role: role);
  }
}
