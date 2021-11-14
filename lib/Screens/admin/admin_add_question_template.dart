import 'dart:convert';
import 'dart:developer';

import 'package:feedsys/Screens/student/student_profile.dart';
import 'package:feedsys/components/textfileds.dart';
import 'package:feedsys/components/validators.dart';
import 'package:feedsys/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AdminQuestionTemplate extends StatefulWidget {
  const AdminQuestionTemplate({Key? key}) : super(key: key);

  @override
  _AdminQuestionTemplateState createState() => _AdminQuestionTemplateState();
}

class _AdminQuestionTemplateState extends State<AdminQuestionTemplate> {
  final _formKey = GlobalKey<FormState>();
  bool load = false;
  String? templateName;
  String? question;
  List<String> questionsList = [];

  bool checkdetails() {
    return questionsList.isNotEmpty && templateName != null;
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
          'New Template',
          style: theme.textTheme.headline6,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 32.0)
            .copyWith(bottom: 16.0),
        child: Column(
          children: [
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TitleText(
                            text: 'Questions',
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: GestureDetector(
                              onTap: () {
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          content: Form(
                                            key: _formKey,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                TitleText(text: 'Question'),
                                                SizedBox(
                                                  height: 12.0,
                                                ),
                                                Container(
                                                  width: double.maxFinite,
                                                  child: AuthTextField(
                                                      validator: fieldValidator,
                                                      hintText:
                                                          'Enter question',
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
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 16.0,
                                                              vertical: 10.0),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          color: kWhite),
                                                      child: Text(
                                                        'Cancel',
                                                        style: theme.textTheme
                                                            .headline6!
                                                            .copyWith(
                                                                fontSize: 14.0,
                                                                color:
                                                                    kPrimary),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 18.0,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      if (_formKey.currentState!
                                                          .validate()) {
                                                        questionsList
                                                            .add(question!);

                                                        setState(() {});
                                                        Navigator.pop(context);
                                                      }
                                                    },
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 16.0,
                                                              vertical: 10.0),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          color: kPrimary),
                                                      child: Text(
                                                        'Add',
                                                        style: theme.textTheme
                                                            .headline6!
                                                            .copyWith(
                                                                fontSize: 14.0,
                                                                color: kWhite),
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
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 24.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.0),
                                  color: kWhite,
                                ),
                                child: Text(
                                  'You Haven\'t added any question yet!!!',
                                  style: theme.textTheme.headline6!
                                      .copyWith(fontSize: 18.0),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          : Container(
                              padding: EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 16.0)
                                  .copyWith(right: 8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.0),
                                color: kWhite,
                              ),
                              child: Column(
                                children: List.generate(
                                    questionsList.length,
                                    (index) => Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 12.0),
                                          child: Row(
                                            children: [
                                              Text(
                                                '${index + 1}',
                                                style: theme
                                                    .textTheme.headline6!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                              SizedBox(
                                                width: 24.0,
                                              ),
                                              Expanded(
                                                  child: Text(
                                                      questionsList[index],
                                                      style: theme
                                                          .textTheme.bodyText1!
                                                          .copyWith(
                                                              fontSize: 18.0))),
                                              GestureDetector(
                                                  onDoubleTap: () {},
                                                  onTap: () {
                                                    questionsList
                                                        .removeAt(index);
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
            )),
            SizedBox(
              height: 16.0,
            ),
            GestureDetector(
              onTap: checkdetails()
                  ? () async {
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                      String? userid = preferences.getString('_id');

                      String? token = preferences.getString('token');
                      setState(() {
                        load = true;
                      });
                      log(jsonEncode({
                        "name": templateName,
                        "questions": questionsList,
                        "createdBy": userid
                      }));
                      var response = await http.post(
                          Uri.parse(
                              "https://sgp-feedback-system.herokuapp.com/api/addfeedbackque"),
                          headers: {
                            'Content-Type': 'application/json',
                            'Authorization': 'Bearer $token'
                          },
                          body: jsonEncode({
                            "name": templateName,
                            "questions": questionsList,
                            "createdBy": userid
                          }));
                      setState(() {
                        load = false;
                      });
                      if (response.statusCode == 200) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Question template created")));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "${jsonDecode(response.body)['message']}")));
                      }
                    }
                  : () {},
              child: Container(
                height: 50,
                // padding: EdgeInsets.symmetric(vertical: 14),
                width: size.width,
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: checkdetails() ? Color(0xff4A5CFF) : Colors.grey),
                child: load
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: kWhite,
                                strokeWidth: 3,
                              )),
                        ],
                      )
                    : Center(
                        child: Text(
                          'Create',
                          style: theme.textTheme.headline6!.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
