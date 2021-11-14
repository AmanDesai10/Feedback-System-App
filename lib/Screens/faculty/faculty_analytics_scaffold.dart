import 'dart:developer';

import 'package:feedsys/Screens/faculty/faculty_analytics_view.dart';
import 'package:feedsys/Screens/student/student_feedbackscreen.dart';
import 'package:feedsys/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FacultyAnalyticsTabView extends StatefulWidget {
  const FacultyAnalyticsTabView(
      {Key? key,
      required this.title,
      required this.que,
      required this.analytics})
      : super(key: key);
  final String title;
  final List analytics;
  final List que;
  @override
  _FacultyAnalyticsTabViewState createState() =>
      _FacultyAnalyticsTabViewState();
}

class _FacultyAnalyticsTabViewState extends State<FacultyAnalyticsTabView> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData theme = Theme.of(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: kWhite,
        appBar: AppBar(
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
          title: Text(
            widget.title,
            style: theme.textTheme.headline6,
          ),
          backgroundColor: kWhite,
        ),
        body: FacultyAnalyticsScreen(
          title: widget.title,
          que: widget.que,
          analytics: widget.analytics,
        ),
      ),
    );
  }
}
