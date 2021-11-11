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

class _AdminAllFeedbackListState extends State<AdminAllFeedbackList> {
  List feedbacklist = [];
  bool load = false;
  List<FeedbackDetails> feedbackData = [];
  Map<String, String> questionid = {};

  void extractFeedbackData() {
    feedbackData = [];
    print('load');

    feedbacklist.forEach((element) {
      // int feedbackEndDate =
      //     DateTime.parse(element['dueTo']).difference(DateTime.now()).inDays;
      feedbackData.add(FeedbackDetails(
          name: element['name'],
          department: element['feedbackFor']['department'],
          institute: element['feedbackFor']['institute'],
          description: element['description'],
          questionTemplate: element['feedbackQuestions']['_id'],
          sem: element['feedbackFor']['sem'],
          year: element['feedbackFor']['year'],
          feedbackOf: element['feedbackOf']['userName'],
          startDate: element['dueFrom'],
          endDate: element['dueTo'],
          id: element['_id']));
    });
  }

  Future fetchList() async {
    feedbacklist = [];
    setState(() {
      load = true;
    });
    feedbacklist = await getAllFeedbackList();

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

    extractFeedbackData();
    setState(() {
      load = false;
    });
  }

  @override
  void initState() {
    fetchList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: List.generate(
                                    feedbackData.length,
                                    (index) => GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AdminFeedbackDetails(
                                                          data: feedbackData[
                                                              index],
                                                          templateName: questionid[
                                                              feedbackData[
                                                                      index]
                                                                  .questionTemplate]!,
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
                                                    BorderRadius.circular(16),
                                                border:
                                                    Border.all(color: kPrimary),
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
                                                          feedbackData[index]
                                                              .name!,
                                                          style: theme.textTheme
                                                              .headline6,
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
                                                                    'Dept: ${feedbackData[index].department}'),
                                                                Text(
                                                                    'Sem: ${feedbackData[index].sem}'),
                                                                Text(
                                                                    'Year: ${feedbackData[index].year}')
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 8.0,
                                                            ),
                                                            Text(
                                                                'Institute: ${feedbackData[index].institute}'),
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
                    ),
            ]),
      ),
    );
  }
}
