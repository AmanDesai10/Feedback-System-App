import 'package:feedsys/Screens/student/student_navigation.dart';
import 'package:flutter/material.dart';

import 'Screens/welcome.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Feedback System',
      theme: ThemeData(fontFamily: 'Montserrat'),
      home: WelcomeScreen(),
    );
  }
}
