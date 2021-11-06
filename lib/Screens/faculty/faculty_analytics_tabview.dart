import 'package:feedsys/Screens/faculty/faculty_analytics_view.dart';
import 'package:feedsys/Screens/student/student_feedbackscreen.dart';
import 'package:feedsys/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FacultyAnalyticsTabView extends StatefulWidget {
  const FacultyAnalyticsTabView({Key? key, required this.title})
      : super(key: key);
  final String title;
  @override
  _FacultyAnalyticsTabViewState createState() =>
      _FacultyAnalyticsTabViewState();
}

class _FacultyAnalyticsTabViewState extends State<FacultyAnalyticsTabView> {
  @override
  Widget build(BuildContext context) {
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
          backgroundColor: kWhite,
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TabBar(
                  labelColor: kPrimary,
                  unselectedLabelColor: Colors.blueGrey[600],
                  tabs: [
                    Tab(
                      text: "Your Analytics",
                    ),
                    Tab(
                      text: "Course Analytics",
                    )
                  ],
                  indicatorColor: kPrimary,
                  indicatorPadding: EdgeInsets.symmetric(horizontal: 40),
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(children: [
          FacultyAnalyticsScreen(
            title: widget.title,
          ),
          Icon(Icons.ac_unit)
        ]),
      ),
    );
  }
}
