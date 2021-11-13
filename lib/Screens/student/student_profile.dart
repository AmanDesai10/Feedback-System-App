import 'dart:developer';

import 'package:feedsys/Screens/welcome.dart';
import 'package:feedsys/components/textfileds.dart';
import 'package:feedsys/constants/colors.dart';
import 'package:feedsys/utils/device_info.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? username = 'Guest';
  String? institute = '';
  String? department = '';

  void getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString('institute'));
    setState(() {
      username = prefs.getString('name');
      institute = prefs.getString('institute');
      department = prefs.getString('department');
    });
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = DeviceScreen.isDesktop(context);
    final ThemeData theme = Theme.of(context);
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
      child: SingleChildScrollView(
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
                    // child: Image.network(
                    //   'https://cdn3.iconfinder.com/data/icons/business-round-flat-vol-1-1/36/user_account_profile_avatar_person_student_male-512.png',
                    //   fit: BoxFit.cover,
                    // ),
                    child: CircleAvatar(
                      child: Text(username!.substring(0, 1)),
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
                        style:
                            theme.textTheme.bodyText1!.copyWith(color: kWhite),
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
            ReadOnlyArgTextField(
              value: username!,
              readOnly: true,
            ),
            SizedBox(
              height: 16.0,
            ),
            TitleText(text: 'Institute'),
            SizedBox(
              height: 16.0,
            ),
            ReadOnlyArgTextField(
              value: institute!,
              readOnly: true,
            ),
            SizedBox(
              height: 16.0,
            ),
            TitleText(text: 'Department'),
            SizedBox(
              height: 16.0,
            ),
            ReadOnlyArgTextField(
              value: department!,
              readOnly: true,
            ),
            SizedBox(
              height: 32.0,
            ),
            Center(
              child: GestureDetector(
                onTap: () async {
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  // preferences.remove("_id");
                  preferences.clear();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => WelcomeScreen()),
                      (route) => false);
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: kPrimary, borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.all(16.0),
                  width: 120,
                  child: Center(
                      child: Text(
                    "Logout",
                    style: theme.textTheme.headline6!.copyWith(color: kWhite),
                  )),
                ),
              ),
            )
          ],
        ),
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
      style: theme.textTheme.headline6!
          .copyWith(fontWeight: FontWeight.bold, fontSize: 18),
    );
  }
}

class ReadOnlyArgTextField extends StatelessWidget {
  const ReadOnlyArgTextField(
      {Key? key,
      this.value = '',
      this.hintText,
      this.readOnly = false,
      this.suffixIcon,
      this.onChanged,
      this.controller,
      this.maxLines = 1})
      : super(key: key);
  final String value;
  final Widget? suffixIcon;
  final String? hintText;
  final Function(String)? onChanged;
  final bool readOnly;
  final TextEditingController? controller;
  final int maxLines;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextEditingController textcontroller =
        TextEditingController(text: value);
    return TextFormField(
      maxLines: maxLines,
      readOnly: readOnly,
      controller: value.isNotEmpty ? textcontroller : controller,
      onChanged: onChanged,
      style: theme.textTheme.headline6!.copyWith(fontSize: 18),
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        hintText: hintText,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18.0),
            borderSide: BorderSide(color: Colors.grey.shade400)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18.0),
            borderSide: BorderSide(color: Colors.grey)),
        contentPadding: EdgeInsets.all(16.0).copyWith(right: 16 * 1.4 * 2),
        hintStyle: theme.textTheme.bodyText2!
            .copyWith(fontSize: 16.0, color: Colors.grey.shade400),
      ),
    );
  }
}
