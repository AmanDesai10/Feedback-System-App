import 'dart:convert';
import 'dart:developer';

import 'package:feedsys/Screens/admin/admin_feedback_details.dart';
import 'package:feedsys/Screens/admin/data/feedbackDetails.dart';
import 'package:feedsys/Screens/signup/UserDetails/data/institute_details.dart';
import 'package:feedsys/Screens/student/data/feedback_list.dart';
import 'package:feedsys/Screens/student/desktop/desktop_student_feedbackscreen.dart';
import 'package:feedsys/Screens/student/student_profile.dart';
import 'package:feedsys/components/textfileds.dart';
import 'package:feedsys/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:feedsys/Widgets/dropdown.dart' as d;
import 'package:intl/intl.dart';

class DesktopAdminAllFeedbackList extends StatefulWidget {
  const DesktopAdminAllFeedbackList({Key? key}) : super(key: key);

  @override
  _DesktopAdminAllFeedbackListState createState() =>
      _DesktopAdminAllFeedbackListState();
}

class _DesktopAdminAllFeedbackListState
    extends State<DesktopAdminAllFeedbackList>
    with SingleTickerProviderStateMixin {
  List facultyfeedbacklist = [];
  List coursefeedbacklist = [];
  bool load = false;
  bool dialogreload = false;
  bool reload = false;
  List<FeedbackDetails> facultyfeedbackData = [];
  List<FeedbackDetails> coursefeedbackData = [];
  Map<String, String> questionid = {};
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
          createdBy: element['createdBy']['userName'],
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

  bool dialogload = false;
  String? feedbackName;
  String? feedbackDescription;
  List<String> facultyList = [];
  List<String> courseList = [];
  List<String> questionList = [];
  Map<String, String> facultyid = {};
  Map<String, String> courseid = {};
  Map<String, String> dialogquestionid = {};

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
    return Container(
      color: kBackgroundColor,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0).copyWith(top: 4.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'All Feedbacks',
                    style: theme.textTheme.headline6,
                  ),
                  FloatingActionButton(
                    onPressed: () async {
                      await showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            final InstituteData _instituteData =
                                InstituteData();

                            void getFacultyList() async {
                              SharedPreferences preferences =
                                  await SharedPreferences.getInstance();
                              String? userid = preferences.getString('_id');
                              String? token = preferences.getString('token');
                              var response = await http.get(
                                  Uri.parse(
                                      "https://sgp-feedback-system.herokuapp.com/api/faculty"),
                                  headers: {'Authorization': 'Bearer $token'});

                              List responseList = jsonDecode(response.body);
                              responseList.forEach((element) {
                                facultyList.add(element['userName']);
                                facultyid[element['userName']] = element['id'];
                              });
                              setState(() {});
                            }

                            void getCourseList() async {
                              SharedPreferences preferences =
                                  await SharedPreferences.getInstance();
                              String? userid = preferences.getString('_id');
                              String? token = preferences.getString('token');
                              var response = await http.get(
                                  Uri.parse(
                                      "https://sgp-feedback-system.herokuapp.com/api/courses"),
                                  headers: {'Authorization': 'Bearer $token'});

                              List responseList = jsonDecode(response.body);
                              log(responseList.toString());
                              responseList.forEach((element) {
                                courseList.add(element['name']);
                                courseid[element['name']] = element['_id'];
                              });
                              setState(() {});
                            }

                            void getFeedbackQuestion() async {
                              SharedPreferences preferences =
                                  await SharedPreferences.getInstance();
                              String? userid = preferences.getString('_id');
                              String? token = preferences.getString('token');
                              var response = await http.get(
                                  Uri.parse(
                                    "https://sgp-feedback-system.herokuapp.com/api/getfeedbackque",
                                  ),
                                  headers: {'Authorization': 'Bearer $token'});

                              List responseList = jsonDecode(response.body);
                              responseList.forEach((element) {
                                questionList.add(element['name']);
                                dialogquestionid[element['name']] =
                                    element['_id'];
                              });
                              setState(() {});
                            }

                            List<int> yearList = [
                              2016,
                              2017,
                              2018,
                              2019,
                              2020,
                              2021
                            ];
                            List<int> semList = [1, 2, 3, 4, 5, 6, 7, 8];

                            final TextEditingController _dateController =
                                TextEditingController();
                            final TextEditingController _duedateController =
                                TextEditingController();

                            DateTime startDate = DateTime.now();
                            DateTime dueDate = DateTime.now();

                            Future<void> _selectDate(BuildContext context,
                                {bool due = false}) async {
                              DateTime initdate =
                                  due ? startDate : DateTime.now();
                              final DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: initdate,
                                  initialDatePickerMode: DatePickerMode.day,
                                  firstDate: initdate,
                                  lastDate:
                                      initdate.add(const Duration(days: 60)));
                              if (picked != null) {
                                setState(() {
                                  due ? dueDate = picked : startDate = picked;

                                  due
                                      ? _duedateController.text =
                                          DateFormat('dd-MM-yyyy')
                                              .format(dueDate)
                                      : _dateController.text =
                                          DateFormat('dd-MM-yyyy')
                                              .format(startDate);
                                });
                              }
                            }

                            getFacultyList();
                            getFeedbackQuestion();
                            getCourseList();
                            String? question;
                            String? faculty;
                            String? userCollege;
                            String? dept;
                            int? year;
                            List<String> departmentList = [];
                            int? sem;

                            return StatefulBuilder(
                                builder: (context, setState) {
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

                              if (userCollege != null) {
                                departmentList =
                                    _instituteData.department[userCollege] ??
                                        [];
                              }
                              return AlertDialog(
                                title: Text(
                                  'Add Feedback',
                                  style: theme.textTheme.headline6,
                                ),
                                titlePadding: EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 16.0),
                                backgroundColor: kBackgroundColor,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 16.0),
                                insetPadding: EdgeInsets.symmetric(
                                    horizontal: 100.0, vertical: 32.0),
                                content: Container(
                                  width: size.width * 0.3,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TitleText(text: 'Name'),
                                        SizedBox(
                                          height: 16.0,
                                        ),
                                        AuthTextField(
                                            hintText: 'Enter feedback name',
                                            onChanged: (value) {
                                              feedbackName = value;
                                              setState(() {});
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
                                        _tabController.index == 1
                                            ? TitleText(text: 'Course')
                                            : TitleText(text: 'Faculty'),
                                        SizedBox(
                                          height: 16.0,
                                        ),
                                        _tabController.index == 1
                                            ? Container(
                                                width: size.width,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 14.0,
                                                    vertical: 4.0),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16.0),
                                                    border: Border.all(
                                                        color: Colors.grey)),
                                                child: d
                                                    .DropdownButtonHideUnderline(
                                                  child:
                                                      d.DropdownButton<String>(
                                                    menuMaxHeight: 175,
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                      bottom:
                                                          Radius.circular(12),
                                                    ),
                                                    dropdownColor:
                                                        kBackgroundColor,
                                                    focusColor: Colors.white,
                                                    value: faculty,
                                                    icon: Icon(Icons
                                                        .expand_more_outlined),
                                                    style: theme
                                                        .textTheme.headline6!
                                                        .copyWith(
                                                            fontSize: 16.0),
                                                    iconEnabledColor:
                                                        Colors.black,
                                                    items: courseList.map<
                                                            d.DropdownMenuItem<
                                                                String>>(
                                                        (String value) {
                                                      return d.DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(
                                                          value.toString(),
                                                          style: theme.textTheme
                                                              .headline6!
                                                              .copyWith(
                                                                  fontSize:
                                                                      16.0),
                                                        ),
                                                      );
                                                    }).toList(),
                                                    hint: Text(
                                                      "Select Course",
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        faculty = value!;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                width: size.width,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 14.0,
                                                    vertical: 4.0),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16.0),
                                                    border: Border.all(
                                                        color: Colors.grey)),
                                                child: d
                                                    .DropdownButtonHideUnderline(
                                                  child:
                                                      d.DropdownButton<String>(
                                                    menuMaxHeight: 175,
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                      bottom:
                                                          Radius.circular(12),
                                                    ),
                                                    dropdownColor:
                                                        kBackgroundColor,
                                                    focusColor: Colors.white,
                                                    value: faculty,
                                                    icon: Icon(Icons
                                                        .expand_more_outlined),
                                                    style: theme
                                                        .textTheme.headline6!
                                                        .copyWith(
                                                            fontSize: 16.0),
                                                    iconEnabledColor:
                                                        Colors.black,
                                                    items: facultyList.map<
                                                            d.DropdownMenuItem<
                                                                String>>(
                                                        (String value) {
                                                      return d.DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(
                                                          value.toString(),
                                                          style: theme.textTheme
                                                              .headline6!
                                                              .copyWith(
                                                                  fontSize:
                                                                      16.0),
                                                        ),
                                                      );
                                                    }).toList(),
                                                    hint: Text(
                                                      "Select Faculty",
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500),
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
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 14.0, vertical: 4.0),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                              border: Border.all(
                                                  color: Colors.grey)),
                                          child: d.DropdownButtonHideUnderline(
                                            child: d.DropdownButton<String>(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                bottom: Radius.circular(12),
                                              ),
                                              dropdownColor: kBackgroundColor,
                                              focusColor: kBackgroundColor,
                                              value: userCollege,
                                              icon: Icon(
                                                  Icons.expand_more_outlined),
                                              style: theme.textTheme.headline6!
                                                  .copyWith(fontSize: 16.0),
                                              iconEnabledColor: Colors.black,
                                              items: _instituteData.collegeList
                                                  .map<
                                                          d.DropdownMenuItem<
                                                              String>>(
                                                      (String value) {
                                                return d.DropdownMenuItem<
                                                    String>(
                                                  value: value,
                                                  child: Text(
                                                    value,
                                                    style: theme
                                                        .textTheme.headline6!
                                                        .copyWith(
                                                            fontSize: 16.0),
                                                  ),
                                                );
                                              }).toList(),
                                              hint: Text(
                                                "Select college",
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500),
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
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 14.0, vertical: 4.0),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                              border: Border.all(
                                                  color: Colors.grey)),
                                          child: d.DropdownButtonHideUnderline(
                                            child: d.DropdownButton<String>(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                bottom: Radius.circular(12),
                                              ),
                                              dropdownColor: kBackgroundColor,
                                              focusColor: Colors.white,
                                              value: dept,
                                              icon: Icon(
                                                  Icons.expand_more_outlined),
                                              style: theme.textTheme.headline6!
                                                  .copyWith(fontSize: 16.0),
                                              iconEnabledColor: Colors.black,
                                              items: departmentList.map<
                                                  d.DropdownMenuItem<
                                                      String>>((String value) {
                                                return d.DropdownMenuItem<
                                                    String>(
                                                  value: value,
                                                  child: Text(
                                                    value,
                                                    style: theme
                                                        .textTheme.headline6!
                                                        .copyWith(
                                                            fontSize: 16.0),
                                                  ),
                                                );
                                              }).toList(),
                                              hint: Text(
                                                "Select department",
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500),
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
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 14.0, vertical: 4.0),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                              border: Border.all(
                                                  color: Colors.grey)),
                                          child: d.DropdownButtonHideUnderline(
                                            child: d.DropdownButton<String>(
                                              menuMaxHeight: 175,
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                bottom: Radius.circular(12),
                                              ),
                                              dropdownColor: kBackgroundColor,
                                              focusColor: Colors.white,
                                              value: question,
                                              icon: Icon(
                                                  Icons.expand_more_outlined),
                                              style: theme.textTheme.headline6!
                                                  .copyWith(fontSize: 16.0),
                                              iconEnabledColor: Colors.black,
                                              items: questionList.map<
                                                  d.DropdownMenuItem<
                                                      String>>((String value) {
                                                return d.DropdownMenuItem<
                                                    String>(
                                                  value: value,
                                                  child: Text(
                                                    value,
                                                    style: theme
                                                        .textTheme.headline6!
                                                        .copyWith(
                                                            fontSize: 16.0),
                                                  ),
                                                );
                                              }).toList(),
                                              hint: Text(
                                                "Select question List",
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                TitleText(
                                                  text: 'Year',
                                                ),
                                                SizedBox(
                                                  height: 14.0,
                                                ),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 14.0,
                                                      vertical: 4.0),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16.0),
                                                      border: Border.all(
                                                          color: Colors.grey)),
                                                  child: d
                                                      .DropdownButtonHideUnderline(
                                                    child:
                                                        d.DropdownButton<int>(
                                                      menuMaxHeight: 175,
                                                      borderRadius:
                                                          BorderRadius.vertical(
                                                        bottom:
                                                            Radius.circular(12),
                                                      ),
                                                      dropdownColor:
                                                          kBackgroundColor,
                                                      focusColor: Colors.white,
                                                      value: year,
                                                      icon: Icon(Icons
                                                          .expand_more_outlined),
                                                      style: theme
                                                          .textTheme.headline6!
                                                          .copyWith(
                                                              fontSize: 16.0),
                                                      iconEnabledColor:
                                                          Colors.black,
                                                      items: yearList.map<
                                                          d.DropdownMenuItem<
                                                              int>>((int
                                                          value) {
                                                        return d
                                                            .DropdownMenuItem<
                                                                int>(
                                                          value: value,
                                                          child: Text(
                                                            value.toString(),
                                                            style: theme
                                                                .textTheme
                                                                .headline6!
                                                                .copyWith(
                                                                    fontSize:
                                                                        16.0),
                                                          ),
                                                        );
                                                      }).toList(),
                                                      hint: Text(
                                                        "Select Year",
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                TitleText(
                                                  text: 'Semester',
                                                ),
                                                SizedBox(
                                                  height: 14.0,
                                                ),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 14.0,
                                                      vertical: 4.0),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16.0),
                                                      border: Border.all(
                                                          color: Colors.grey)),
                                                  child: d
                                                      .DropdownButtonHideUnderline(
                                                    child:
                                                        d.DropdownButton<int>(
                                                      menuMaxHeight: 175,
                                                      borderRadius:
                                                          BorderRadius.vertical(
                                                        bottom:
                                                            Radius.circular(12),
                                                      ),
                                                      dropdownColor:
                                                          kBackgroundColor,
                                                      focusColor: Colors.white,
                                                      value: sem,
                                                      icon: Icon(Icons
                                                          .expand_more_outlined),
                                                      style: theme
                                                          .textTheme.headline6!
                                                          .copyWith(
                                                              fontSize: 16.0),
                                                      iconEnabledColor:
                                                          Colors.black,
                                                      items: semList.map<
                                                          d.DropdownMenuItem<
                                                              int>>((int
                                                          value) {
                                                        return d
                                                            .DropdownMenuItem<
                                                                int>(
                                                          value: value,
                                                          child: Text(
                                                            value.toString(),
                                                            style: theme
                                                                .textTheme
                                                                .headline6!
                                                                .copyWith(
                                                                    fontSize:
                                                                        16.0),
                                                          ),
                                                        );
                                                      }).toList(),
                                                      hint: Text(
                                                        "Select Sem",
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
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
                                              await _selectDate(context,
                                                  due: true);
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
                                actions: [
                                  Padding(
                                    padding: const EdgeInsets.all(14.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            facultyList = [];
                                            questionList = [];
                                            facultyid.clear();
                                            dialogquestionid.clear();
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16.0,
                                                vertical: 10.0),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                color: kWhite),
                                            child: Text(
                                              'Cancel',
                                              style: theme.textTheme.headline6!
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
                                              setState(() {
                                                dialogload = true;
                                              });
                                              SharedPreferences preferences =
                                                  await SharedPreferences
                                                      .getInstance();
                                              String? userid =
                                                  preferences.getString('_id');
                                              String? token = preferences
                                                  .getString('token');

                                              print(jsonEncode({
                                                'name': feedbackName,
                                                'description':
                                                    feedbackDescription,
                                                'feedbackFor': {
                                                  'sem': sem,
                                                  'year': year,
                                                  'institute': userCollege,
                                                  'department': dept
                                                },
                                                'feedbackOf':
                                                    facultyid[faculty],
                                                'createdBy': userid,
                                                'feedbackQuestions':
                                                    dialogquestionid[question],
                                                'dueFrom': startDate
                                                    .add(Duration(days: 1))
                                                    .toUtc()
                                                    .toString(),
                                                'dueTo': dueDate
                                                    .add(Duration(days: 1))
                                                    .toUtc()
                                                    .toString()
                                              }));
                                              var response = await http.post(
                                                  Uri.parse(
                                                      "https://sgp-feedback-system.herokuapp.com/api/newFeedback"),
                                                  headers: {
                                                    'Content-Type':
                                                        'application/json',
                                                    'Authorization':
                                                        'Bearer $token'
                                                  },
                                                  body: jsonEncode({
                                                    'name': feedbackName,
                                                    'description':
                                                        feedbackDescription,
                                                    'feedbackFor': {
                                                      'sem': sem,
                                                      'year': year,
                                                      'institute': userCollege,
                                                      'department': dept
                                                    },
                                                    'feedbackOf':
                                                        facultyid[faculty],
                                                    'createdBy': userid,
                                                    'feedbackQuestions':
                                                        dialogquestionid[
                                                            question],
                                                    'dueFrom': startDate
                                                        .add(Duration(days: 1))
                                                        .toUtc()
                                                        .toString(),
                                                    'dueTo': dueDate
                                                        .add(Duration(days: 1))
                                                        .toUtc()
                                                        .toString()
                                                  }));
                                              log(response.statusCode
                                                  .toString());
                                              log(response.body);
                                              setState(() {
                                                dialogload = false;
                                              });
                                              if (response.statusCode == 200) {
                                                dialogreload = true;
                                                Navigator.pop(context);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            "${jsonDecode(response.body)['message']}")));
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            "${jsonDecode(response.body)['message']}")));
                                              }
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          "Please fill all fields")));
                                            }
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16.0,
                                                vertical: 10.0),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
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
                                                    style: theme
                                                        .textTheme.headline6!
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
                              );
                            });
                          }).then((value) {
                        if (dialogreload) {
                          setState(() {
                            reload = true;
                            dialogreload = false;
                          });
                        }
                      });
                    },
                    child: Icon(Icons.add),
                    backgroundColor: kPrimary,
                  )
                ],
              ),
            ),
            TabBar(
              tabs: list,
              controller: _tabController,
              labelColor: kPrimary,
              unselectedLabelColor: Colors.grey,
              indicatorColor: kPrimary,
            ),
            SizedBox(
              height: 18.0,
            ),
            Container(
              color: kBackgroundColor,
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: FeedbackTableText(text: 'Name'),
                  ),
                  Expanded(
                    flex: 3,
                    child: FeedbackTableText(text: 'Description'),
                  ),
                  Expanded(
                    flex: 2,
                    child: FeedbackTableText(text: 'Question\nTemplate'),
                  ),
                  Expanded(
                    flex: 2,
                    child: FeedbackTableText(text: 'Created By'),
                  ),
                  Expanded(
                    flex: 2,
                    child: FeedbackTableText(text: 'Due\nFrom'),
                  ),
                  Expanded(
                    flex: 2,
                    child: FeedbackTableText(text: 'Due\nTo'),
                  ),
                  Expanded(
                    flex: 1,
                    child: FeedbackTableText(
                      text: 'Delete',
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(
                    width: 16.0,
                  )
                ],
              ),
            ),
            Divider(
              color: Colors.black,
              thickness: 2.0,
            ),
            Expanded(
              child: Container(
                child: TabBarView(controller: _tabController, children: [
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
                      : facultyfeedbackData.isEmpty
                          ? Center(
                              child: Text(
                                'No pending feedbacks!!',
                                style: theme.textTheme.headline6,
                              ),
                            )
                          : Container(
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: List.generate(
                                      facultyfeedbackData.length,
                                      (index) => Column(
                                            children: [
                                              MouseRegion(
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                AdminFeedbackDetails(
                                                                  data:
                                                                      facultyfeedbackData[
                                                                          index],
                                                                  templateName:
                                                                      questionid[
                                                                          facultyfeedbackData[index]
                                                                              .questionTemplateId]!,
                                                                ))).then(
                                                        (value) {
                                                      setState(() {
                                                        reload = true;
                                                      });
                                                    });
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 20.0,
                                                            horizontal: 12.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Expanded(
                                                            flex: 2,
                                                            child: FeedbackTableText(
                                                                text: facultyfeedbackData[
                                                                        index]
                                                                    .name!)),
                                                        SizedBox(
                                                          width: 8.0,
                                                        ),
                                                        Expanded(
                                                          flex: 3,
                                                          child: Text(
                                                            facultyfeedbackData[
                                                                    index]
                                                                .description!,
                                                            style: theme
                                                                .textTheme
                                                                .headline6!
                                                                .copyWith(
                                                                    fontSize:
                                                                        16.0),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 1,
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 8.0,
                                                        ),
                                                        Expanded(
                                                          flex: 2,
                                                          child: FeedbackTableText(
                                                              text: facultyfeedbackData[
                                                                      index]
                                                                  .questionTemplate!),
                                                        ),
                                                        SizedBox(
                                                          width: 8.0,
                                                        ),
                                                        Expanded(
                                                          flex: 2,
                                                          child: FeedbackTableText(
                                                              text: facultyfeedbackData[
                                                                      index]
                                                                  .createdBy!),
                                                        ),
                                                        SizedBox(
                                                          width: 8.0,
                                                        ),
                                                        Expanded(
                                                            flex: 2,
                                                            child: FeedbackTableText(
                                                                text: DateFormat(
                                                                        'dd/MM/yyyy')
                                                                    .format(DateTime.parse(
                                                                        facultyfeedbackData[index]
                                                                            .startDate!))
                                                                    .toString())),
                                                        SizedBox(
                                                          width: 8.0,
                                                        ),
                                                        Expanded(
                                                            flex: 2,
                                                            child: FeedbackTableText(
                                                                text: DateFormat(
                                                                        'dd/MM/yyyy')
                                                                    .format(DateTime.parse(
                                                                        facultyfeedbackData[index]
                                                                            .endDate!))
                                                                    .toString())),
                                                        SizedBox(
                                                          width: 8.0,
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Center(
                                                            child: Icon(
                                                              Icons
                                                                  .delete_outline_outlined,
                                                              color: Colors.red,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Divider(
                                                color: Colors.grey,
                                                thickness: 1.5,
                                              )
                                            ],
                                          )),
                                ),
                              ),
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
                      : coursefeedbackData.isEmpty
                          ? Center(
                              child: Text(
                                'No pending feedbacks!!',
                                style: theme.textTheme.headline6,
                              ),
                            )
                          : Container(
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: List.generate(
                                      coursefeedbackData.length,
                                      (index) => Column(
                                            children: [
                                              MouseRegion(
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                AdminFeedbackDetails(
                                                                  data:
                                                                      coursefeedbackData[
                                                                          index],
                                                                  templateName:
                                                                      questionid[
                                                                          coursefeedbackData[index]
                                                                              .questionTemplateId]!,
                                                                )));
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 20.0,
                                                            horizontal: 12.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Expanded(
                                                            flex: 2,
                                                            child: FeedbackTableText(
                                                                text: coursefeedbackData[
                                                                        index]
                                                                    .name!)),
                                                        SizedBox(
                                                          width: 8.0,
                                                        ),
                                                        Expanded(
                                                          flex: 3,
                                                          child: Text(
                                                            coursefeedbackData[
                                                                    index]
                                                                .description!,
                                                            style: theme
                                                                .textTheme
                                                                .headline6!
                                                                .copyWith(
                                                                    fontSize:
                                                                        16.0),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 1,
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 8.0,
                                                        ),
                                                        Expanded(
                                                          flex: 2,
                                                          child: FeedbackTableText(
                                                              text: coursefeedbackData[
                                                                      index]
                                                                  .questionTemplate!),
                                                        ),
                                                        SizedBox(
                                                          width: 8.0,
                                                        ),
                                                        Expanded(
                                                          flex: 2,
                                                          child: FeedbackTableText(
                                                              text: coursefeedbackData[
                                                                      index]
                                                                  .createdBy!),
                                                        ),
                                                        SizedBox(
                                                          width: 8.0,
                                                        ),
                                                        Expanded(
                                                            flex: 2,
                                                            child: FeedbackTableText(
                                                                text: DateFormat(
                                                                        'dd/MM/yyyy')
                                                                    .format(DateTime.parse(
                                                                        coursefeedbackData[index]
                                                                            .startDate!))
                                                                    .toString())),
                                                        SizedBox(
                                                          width: 8.0,
                                                        ),
                                                        Expanded(
                                                            flex: 2,
                                                            child: FeedbackTableText(
                                                                text: DateFormat(
                                                                        'dd/MM/yyyy')
                                                                    .format(DateTime.parse(
                                                                        coursefeedbackData[index]
                                                                            .endDate!))
                                                                    .toString())),
                                                        SizedBox(
                                                          width: 8.0,
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Center(
                                                            child: Icon(
                                                              Icons
                                                                  .delete_outline_outlined,
                                                              color: Colors.red,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Divider(
                                                color: Colors.grey,
                                                thickness: 1.5,
                                              )
                                            ],
                                          )),
                                ),
                              ),
                            ),
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
