import 'dart:convert';

import 'package:feedsys/Screens/home/forward_category.dart';
import 'package:feedsys/Screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'Screens/welcome.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget screen = SplashScreen();
  String? userid;
  String? role;

  Future getPreviousUser() async {
    String url = "https://sgp-feedback-system.herokuapp.com/api/user?id=";
    SharedPreferences preferences = await SharedPreferences.getInstance();
    userid = preferences.getString('rem_id');
    setState(() {
      this.userid = userid;
    });
    print(userid);

    if (userid != null) {
      var response = await http.get(Uri.parse(url + userid!));
      setState(() {
        role = jsonDecode(response.body)['role'];
        print(role);
      });
    }
    // var jwtres = await http.get(
    //   Uri.parse(userinfo),
    //   headers: {'x-access-token': accessToken},
    // );
    // if (jwtres.statusCode != 200) {
    //   setState(() {
    //     jwt = true;
    //   });
    // }
    // print(jwt);
  }

  @override
  void initState() {
    getPreviousUser().whenComplete(() {
      screen = userid == null ? WelcomeScreen() : CategoryForwarding(role!);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Feedback System',
      theme: ThemeData(fontFamily: 'Montserrat'),
      home: screen,
    );
  }
}
