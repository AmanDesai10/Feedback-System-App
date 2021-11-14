import 'dart:convert';
import 'dart:developer';

import 'package:feedsys/Screens/admin/admin_questions_view.dart';
import 'package:feedsys/Screens/admin/data/questionTemplateDetails.dart';
import 'package:feedsys/Screens/student/student_profile.dart';
import 'package:feedsys/components/textfileds.dart';
import 'package:feedsys/components/validators.dart';
import 'package:feedsys/constants/colors.dart';
import 'package:feedsys/utils/device_info.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AdminQuestionTemplateList extends StatefulWidget {
  const AdminQuestionTemplateList({Key? key}) : super(key: key);

  @override
  _AdminQuestionTemplateListState createState() =>
      _AdminQuestionTemplateListState();
}

class _AdminQuestionTemplateListState extends State<AdminQuestionTemplateList> {
  bool load = false;
  List templateList = [];
  bool reload = false;
  bool dialogreload = false;
  List<QuestionTemplateDetials> templateData = [];

  Future fetchList() async {
    templateList = [];
    reload = false;
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
          name: element['name'],
          question: element['questions'],
          templateId: element['_id']));
    });
  }

  @override
  void initState() {
    fetchList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (reload) fetchList();
    final ThemeData theme = Theme.of(context);
    final bool isDesktop = DeviceScreen.isDesktop(context);
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: isDesktop
          ? null
          : AppBar(
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
          mainAxisAlignment:
              isDesktop ? MainAxisAlignment.start : MainAxisAlignment.center,
          children: [
            isDesktop
                ? Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'All Question Templates',
                          style: theme.textTheme.headline6,
                        ),
                        FloatingActionButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  final _formKey = GlobalKey<FormState>();
                                  bool dialogload = false;
                                  String? templateName;
                                  String? question;
                                  List<String> questionsList = [];

                                  bool checkdetails() {
                                    return questionsList.isNotEmpty &&
                                        templateName != null;
                                  }

                                  return StatefulBuilder(
                                      builder: (context, setState) {
                                    return AlertDialog(
                                      title: Text(
                                        'Add Question Template',
                                        style: theme.textTheme.headline6,
                                      ),
                                      titlePadding: EdgeInsets.symmetric(
                                          horizontal: 50, vertical: 16.0),
                                      backgroundColor: kBackgroundColor,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 50, vertical: 16.0),
                                      insetPadding: EdgeInsets.symmetric(
                                          horizontal: 100.0, vertical: 32.0),
                                      content: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            TitleText(text: 'Name'),
                                            SizedBox(
                                              height: 16.0,
                                            ),
                                            AuthTextField(
                                                hintText: 'Enter template name',
                                                onChanged: (value) {
                                                  templateName = value;
                                                }),
                                            SizedBox(
                                              height: 24.0,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    TitleText(
                                                      text: 'Questions',
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 8.0),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          showDialog(
                                                              barrierDismissible:
                                                                  false,
                                                              context: context,
                                                              builder:
                                                                  (context) =>
                                                                      AlertDialog(
                                                                        insetPadding:
                                                                            EdgeInsets.symmetric(horizontal: size.width * 0.25),
                                                                        content:
                                                                            Form(
                                                                          key:
                                                                              _formKey,
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            children: [
                                                                              TitleText(text: 'Question'),
                                                                              SizedBox(
                                                                                height: 12.0,
                                                                              ),
                                                                              Container(
                                                                                width: double.maxFinite,
                                                                                child: AuthTextField(
                                                                                    validator: fieldValidator,
                                                                                    hintText: 'Enter question',
                                                                                    onChanged: (value) {
                                                                                      question = value;
                                                                                      setState(() {});
                                                                                    }),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        actions: [
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(14.0),
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                                              children: [
                                                                                GestureDetector(
                                                                                  onTap: () {
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                  child: Container(
                                                                                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                                                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: kWhite),
                                                                                    child: Text(
                                                                                      'Cancel',
                                                                                      style: theme.textTheme.headline6!.copyWith(fontSize: 14.0, color: kPrimary),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 18.0,
                                                                                ),
                                                                                GestureDetector(
                                                                                  onTap: () {
                                                                                    if (_formKey.currentState!.validate()) {
                                                                                      questionsList.add(question!);

                                                                                      setState(() {});
                                                                                      Navigator.pop(context);
                                                                                    }
                                                                                  },
                                                                                  child: Container(
                                                                                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                                                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: kPrimary),
                                                                                    child: Text(
                                                                                      'Add',
                                                                                      style: theme.textTheme.headline6!.copyWith(fontSize: 14.0, color: kWhite),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ));
                                                        },
                                                        child: Icon(
                                                          Icons.add,
                                                          color: kPrimary,
                                                          size: 32.0,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 16.0,
                                                ),
                                                questionsList.isEmpty
                                                    ? Center(
                                                        child: Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      16.0,
                                                                  vertical:
                                                                      24.0),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        16.0),
                                                            color: kWhite,
                                                          ),
                                                          child: Text(
                                                            'You Haven\'t added any question yet!!!',
                                                            style: theme
                                                                .textTheme
                                                                .headline6!
                                                                .copyWith(
                                                                    fontSize:
                                                                        18.0),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                      )
                                                    : Container(
                                                        padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        16.0,
                                                                    vertical:
                                                                        16.0)
                                                            .copyWith(
                                                                right: 8.0),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      16.0),
                                                          color: kWhite,
                                                        ),
                                                        child: Column(
                                                          children:
                                                              List.generate(
                                                                  questionsList
                                                                      .length,
                                                                  (index) =>
                                                                      Container(
                                                                        padding:
                                                                            EdgeInsets.symmetric(vertical: 12.0),
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Text(
                                                                              '${index + 1}',
                                                                              style: theme.textTheme.headline6!.copyWith(fontWeight: FontWeight.bold),
                                                                            ),
                                                                            SizedBox(
                                                                              width: 24.0,
                                                                            ),
                                                                            Expanded(child: Text(questionsList[index], style: theme.textTheme.bodyText1!.copyWith(fontSize: 18.0))),
                                                                            GestureDetector(
                                                                                onDoubleTap: () {},
                                                                                onTap: () {
                                                                                  questionsList.removeAt(index);
                                                                                  setState(() {});
                                                                                },
                                                                                child: Icon(
                                                                                  Icons.delete_outline,
                                                                                  color: Colors.red,
                                                                                )),
                                                                            SizedBox(
                                                                              width: 8.0,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      )),
                                                        ),
                                                      ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        Padding(
                                          padding: const EdgeInsets.all(14.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 16.0,
                                                      vertical: 10.0),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      color: kWhite),
                                                  child: Text(
                                                    'Cancel',
                                                    style: theme
                                                        .textTheme.headline6!
                                                        .copyWith(
                                                            fontSize: 14.0,
                                                            color: kPrimary),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 18.0,
                                              ),
                                              GestureDetector(
                                                onTap: () async {
                                                  if (checkdetails()) {
                                                    SharedPreferences
                                                        preferences =
                                                        await SharedPreferences
                                                            .getInstance();
                                                    String? userid = preferences
                                                        .getString('_id');

                                                    String? token = preferences
                                                        .getString('token');
                                                    setState(() {
                                                      dialogload = true;
                                                    });
                                                    log(jsonEncode({
                                                      "name": templateName,
                                                      "questions":
                                                          questionsList,
                                                      "createdBy": userid
                                                    }));
                                                    var response = await http.post(
                                                        Uri.parse(
                                                            "https://sgp-feedback-system.herokuapp.com/api/addfeedbackque"),
                                                        headers: {
                                                          'Content-Type':
                                                              'application/json',
                                                          'Authorization':
                                                              'Bearer $token'
                                                        },
                                                        body: jsonEncode({
                                                          "name": templateName,
                                                          "questions":
                                                              questionsList,
                                                          "createdBy": userid
                                                        }));
                                                    setState(() {
                                                      dialogload = false;
                                                    });
                                                    if (response.statusCode ==
                                                        200) {
                                                      dialogreload = true;
                                                      Navigator.pop(context);
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(SnackBar(
                                                              content: Text(
                                                                  "Question template created")));
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(SnackBar(
                                                              content: Text(
                                                                  "${jsonDecode(response.body)['message']}")));
                                                    }
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                            content: Text(
                                                                "Please add all the  fields")));
                                                  }
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 16.0,
                                                      vertical: 10.0),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      color: kPrimary),
                                                  child: dialogload
                                                      ? Center(
                                                          child: SizedBox(
                                                              height: 14,
                                                              width: 14,
                                                              child:
                                                                  CircularProgressIndicator(
                                                                color: kWhite,
                                                                strokeWidth: 3,
                                                              )),
                                                        )
                                                      : Text(
                                                          'Create',
                                                          style: theme.textTheme
                                                              .headline6!
                                                              .copyWith(
                                                                  fontSize:
                                                                      14.0,
                                                                  color:
                                                                      kWhite),
                                                        ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    );
                                  });
                                }).then((value) {
                              if (dialogreload) {
                                reload = true;
                                dialogreload = false;
                                setState(() {});
                              }
                            });
                          },
                          child: Icon(Icons.add),
                          backgroundColor: kPrimary,
                        )
                      ],
                    ),
                  )
                : SizedBox(),
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
                                                        data:
                                                            templateData[index],
                                                        callback: (value) {
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
