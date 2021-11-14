import 'dart:convert';
import 'dart:developer';

import 'package:feedsys/constants/colors.dart';
import 'package:feedsys/utils/device_info.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

typedef BoolValue = void Function(bool);

class StudentFeedbackQuestionScreen extends StatefulWidget {
  StudentFeedbackQuestionScreen(
      {Key? key,
      required this.questions,
      required this.id,
      required this.callback})
      : super(key: key);
  BoolValue callback;

  final List questions;
  final String? id;

  @override
  _StudentFeedbackQuestionScreenState createState() =>
      _StudentFeedbackQuestionScreenState();
}

class _StudentFeedbackQuestionScreenState
    extends State<StudentFeedbackQuestionScreen> {
  final Map<String, List<int>> a = {};
  final Map<String, int> selectedOption = {};
  bool load = false;

  @override
  void initState() {
    widget.questions.forEach((element) {
      print(element);
      a[element] = [1, 2, 3, 4, 5];
    });

    widget.questions.forEach((element) {
      selectedOption[element] = 0;
    });
    setState(() {});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log(selectedOption.values.toList().toString());
    final bool isDesktop = DeviceScreen.isDesktop(context);
    final ThemeData theme = Theme.of(context);
    final Size size = MediaQuery.of(context).size;
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
          'Give Feedback',
          style: theme.textTheme.headline6,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.questions.isEmpty
                ? Center(
                    child: SizedBox(
                      height: 60,
                      width: 60,
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Expanded(
                    child: Container(
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            ...List.generate(
                                widget.questions.length,
                                (index) => Padding(
                                      padding: isDesktop
                                          ? EdgeInsets.symmetric(
                                              horizontal: 32.0, vertical: 12.0)
                                          : const EdgeInsets.all(8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                            color: kPrimary.withOpacity(0.1)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 16.0,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 24.0),
                                              child: Text(
                                                widget.questions[index],
                                                style: theme
                                                    .textTheme.headline6!
                                                    .copyWith(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                            ),
                                            RadioListTile(
                                              value: a[widget.questions[index]]!
                                                  .toList()[0],
                                              groupValue: selectedOption[
                                                  widget.questions[index]],
                                              onChanged: (int? value) {
                                                print(value);
                                                setState(() {
                                                  selectedOption[widget
                                                          .questions[index]] =
                                                      value!;
                                                });
                                              },
                                              title: Text('Completely Agree'),
                                            ),
                                            RadioListTile(
                                                value:
                                                    a[widget.questions[index]]!
                                                        .toList()[1],
                                                groupValue: selectedOption[
                                                    widget.questions[index]],
                                                onChanged: (int? value) {
                                                  print(value);
                                                  setState(() {
                                                    selectedOption[widget
                                                            .questions[index]] =
                                                        value!;
                                                  });
                                                },
                                                title: Text('Agree')),
                                            RadioListTile(
                                              value: a[widget.questions[index]]!
                                                  .toList()[2],
                                              groupValue: selectedOption[
                                                  widget.questions[index]],
                                              onChanged: (int? value) {
                                                print(value);

                                                setState(() {
                                                  selectedOption[widget
                                                          .questions[index]] =
                                                      value!;
                                                });
                                              },
                                              title: Text('Neutral'),
                                            ),
                                            RadioListTile(
                                              value: a[widget.questions[index]]!
                                                  .toList()[3],
                                              groupValue: selectedOption[
                                                  widget.questions[index]],
                                              onChanged: (int? value) {
                                                print(value);

                                                setState(() {
                                                  selectedOption[widget
                                                          .questions[index]] =
                                                      value!;
                                                });
                                              },
                                              title: Text('Disagree'),
                                            ),
                                            RadioListTile(
                                              value: a[widget.questions[index]]!
                                                  .toList()[4],
                                              groupValue: selectedOption[
                                                  widget.questions[index]],
                                              onChanged: (int? value) {
                                                print(value);

                                                setState(() {
                                                  selectedOption[widget
                                                          .questions[index]] =
                                                      value!;
                                                });
                                              },
                                              title:
                                                  Text('Completely Disagree'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ))
                          ],
                        ),
                      ),
                    ),
                  ),
            SizedBox(
              height: 24.0,
            ),
            GestureDetector(
              onTap: selectedOption.containsValue(0)
                  ? null
                  : () async {
                      setState(() {
                        load = true;
                      });
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                      String? userid = preferences.getString('_id');
                      String? token = preferences.getString('token');

                      log(jsonEncode({
                        'feedbackId': widget.id,
                        'userId': userid,
                        'ans': selectedOption.values.toList()
                      }));
                      var response = await http.post(
                          Uri.parse(
                              "https://sgp-feedback-system.herokuapp.com/api/feedbackAns"),
                          headers: {
                            'Content-Type': 'application/json',
                            'Authorization': 'Bearer $token'
                          },
                          body: jsonEncode({
                            'feedbackId': widget.id,
                            'userId': userid,
                            'ans': selectedOption.values.toList()
                          }));
                      setState(() {
                        load = true;
                      });
                      log(response.body.toString());
                      if (response.statusCode == 200) {
                        widget.callback(true);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "${jsonDecode(response.body)['message']}")));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "${jsonDecode(response.body)['message']}")));
                      }
                    },
              child: Container(
                height: 50,
                width: isDesktop ? 450 : null,
                // padding: EdgeInsets.symmetric(vertical: 14),
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: selectedOption.containsValue(0)
                        ? Colors.grey
                        : Color(0xff4A5CFF)),
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
                          'Submit',
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
