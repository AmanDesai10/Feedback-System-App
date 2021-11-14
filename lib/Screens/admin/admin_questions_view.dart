import 'dart:convert';
import 'dart:developer';

import 'package:feedsys/Screens/admin/data/questionTemplateDetails.dart';
import 'package:feedsys/Screens/student/student_profile.dart';
import 'package:feedsys/components/textfileds.dart';
import 'package:feedsys/components/validators.dart';
import 'package:feedsys/constants/colors.dart';
import 'package:feedsys/utils/device_info.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

typedef BoolValue = void Function(bool);

class AdminQuestionsView extends StatefulWidget {
  final QuestionTemplateDetials data;
  final BoolValue? callback;

  const AdminQuestionsView({Key? key, required this.data, this.callback})
      : super(key: key);

  @override
  _AdminQuestionsViewState createState() => _AdminQuestionsViewState();
}

class _AdminQuestionsViewState extends State<AdminQuestionsView> {
  bool load = false;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Size size = MediaQuery.of(context).size;
    final bool isDesktop = DeviceScreen.isDesktop(context);
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
          'Questions',
          style: theme.textTheme.headline6,
        ),
        actions: isDesktop
            ? [
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      load = true;
                    });
                    SharedPreferences preferences =
                        await SharedPreferences.getInstance();
                    String? token = preferences.getString('token');
                    var response = await http.delete(
                        Uri.parse(
                            "https://sgp-feedback-system.herokuapp.com/api/feedbackQue?id=${widget.data.templateId}"),
                        headers: {'Authorization': 'Bearer $token'});
                    log(response.statusCode.toString());
                    setState(() {
                      load = false;
                    });
                    if (isDesktop) widget.callback!(true);

                    Navigator.pop(context);

                    if (response.statusCode == 200) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                              Text("${jsonDecode(response.body)['message']}")));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                              Text("${jsonDecode(response.body)['message']}")));
                    }
                  },
                  child: Container(
                    margin:
                        EdgeInsets.only(right: 32.0, top: 10.0, bottom: 10.0),
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.red),
                    child: load
                        ? Center(
                            child: SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                color: kWhite,
                              ),
                            ),
                          )
                        : Icon(Icons.delete_outline_outlined),
                  ),
                )
              ]
            : [],
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
                  ReadOnlyArgTextField(
                    readOnly: true,
                    value: widget.data.name!,
                  ),
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
                        ],
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 16.0)
                            .copyWith(right: 8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: kWhite,
                        ),
                        child: Column(
                          children: List.generate(
                              widget.data.question.length,
                              (index) => Container(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 12.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          '${index + 1}',
                                          style: theme.textTheme.headline6!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: 24.0,
                                        ),
                                        Expanded(
                                            child: Text(
                                                widget.data.question[index],
                                                style: theme
                                                    .textTheme.bodyText1!
                                                    .copyWith(fontSize: 18.0))),
                                        // GestureDetector(
                                        //     onDoubleTap: () {},
                                        //     onTap: () {
                                        //       questionsList
                                        //           .removeAt(index);
                                        //       setState(() {});
                                        //     },
                                        //     child: Icon(
                                        //       Icons.delete_outline,
                                        //       color: Colors.red,
                                        //     )),
                                        // SizedBox(
                                        //   width: 8.0,
                                        // ),
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
            if (!isDesktop) ...[
              SizedBox(
                height: 24.0,
              ),
              GestureDetector(
                onTap: () async {
                  setState(() {
                    load = true;
                  });
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  String? token = preferences.getString('token');
                  var response = await http.delete(
                      Uri.parse(
                          "https://sgp-feedback-system.herokuapp.com/api/feedbackQue?id=${widget.data.templateId}"),
                      headers: {'Authorization': 'Bearer $token'});
                  log(response.statusCode.toString());
                  setState(() {
                    load = false;
                  });
                  widget.callback!(true);

                  Navigator.pop(context);

                  if (response.statusCode == 200) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                            Text("${jsonDecode(response.body)['message']}")));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                            Text("${jsonDecode(response.body)['message']}")));
                  }
                },
                child: Container(
                  height: 50,
                  // padding: EdgeInsets.symmetric(vertical: 14),
                  width: size.width,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: Colors.red),
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
                            'Delete',
                            style: theme.textTheme.headline6!.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}
