import 'dart:convert';
import 'dart:developer';

import 'package:feedsys/Screens/admin/admin_questions_view.dart';
import 'package:feedsys/Screens/admin/data/questionTemplateDetails.dart';
import 'package:feedsys/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdminQuestionTemplateList extends StatefulWidget {
  const AdminQuestionTemplateList({Key? key}) : super(key: key);

  @override
  _AdminQuestionTemplateListState createState() =>
      _AdminQuestionTemplateListState();
}

class _AdminQuestionTemplateListState extends State<AdminQuestionTemplateList> {
  bool load = false;
  List templateList = [];
  List<QuestionTemplateDetials> templateData = [];

  Future fetchList() async {
    templateList = [];
    setState(() {
      load = true;
    });
    templateList = await getAlltemplateList();

    // var response = await http.get(
    //   Uri.parse("https://sgp-feedback-system.herokuapp.com/api/getfeedbackque"),
    // );
    // List responseList = jsonDecode(response.body);
    // responseList.forEach((element) {
    //   questionid[element['_id']] = element['name'];
    // });

    extracttemplateData();
    setState(() {
      load = false;
    });
  }

  void extracttemplateData() {
    templateData = [];
    print('load');

    templateList.forEach((element) {
      // int feedbackEndDate =
      //     DateTime.parse(element['dueTo']).difference(DateTime.now()).inDays;
      templateData.add(QuestionTemplateDetials(
          name: element['name'], question: element['questions']));
    });
  }

  @override
  void initState() {
    fetchList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Size size = MediaQuery.of(context).size;
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
          'Question Templates',
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
                                  templateData.length,
                                  (index) => GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AdminQuestionsView(
                                                          data: templateData[
                                                              index])));
                                        },
                                        child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16.0,
                                                vertical: 12.0),
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 16.0,
                                                vertical: 8.0),
                                            height: 80,
                                            width: size.width - 50,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                border:
                                                    Border.all(color: kPrimary),
                                                color: kBackgroundColor),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  templateData[index].name!,
                                                  style:
                                                      theme.textTheme.headline6,
                                                ),
                                                Icon(
                                                  Icons.chevron_right_outlined,
                                                  size: 32.0,
                                                )
                                              ],
                                            )),
                                      )),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
