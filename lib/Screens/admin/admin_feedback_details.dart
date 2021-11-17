import 'dart:convert';
import 'dart:developer';

import 'package:feedsys/Screens/admin/admin_all_feedback_list.dart';
import 'package:feedsys/Screens/admin/data/feedbackDetails.dart';
import 'package:feedsys/Screens/student/student_profile.dart';
import 'package:feedsys/components/textfileds.dart';
import 'package:feedsys/constants/colors.dart';
import 'package:feedsys/utils/device_info.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

typedef BoolValue = void Function(bool);

class AdminFeedbackDetails extends StatefulWidget {
  final FeedbackDetails data;
  final String templateName;
  final BoolValue callback;
  final bool isCourse;
  const AdminFeedbackDetails(
      {Key? key,
      required this.data,
      required this.templateName,
      required this.callback,
      required this.isCourse})
      : super(key: key);

  @override
  _AdminFeedbackDetailsState createState() => _AdminFeedbackDetailsState();
}

class _AdminFeedbackDetailsState extends State<AdminFeedbackDetails> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _duedateController = TextEditingController();
  bool load = false;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDesktop = DeviceScreen.isDesktop(context);
    final Size size = MediaQuery.of(context).size;

    String? feedbackName = widget.data.name;
    String? feedbackDescription = widget.data.description;
    String? feedbackOf = widget.data.feedbackOf;
    String? institute = widget.data.institute;
    String? dept = widget.data.department;
    String? template = widget.templateName;
    int? year = widget.data.year;
    int? sem = widget.data.sem;
    _dateController.text =
        DateFormat('dd-MM-yyyy').format(DateTime.parse(widget.data.startDate!));
    _duedateController.text =
        DateFormat('dd-MM-yyyy').format(DateTime.parse(widget.data.endDate!));
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
          'FeedBack Detail',
          style: theme.textTheme.headline6,
        ),
        actions: isDesktop
            ? [
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      load = true;
                    });
                    String url = widget.isCourse
                        ? "https://sgp-feedback-system.herokuapp.com/api/courseFeedback?id=${widget.data.id}"
                        : "https://sgp-feedback-system.herokuapp.com/api/feedback?id=${widget.data.id}";
                    SharedPreferences preferences =
                        await SharedPreferences.getInstance();
                    String? token = preferences.getString('token');
                    var response = await http.delete(Uri.parse(url),
                        headers: {'Authorization': 'Bearer $token'});
                    log(response.statusCode.toString());
                    setState(() {
                      load = false;
                    });
                    widget.callback(true);
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
                      value: feedbackName!,
                    ),
                    SizedBox(
                      height: 24.0,
                    ),
                    TitleText(text: 'Description'),
                    SizedBox(
                      height: 16.0,
                    ),
                    ReadOnlyArgTextField(
                      readOnly: true,
                      value: feedbackDescription!,
                      maxLines: 5,
                    ),
                    SizedBox(
                      height: 24.0,
                    ),
                    TitleText(text: 'FeedBack Of'),
                    SizedBox(
                      height: 16.0,
                    ),
                    ReadOnlyArgTextField(
                      readOnly: true,
                      value: feedbackOf!,
                    ),
                    SizedBox(
                      height: 24.0,
                    ),
                    TitleText(text: 'Institute'),
                    SizedBox(
                      height: 16.0,
                    ),
                    ReadOnlyArgTextField(
                      readOnly: true,
                      value: institute!,
                    ),
                    SizedBox(
                      height: 24.0,
                    ),
                    TitleText(text: 'Department'),
                    SizedBox(
                      height: 16.0,
                    ),
                    ReadOnlyArgTextField(
                      readOnly: true,
                      value: dept!,
                    ),
                    SizedBox(
                      height: 24.0,
                    ),
                    TitleText(text: 'Template'),
                    SizedBox(
                      height: 16.0,
                    ),
                    ReadOnlyArgTextField(
                      readOnly: true,
                      value: template,
                    ),
                    SizedBox(
                      height: 24.0,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TitleText(
                                text: 'Year',
                              ),
                              SizedBox(
                                height: 14.0,
                              ),
                              ReadOnlyArgTextField(
                                readOnly: true,
                                value: year.toString(),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 32.0,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TitleText(
                                text: 'Semester',
                              ),
                              SizedBox(
                                height: 14.0,
                              ),
                              ReadOnlyArgTextField(
                                readOnly: true,
                                value: sem.toString(),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 24.0,
                    ),
                    TitleText(text: 'Active Date'),
                    SizedBox(
                      height: 16.0,
                    ),
                    ReadOnlyArgTextField(
                      readOnly: true,
                      controller: _dateController,
                      suffixIcon: Icon(
                        Icons.calendar_today,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 24.0,
                    ),
                    TitleText(text: 'Due Date'),
                    SizedBox(
                      height: 16.0,
                    ),
                    ReadOnlyArgTextField(
                      readOnly: true,
                      controller: _duedateController,
                      suffixIcon: Icon(
                        Icons.calendar_today,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (!isDesktop) ...[
              SizedBox(
                height: 24.0,
              ),
              GestureDetector(
                onTap: () async {
                  String url = widget.isCourse
                      ? "https://sgp-feedback-system.herokuapp.com/api/courseFeedback?id=${widget.data.id}"
                      : "https://sgp-feedback-system.herokuapp.com/api/feedback?id=${widget.data.id}";
                  setState(() {
                    load = true;
                  });
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  String? token = preferences.getString('token');
                  var response = await http.delete(Uri.parse(url),
                      headers: {'Authorization': 'Bearer $token'});
                  log(response.statusCode.toString());
                  setState(() {
                    load = false;
                  });
                  widget.callback(true);
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
