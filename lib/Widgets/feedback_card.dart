import 'package:feedsys/Screens/student/data/feedback_data.dart';
import 'package:feedsys/constants/colors.dart';
import 'package:flutter/material.dart';

class FeedbackCard extends StatelessWidget {
  const FeedbackCard({
    Key? key,
    required this.data,
  }) : super(key: key);

  final FeedbackData data;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      height: 110,
      width: size.width - 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: kPrimary),
          color: kBackgroundColor),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32.0,
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    data.title,
                    style: theme.textTheme.headline6,
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    'Due in ${data.date} days',
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
