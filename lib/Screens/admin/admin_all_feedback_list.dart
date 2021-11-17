import 'dart:convert';

import 'package:feedsys/Screens/admin/admin_feedback_details.dart';
import 'package:feedsys/Screens/admin/data/feedbackDetails.dart';
import 'package:feedsys/Screens/student/data/feedback_data.dart';
import 'package:feedsys/Screens/student/data/feedback_list.dart';
import 'package:feedsys/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AdminAllFeedbackList extends StatefulWidget {
  const AdminAllFeedbackList({Key? key}) : super(key: key);

  @override
  _AdminAllFeedbackListState createState() => _AdminAllFeedbackListState();
}

class _AdminAllFeedbackListState extends State<AdminAllFeedbackList>
    with SingleTickerProviderStateMixin {
  List coursefeedbacklist = [];
  List facultyfeedbacklist = [];
  bool load = false;
  List<FeedbackDetails> coursefeedbackData = [];
  List<FeedbackDetails> facultyfeedbackData = [];
  Map<String, String> questionid = {};
  bool reload = false;
  late TabController _tabController;

  List<Widget> list = [
    Tab(
        icon: Text(
      'Faculty',
      style: TextStyle(fontSize: 18.0),
    )),
    Tab(
        icon: Text(
      'Course',
      style: TextStyle(fontSize: 18.0),
    )),
  ];

  void extractfacultyFeedbackData() {
    facultyfeedbackData = [];
    coursefeedbackData = [];
    print('load');

    facultyfeedbacklist.forEach((element) {
      // int feedbackEndDate =
      //     DateTime.parse(element['dueTo']).difference(DateTime.now()).inDays;
      facultyfeedbackData.add(FeedbackDetails(
          name: element['name'],
          department: element['feedbackFor']['department'],
          institute: element['feedbackFor']['institute'],
          description: element['description'],
          questionTemplateId: element['feedbackQuestions']['_id'],
          questionTemplate: element['feedbackQuestions']['name'],
          sem: element['feedbackFor']['sem'],
          year: element['feedbackFor']['year'],
          feedbackOf: element['feedbackOf']['userName'],
          startDate: element['dueFrom'],
          endDate: element['dueTo'],
          id: element['_id']));
    });
    coursefeedbacklist.forEach((element) {
      coursefeedbackData.add(FeedbackDetails(
          name: element['name'],
          department: element['feedbackFor']['department'],
          institute: element['feedbackFor']['institute'],
          description: element['description'],
          questionTemplateId: element['feedbackQuestions']['_id'],
          questionTemplate: element['feedbackQuestions']['name'],
          sem: element['feedbackFor']['sem'],
          year: element['feedbackFor']['year'],
          feedbackOf: element['feedbackOf']['name'],
          startDate: element['dueFrom'],
          endDate: element['dueTo'],
          createdBy: element['createdBy']['userName'],
          id: element['_id']));
    });
  }

  Future fetchList() async {
    facultyfeedbacklist = [];
    coursefeedbacklist = [];
    setState(() {
      load = true;
    });
    facultyfeedbacklist = await getAllFacultyFeedbackList();
    coursefeedbacklist = await getAllCourseFeedbackList();

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    var response = await http.get(
        Uri.parse(
            "https://sgp-feedback-system.herokuapp.com/api/getfeedbackque"),
        headers: {'Authorization': 'Bearer $token'});
    List responseList = jsonDecode(response.body);
    responseList.forEach((element) {
      questionid[element['_id']] = element['name'];
    });

    extractfacultyFeedbackData();
    setState(() {
      load = false;
      reload = false;
    });
  }

  @override
  void initState() {
    fetchList();
    _tabController = TabController(length: list.length, vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (reload) fetchList();

    final Size size = MediaQuery.of(context).size;
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: kBackgroundColor,
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
        backgroundColor: kBackgroundColor,
        title: Text(
          'All Feedbacks',
          style: theme.textTheme.headline6,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!load) ...[
                TabBar(
                  tabs: list,
                  controller: _tabController,
                  labelColor: kPrimary,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: kPrimary,
                ),
                SizedBox(
                  height: 16.0,
                ),
              ],
              Expanded(
                  child: Container(
                child: TabBarView(
                  controller: _tabController,
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
                        : Container(
                            child: FutureBuilder(builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              return RefreshIndicator(
                                color: kPrimary,
                                onRefresh: () async {
                                  return fetchList();
                                },
                                child: SingleChildScrollView(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: List.generate(
                                        facultyfeedbackData.length,
                                        (index) => GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            AdminFeedbackDetails(
                                                              data:
                                                                  facultyfeedbackData[
                                                                      index],
                                                              templateName: questionid[
                                                                  facultyfeedbackData[
                                                                          index]
                                                                      .questionTemplateId]!,
                                                              isCourse: false,
                                                              callback:
                                                                  (value) {
                                                                reload = value;
                                                                setState(() {});
                                                              },
                                                            )));
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16.0,
                                                    vertical: 12.0),
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 16.0,
                                                    vertical: 8.0),
                                                height: 110,
                                                width: size.width - 50,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                    border: Border.all(
                                                        color: kPrimary),
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
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              facultyfeedbackData[
                                                                      index]
                                                                  .name!,
                                                              style: theme
                                                                  .textTheme
                                                                  .headline6,
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            SizedBox(
                                                              height: 16.0,
                                                            ),
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                        'Dept: ${facultyfeedbackData[index].department}'),
                                                                    Text(
                                                                        'Sem: ${facultyfeedbackData[index].sem}'),
                                                                    Text(
                                                                        'Year: ${facultyfeedbackData[index].year}')
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: 8.0,
                                                                ),
                                                                Text(
                                                                    'Institute: ${facultyfeedbackData[index].institute}'),
                                                              ],
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
                              );
                            }),
                          ),
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
                        : Container(
                            child: FutureBuilder(builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              return RefreshIndicator(
                                color: kPrimary,
                                onRefresh: () async {
                                  return fetchList();
                                },
                                child: SingleChildScrollView(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: List.generate(
                                        coursefeedbackData.length,
                                        (index) => GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            AdminFeedbackDetails(
                                                              data:
                                                                  coursefeedbackData[
                                                                      index],
                                                              templateName: questionid[
                                                                  coursefeedbackData[
                                                                          index]
                                                                      .questionTemplateId]!,
                                                              isCourse: true,
                                                              callback:
                                                                  (value) {
                                                                reload = value;
                                                                setState(() {});
                                                              },
                                                            )));
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16.0,
                                                    vertical: 12.0),
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 16.0,
                                                    vertical: 8.0),
                                                height: 110,
                                                width: size.width - 50,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                    border: Border.all(
                                                        color: kPrimary),
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
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              coursefeedbackData[
                                                                      index]
                                                                  .name!,
                                                              style: theme
                                                                  .textTheme
                                                                  .headline6,
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            SizedBox(
                                                              height: 16.0,
                                                            ),
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                        'Dept: ${coursefeedbackData[index].department}'),
                                                                    Text(
                                                                        'Sem: ${coursefeedbackData[index].sem}'),
                                                                    Text(
                                                                        'Year: ${coursefeedbackData[index].year}')
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: 8.0,
                                                                ),
                                                                Text(
                                                                    'Institute: ${coursefeedbackData[index].institute}'),
                                                              ],
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
                              );
                            }),
                          ),
                  ],
                ),
              )),
            ]),
      ),
    );
  }
}
