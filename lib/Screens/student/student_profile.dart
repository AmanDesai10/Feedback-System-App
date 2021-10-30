import 'dart:developer';

import 'package:feedsys/components/textfileds.dart';
import 'package:feedsys/constants/colors.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: ClipOval(
                child: Container(
                  width: 120,
                  height: 120,
                  child: Image.network(
                    'https://cdn3.iconfinder.com/data/icons/business-round-flat-vol-1-1/36/user_account_profile_avatar_person_student_male-512.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  log('Pick Image');
                });
              },
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), color: kPrimary),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.edit,
                      size: 16,
                      color: kWhite,
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Text(
                      'Edit',
                      style: theme.textTheme.bodyText1!.copyWith(color: kWhite),
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 32.0,
          ),
          TitleText(text: 'Name'),
          SizedBox(
            height: 8.0,
          ),
          ReadOnlyTextField(
            value: 'Aman Desai',
          ),
          SizedBox(
            height: 16.0,
          ),
          TitleText(text: 'Institute'),
          SizedBox(
            height: 16.0,
          ),
          ReadOnlyTextField(
            value: 'CSPIT',
          ),
          SizedBox(
            height: 16.0,
          ),
          TitleText(text: 'Department'),
          SizedBox(
            height: 16.0,
          ),
          ReadOnlyTextField(
            value: 'IT',
          ),
        ],
      ),
    );
  }
}

class TitleText extends StatelessWidget {
  const TitleText({
    Key? key,
    required this.text,
  }) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Text(
      text,
      style: theme.textTheme.headline6!.copyWith(fontWeight: FontWeight.bold),
    );
  }
}
