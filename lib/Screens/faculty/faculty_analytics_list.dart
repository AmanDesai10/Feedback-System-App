import 'dart:convert';
import 'dart:developer';

import 'package:feedsys/Screens/faculty/data/analytic_data.dart';
import 'package:feedsys/Screens/faculty/faculty_analytics_scaffold.dart';
import 'package:feedsys/Widgets/feedback_card.dart';
import 'package:feedsys/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FacultyAnalyticsListScreen extends StatefulWidget {
  const FacultyAnalyticsListScreen({Key? key}) : super(key: key);

  @override
  _FacultyAnalyticsListScreenState createState() =>
      _FacultyAnalyticsListScreenState();
}

class _FacultyAnalyticsListScreenState
    extends State<FacultyAnalyticsListScreen> {
  bool load = false;
  List<FeedbackAnalytics> feedbackAnalyticsList = [];

  void getfeedbackresponse() async {
    setState(() {
      load = true;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? id = preferences.getString('_id');

    String? token = preferences.getString('token');
    var response = await http.get(
        Uri.parse(
            "https://sgp-feedback-system.herokuapp.com/api/feedbackAns?id=$id"),
        headers: {'Authorization': 'Bearer $token'});

    // log(response.body.toString());
    // log(jsonDecode(response.body).length.toString());

    //TODO: Whole analytics left
  }

  @override
  void initState() {
    getfeedbackresponse();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<FeedBack> feedbackData = [
      FeedBack(title: '19IT', description: 'Faculty feedback'),
      FeedBack(title: '20IT', description: 'Faculty feedback'),
    ];
    final Size size = MediaQuery.of(context).size;
    final ThemeData theme = Theme.of(context);
    return Scaffold(
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
        title: Text(
          'Feedback List',
          style: theme.textTheme.headline6,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              load
                  ? Center(
                      child: SizedBox(
                        height: 45,
                        width: 45,
                        child: CircularProgressIndicator(
                          color: kPrimary,
                        ),
                      ),
                    )
                  : Expanded(
                      child: Container(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: List.generate(
                                feedbackData.length,
                                (index) => GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    FacultyAnalyticsTabView(
                                                      title: feedbackData[index]
                                                          .title!,
                                                    )));
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16.0, vertical: 12.0),
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 16.0, vertical: 8.0),
                                        height: 110,
                                        width: size.width - 50,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            border: Border.all(color: kPrimary),
                                            color: kBackgroundColor),
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 32.0,
                                            ),
                                            SizedBox(width: 16.0),
                                            Expanded(
                                              child: Container(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      feedbackData[index]
                                                          .title!,
                                                      style: theme
                                                          .textTheme.headline6,
                                                    ),
                                                    SizedBox(
                                                      height: 16.0,
                                                    ),
                                                    Text(
                                                      feedbackData[index]
                                                          .description!,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )),
                          ),
                        ),
                      ),
                    ),
            ]),
      ),
    );
  }
}
