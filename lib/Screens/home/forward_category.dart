import 'package:feedsys/Screens/home/homeScreen.dart';
import 'package:feedsys/Screens/student/student_navigation.dart';
import 'package:flutter/widgets.dart';

//TODO: Add specific view for each category
Widget CategoryForwarding(String role) {
  switch (role) {
    case 'student':
      return StudentNavigation();
    case 'faculty':
      return HomeScreen(role: role);
    default:
      return HomeScreen(role: role);
  }
}
