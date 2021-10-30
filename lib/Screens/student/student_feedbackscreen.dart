import 'package:feedsys/Screens/student/data/feedback_data.dart';
import 'package:feedsys/Widgets/feedback_card.dart';
import 'package:feedsys/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:feedsys/Widgets/dropdown.dart' as d;

class StudentFeedbackScreen extends StatefulWidget {
  const StudentFeedbackScreen({Key? key}) : super(key: key);

  @override
  _StudentFeedbackScreenState createState() => _StudentFeedbackScreenState();
}

class _StudentFeedbackScreenState extends State<StudentFeedbackScreen> {
  List<String> categoryList = ['Faculty', 'Course', 'Other'];
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    List<FeedbackData> feedbackData = [
      FeedbackData(title: 'Prof. Aman Desai', date: 2),
      FeedbackData(title: 'Prof. Krutik Gadhiya', date: 4),
    ];
    final Size size = MediaQuery.of(context).size;
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Container(
          width: size.width - 50 > 380 ? 380 : size.width - 50,
          padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 4.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(color: Colors.grey)),
          child: d.DropdownButtonHideUnderline(
            child: d.DropdownButton<String>(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(12),
              ),
              focusColor: kBackgroundColor,
              value: selectedCategory,
              icon: Icon(Icons.expand_more_outlined),
              style: theme.textTheme.headline6!.copyWith(fontSize: 16.0),
              iconEnabledColor: Colors.black,
              items:
                  categoryList.map<d.DropdownMenuItem<String>>((String value) {
                return d.DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: theme.textTheme.headline6!.copyWith(fontSize: 16.0),
                  ),
                );
              }).toList(),
              hint: Text(
                "Select category",
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
            ),
          ),
        ),
        SizedBox(
          height: 16.0,
        ),
        Expanded(
          child: Container(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(feedbackData.length,
                    (index) => FeedbackCard(data: feedbackData[index])),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
