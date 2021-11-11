import 'dart:convert';
import 'dart:developer';

import 'package:feedsys/Screens/signup/UserDetails/data/institute_details.dart';
import 'package:feedsys/Screens/signup/UserDetails/view/desktop_user_details.dart';
import 'package:feedsys/Screens/student/student_profile.dart';
import 'package:feedsys/components/textfileds.dart';
import 'package:feedsys/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:feedsys/Widgets/dropdown.dart' as d;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminAddFeedback extends StatefulWidget {
  const AdminAddFeedback({Key? key}) : super(key: key);

  @override
  _AdminAddFeedbackState createState() => _AdminAddFeedbackState();
}

class _AdminAddFeedbackState extends State<AdminAddFeedback> {
  final InstituteData _instituteData = InstituteData();
  bool load = false;
  List<String> departmentList = [];
  String? feedbackName;
  String? feedbackDescription;
  List<String> facultyList = [];
  List<String> questionList = [];
  Map<String, String> facultyid = {};
  Map<String, String> questionid = {};
  String? question;
  String? faculty;
  String? userCollege;
  String? dept;
  int? year;
  int? sem;
  String? userid, token;
  List<int> yearList = [2016, 2017, 2018, 2019, 2020, 2021];
  List<int> semList = [1, 2, 3, 4, 5, 6, 7, 8];

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _duedateController = TextEditingController();

  DateTime startDate = DateTime.now();
  DateTime dueDate = DateTime.now();
  void getFacultyList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    userid = preferences.getString('_id');
    token = preferences.getString('token');
    var response = await http.get(
        Uri.parse("https://sgp-feedback-system.herokuapp.com/api/faculty"),
        headers: {'Authorization': 'Bearer $token'});

    List responseList = jsonDecode(response.body);
    responseList.forEach((element) {
      facultyList.add(element['userName']);
      facultyid[element['userName']] = element['id'];
    });
    setState(() {});
  }

  void getFeedbackQuestion() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString('token');
    var response = await http.get(
        Uri.parse(
          "https://sgp-feedback-system.herokuapp.com/api/getfeedbackque",
        ),
        headers: {'Authorization': 'Bearer $token'});

    List responseList = jsonDecode(response.body);
    responseList.forEach((element) {
      questionList.add(element['name']);
      questionid[element['name']] = element['_id'];
    });
    setState(() {});
  }

  Future<void> _selectDate(BuildContext context, {bool due = false}) async {
    DateTime initdate = due ? startDate : DateTime.now();
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: initdate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: initdate,
        lastDate: initdate.add(const Duration(days: 60)));
    if (picked != null) {
      setState(() {
        due ? dueDate = picked : startDate = picked;

        due
            ? _duedateController.text = DateFormat('dd-MM-yyyy').format(dueDate)
            : _dateController.text = DateFormat('dd-MM-yyyy').format(startDate);
      });
    }
  }

  bool checkdetails() {
    return feedbackName != null &&
        feedbackDescription != null &&
        faculty != null &&
        userCollege != null &&
        dept != null &&
        year != null &&
        sem != null &&
        _dateController.text.isNotEmpty &&
        _duedateController.text.isNotEmpty;
  }

  @override
  void initState() {
    getFacultyList();
    getFeedbackQuestion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Size size = MediaQuery.of(context).size;
    if (userCollege != null) {
      departmentList = _instituteData.department[userCollege] ?? [];
    }
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
          'New FeedBack',
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
                        hintText: 'Enter feedback name',
                        onChanged: (value) {
                          feedbackName = value;
                        }),
                    SizedBox(
                      height: 24.0,
                    ),
                    TitleText(text: 'Description'),
                    SizedBox(
                      height: 16.0,
                    ),
                    AuthTextField(
                        maxLines: 5,
                        hintText: 'Enter description here',
                        onChanged: (value) {
                          feedbackDescription = value;
                        }),
                    SizedBox(
                      height: 24.0,
                    ),
                    TitleText(text: 'Faculty'),
                    SizedBox(
                      height: 16.0,
                    ),
                    Container(
                      width: size.width,
                      padding:
                          EdgeInsets.symmetric(horizontal: 14.0, vertical: 4.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(color: Colors.grey)),
                      child: d.DropdownButtonHideUnderline(
                        child: d.DropdownButton<String>(
                          menuMaxHeight: 175,
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(12),
                          ),
                          dropdownColor: kBackgroundColor,
                          focusColor: Colors.white,
                          value: faculty,
                          icon: Icon(Icons.expand_more_outlined),
                          style: theme.textTheme.headline6!
                              .copyWith(fontSize: 16.0),
                          iconEnabledColor: Colors.black,
                          items: facultyList
                              .map<d.DropdownMenuItem<String>>((String value) {
                            return d.DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value.toString(),
                                style: theme.textTheme.headline6!
                                    .copyWith(fontSize: 16.0),
                              ),
                            );
                          }).toList(),
                          hint: Text(
                            "Select Faculty",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          onChanged: (value) {
                            setState(() {
                              faculty = value!;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 24.0,
                    ),
                    TitleText(text: 'Institute'),
                    SizedBox(
                      height: 16.0,
                    ),
                    Container(
                      width: size.width,
                      padding:
                          EdgeInsets.symmetric(horizontal: 14.0, vertical: 4.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(color: Colors.grey)),
                      child: d.DropdownButtonHideUnderline(
                        child: d.DropdownButton<String>(
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(12),
                          ),
                          dropdownColor: kBackgroundColor,
                          focusColor: kBackgroundColor,
                          value: userCollege,
                          icon: Icon(Icons.expand_more_outlined),
                          style: theme.textTheme.headline6!
                              .copyWith(fontSize: 16.0),
                          iconEnabledColor: Colors.black,
                          items: _instituteData.collegeList
                              .map<d.DropdownMenuItem<String>>((String value) {
                            return d.DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: theme.textTheme.headline6!
                                    .copyWith(fontSize: 16.0),
                              ),
                            );
                          }).toList(),
                          hint: Text(
                            "Select college",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          onChanged: (value) {
                            setState(() {
                              userCollege = value!;
                              dept = null;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 24.0,
                    ),
                    TitleText(text: 'Department'),
                    SizedBox(
                      height: 16.0,
                    ),
                    Container(
                      width: size.width,
                      padding:
                          EdgeInsets.symmetric(horizontal: 14.0, vertical: 4.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(color: Colors.grey)),
                      child: d.DropdownButtonHideUnderline(
                        child: d.DropdownButton<String>(
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(12),
                          ),
                          dropdownColor: kBackgroundColor,
                          focusColor: Colors.white,
                          value: dept,
                          icon: Icon(Icons.expand_more_outlined),
                          style: theme.textTheme.headline6!
                              .copyWith(fontSize: 16.0),
                          iconEnabledColor: Colors.black,
                          items: departmentList
                              .map<d.DropdownMenuItem<String>>((String value) {
                            return d.DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: theme.textTheme.headline6!
                                    .copyWith(fontSize: 16.0),
                              ),
                            );
                          }).toList(),
                          hint: Text(
                            "Select department",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          onChanged: (value) {
                            setState(() {
                              dept = value!;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 24.0,
                    ),
                    TitleText(text: 'Template'),
                    SizedBox(
                      height: 16.0,
                    ),
                    Container(
                      width: size.width,
                      padding:
                          EdgeInsets.symmetric(horizontal: 14.0, vertical: 4.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(color: Colors.grey)),
                      child: d.DropdownButtonHideUnderline(
                        child: d.DropdownButton<String>(
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(12),
                          ),
                          dropdownColor: kBackgroundColor,
                          focusColor: Colors.white,
                          value: question,
                          icon: Icon(Icons.expand_more_outlined),
                          style: theme.textTheme.headline6!
                              .copyWith(fontSize: 16.0),
                          iconEnabledColor: Colors.black,
                          items: questionList
                              .map<d.DropdownMenuItem<String>>((String value) {
                            return d.DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: theme.textTheme.headline6!
                                    .copyWith(fontSize: 16.0),
                              ),
                            );
                          }).toList(),
                          hint: Text(
                            "Select question List",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          onChanged: (value) {
                            setState(() {
                              question = value!;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 24.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TitleText(
                              text: 'Year',
                            ),
                            SizedBox(
                              height: 14.0,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 14.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.0),
                                  border: Border.all(color: Colors.grey)),
                              child: d.DropdownButtonHideUnderline(
                                child: d.DropdownButton<int>(
                                  menuMaxHeight: 175,
                                  borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(12),
                                  ),
                                  dropdownColor: kBackgroundColor,
                                  focusColor: Colors.white,
                                  value: year,
                                  icon: Icon(Icons.expand_more_outlined),
                                  style: theme.textTheme.headline6!
                                      .copyWith(fontSize: 16.0),
                                  iconEnabledColor: Colors.black,
                                  items: yearList.map<d.DropdownMenuItem<int>>(
                                      (int value) {
                                    return d.DropdownMenuItem<int>(
                                      value: value,
                                      child: Text(
                                        value.toString(),
                                        style: theme.textTheme.headline6!
                                            .copyWith(fontSize: 16.0),
                                      ),
                                    );
                                  }).toList(),
                                  hint: Text(
                                    "Select Year",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      year = value!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TitleText(
                              text: 'Semester',
                            ),
                            SizedBox(
                              height: 14.0,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 14.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.0),
                                  border: Border.all(color: Colors.grey)),
                              child: d.DropdownButtonHideUnderline(
                                child: d.DropdownButton<int>(
                                  menuMaxHeight: 175,
                                  borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(12),
                                  ),
                                  dropdownColor: kBackgroundColor,
                                  focusColor: Colors.white,
                                  value: sem,
                                  icon: Icon(Icons.expand_more_outlined),
                                  style: theme.textTheme.headline6!
                                      .copyWith(fontSize: 16.0),
                                  iconEnabledColor: Colors.black,
                                  items: semList.map<d.DropdownMenuItem<int>>(
                                      (int value) {
                                    return d.DropdownMenuItem<int>(
                                      value: value,
                                      child: Text(
                                        value.toString(),
                                        style: theme.textTheme.headline6!
                                            .copyWith(fontSize: 16.0),
                                      ),
                                    );
                                  }).toList(),
                                  hint: Text(
                                    "Select Sem",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      sem = value!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
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
                      hintText: 'Select start date',
                      controller: _dateController,
                      suffixIcon: GestureDetector(
                        onTap: () async {
                          await _selectDate(context);
                        },
                        child: Icon(
                          Icons.calendar_today,
                          color: Colors.black,
                        ),
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
                      hintText: 'Select due date',
                      controller: _duedateController,
                      suffixIcon: GestureDetector(
                        onTap: () async {
                          await _selectDate(context, due: true);
                        },
                        child: Icon(
                          Icons.calendar_today,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            GestureDetector(
              onTap: () async {
                log(jsonEncode({
                  'name': feedbackName,
                  'description': feedbackDescription,
                  'feedbackFor': {
                    'sem': sem,
                    'year': year,
                    'institute': userCollege,
                    'department': dept
                  },
                  'feedbackOf': facultyid[faculty],
                  'createdBy': userid,
                  'feedbackQuestions': questionid[question],
                  'dueFrom':
                      startDate.add(Duration(days: 1)).toUtc().toString(),
                  'dueTo': dueDate.add(Duration(days: 1)).toUtc().toString()
                }));
                setState(() {
                  load = true;
                });
                var response = await http.post(
                    Uri.parse(
                        "https://sgp-feedback-system.herokuapp.com/api/newFeedback"),
                    headers: {
                      'Content-Type': 'application/json',
                      'Authorization': 'Bearer $token'
                    },
                    body: jsonEncode({
                      'name': feedbackName,
                      'description': feedbackDescription,
                      'feedbackFor': {
                        'sem': sem,
                        'year': year,
                        'institute': userCollege,
                        'department': dept
                      },
                      'feedbackOf': facultyid[faculty],
                      'createdBy': userid,
                      'feedbackQuestions': questionid[question],
                      'dueFrom':
                          startDate.add(Duration(days: 1)).toUtc().toString(),
                      'dueTo': dueDate.add(Duration(days: 1)).toUtc().toString()
                    }));
                log(response.statusCode.toString());
                setState(() {
                  load = false;
                });
                if (response.statusCode == 200) {
                  Navigator.pop(context);
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
