import 'dart:developer';

import 'package:feedsys/Screens/admin/data/feedbackDetails.dart';
import 'package:feedsys/Screens/student/student_profile.dart';
import 'package:feedsys/components/textfileds.dart';
import 'package:feedsys/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminFeedbackDetails extends StatefulWidget {
  final FeedbackDetails data;
  final String templateName;
  const AdminFeedbackDetails(
      {Key? key, required this.data, required this.templateName})
      : super(key: key);

  @override
  _AdminFeedbackDetailsState createState() => _AdminFeedbackDetailsState();
}

class _AdminFeedbackDetailsState extends State<AdminFeedbackDetails> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _duedateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
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
          'New FeedBack',
          style: theme.textTheme.headline6,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 32.0)
            .copyWith(bottom: 16.0),
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
    );
  }
}
