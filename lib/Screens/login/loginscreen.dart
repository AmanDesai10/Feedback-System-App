import 'dart:convert';
import 'dart:developer';

import 'package:feedsys/Screens/home/forward_category.dart';
import 'package:feedsys/Screens/home/homeScreen.dart';
import 'package:feedsys/Screens/signup/UserDetails/view/userdetail_view.dart';
import 'package:feedsys/Screens/signup/signupscreen.dart';
import 'package:feedsys/Screens/signup/verification.dart';
import 'package:feedsys/components/textfileds.dart';
import 'package:feedsys/components/validators.dart';
import 'package:feedsys/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  bool isObscure = true;
  bool isRemember = false;
  bool load = false;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        // color: MediaQuery.of(context).viewInsets.bottom > 0.0
        //     ? Color(0xff4A5CFF)
        //     : Colors.white,
        child: Stack(alignment: Alignment.topCenter, children: [
          // Transform.translate(
          //   offset: Offset(0, -15),
          //   child: Align(
          //     alignment: Alignment.topCenter,
          //     child: Container(
          //       child: Image.asset(
          //         'images/login_bg.png',
          //         fit: BoxFit.fitWidth,
          //       ),
          //     ),
          //   ),
          // ),
          Align(
            alignment: Alignment.topCenter,
            child: ClipPath(
              child: Container(
                width: size.width,
                height: size.height * 0.75,
                color: kPrimary,
              ),
              clipper: CustomClipPath(),
            ),
          ),
          Positioned(
            top: size.height * 0.2,
            child: Container(
              height: size.height * 0.6,
              width: size.width - 50 > 450 ? 450 : size.width - 50,
              margin: EdgeInsets.symmetric(horizontal: 25),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 20)]),
              child: Padding(
                padding: EdgeInsets.all(15.0).copyWith(top: 30),
                child: Column(
                  children: [
                    Text(
                      'Login',
                      style: theme.textTheme.headline6!.copyWith(
                          fontSize: 28,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Signin to continue!!',
                      style: theme.textTheme.subtitle1!.copyWith(
                        fontSize: 12,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Expanded(
                      child: Form(
                        key: _formKey,
                        child: ListView(
                          shrinkWrap: true,
                          padding: EdgeInsets.all(16).copyWith(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          children: [
                            AuthTextField(
                              title: 'Email',
                              hintText: 'Enter your email',
                              onChanged: (input) {
                                email = input;
                                setState(() {});
                              },
                              validator: emailValidator,
                            ),
                            SizedBox(
                              height: 32,
                            ),
                            AuthTextField(
                              title: 'Password',
                              hintText: 'Enter your password',
                              onChanged: (input) {
                                password = input;
                                setState(() {});
                              },
                              validator: passwordValidator,
                              isObscure: isObscure,
                              suffixIcon: GestureDetector(
                                child: Icon(
                                  isObscure
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                                onTap: () {
                                  isObscure = !isObscure;
                                  setState(() {});
                                },
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                Transform.scale(
                                  scale: 0.8,
                                  child: Checkbox(
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    value: isRemember,
                                    onChanged: (check) {
                                      isRemember = check!;
                                      setState(() {});
                                    },
                                  ),
                                ),
                                Text(
                                  'Remember Me',
                                  style: theme.textTheme.headline6!.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                Spacer(),
                                Text(
                                  'Forgot Password?',
                                  style: theme.textTheme.bodyText1!
                                      .copyWith(color: theme.primaryColor),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 32,
                            ),
                            GestureDetector(
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    load = true;
                                  });
                                  var response = await http.post(
                                      Uri.parse(
                                          "https://sgp-feedback-system.herokuapp.com/api/login"),
                                      headers: {
                                        'Content-Type': 'application/json'
                                      },
                                      body: jsonEncode({
                                        'email': email,
                                        'password': password
                                      }));
                                  setState(() {
                                    load = false;
                                  });
                                  if (response.statusCode == 200) {
                                    log(response.body);
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    if (isRemember) {
                                      prefs.setString('rem_id',
                                          jsonDecode(response.body)['_id']);
                                    }
                                    prefs.setString('_id',
                                        jsonDecode(response.body)['_id']);
                                    prefs.setString('name',
                                        jsonDecode(response.body)['userName']);
                                    prefs.setString('institute',
                                        jsonDecode(response.body)['institute']);
                                    prefs.setString(
                                        'department',
                                        jsonDecode(
                                            response.body)['department']);
                                    // prefs.setInt('sem',
                                    //     jsonDecode(response.body)['sem']);
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CategoryForwarding(jsonDecode(
                                                  response.body)['role'])),
                                      (route) => false,
                                    );
                                  } else if (response.statusCode == 401) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                VerificationScreen(
                                                    email: email!,
                                                    role: jsonDecode(response
                                                        .body)['role'])));
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "${jsonDecode(response.body)['message']}")));
                                  }
                                  print(response.body);
                                }
                              },
                              child: Container(
                                height: size.height * 0.07,
                                // padding: EdgeInsets.symmetric(vertical: 14),
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.0),
                                    color: Color(0xff4A5CFF)),
                                child: load
                                    ? Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                          'Login',
                                          style: theme.textTheme.headline6!
                                              .copyWith(
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
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            // top: 560,
            top: size.height - 100,
            left: 10.0,
            right: 20.0,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: [
                TextSpan(
                    text: "Don't have an account?",
                    style: theme.textTheme.bodyText1),
                WidgetSpan(
                    child: GestureDetector(
                  child: Text(" SignUp",
                      style: theme.textTheme.bodyText1!.copyWith(
                          color: Color(0xff4A5CFF),
                          fontWeight: FontWeight.bold)),
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserDetailView()));
                  },
                ))
              ]),
            ),
          )
        ]),
      ),
    );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 100);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 100);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
