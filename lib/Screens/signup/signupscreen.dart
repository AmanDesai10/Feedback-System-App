import 'dart:convert';
import 'dart:developer';

import 'package:feedsys/Screens/home/homeScreen.dart';
import 'package:feedsys/Screens/login/loginscreen.dart';
import 'package:feedsys/Screens/signup/verification.dart';
import 'package:feedsys/components/textfileds.dart';
import 'package:feedsys/components/validators.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:feedsys/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:feedsys/utils/device_info.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen(
      {Key? key,
      required this.role,
      required this.institute,
      required this.department})
      : super(key: key);
  final String role;
  final String institute;
  final String department;

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  String? name;
  String? email;
  String? password;
  String? confirmPassword;
  bool isObscure = true;
  bool confirmObscure = true;
  bool load = false;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Size size = MediaQuery.of(context).size;
    final bool isDesktop = DeviceScreen.isDesktop(context);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          // decoration: BoxDecoration(
          //     image: DecorationImage(
          //         image: AssetImage('images/signup_blob.png'),
          //         fit: BoxFit.contain)),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: SvgPicture.asset(
                  'images/topright.svg',
                  height: isDesktop ? null : size.height * 0.2,
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: SvgPicture.asset(
                  'images/bottomleft.svg',
                  height: isDesktop ? null : size.height * 0.2,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(35.0),
                child: Column(
                  crossAxisAlignment: isDesktop
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
                  children: [
                    isDesktop
                        ? SizedBox(
                            height: size.height * 0.1,
                          )
                        : SizedBox(),
                    Text(
                      'Signup',
                      style: theme.textTheme.headline6!
                          .copyWith(fontWeight: FontWeight.bold, fontSize: 28),
                    ),
                    SizedBox(
                      height:
                          isDesktop ? size.height * 0.05 : size.height * 0.12,
                    ),
                    Center(
                      child: Container(
                        height: size.height * 0.68,
                        width: size.width > 450 ? 450 : null,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: SingleChildScrollView(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 16.0),
                                    child: Form(
                                      key: _formKey,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          AuthTextField(
                                            title: 'Username',
                                            hintText: 'Enter full Name',
                                            onChanged: (input) {
                                              name = input;
                                              setState(() {});
                                            },
                                            validator: nameValidator,
                                          ),
                                          SizedBox(
                                            height: 28,
                                          ),
                                          AuthTextField(
                                            title: 'Email',
                                            hintText: 'Enter Email',
                                            onChanged: (input) {
                                              email = input;
                                              setState(() {});
                                            },
                                            validator: emailValidator,
                                          ),
                                          SizedBox(
                                            height: 28,
                                          ),
                                          AuthTextField(
                                            title: 'Password',
                                            hintText: 'Enter Password',
                                            onChanged: (input) {
                                              password = input;
                                              setState(() {});
                                            },
                                            validator: passwordValidator,
                                            isObscure: isObscure,
                                            suffixIcon: GestureDetector(
                                              onTap: () {
                                                isObscure = !isObscure;
                                                setState(() {});
                                              },
                                              child: Icon(
                                                isObscure
                                                    ? Icons
                                                        .visibility_off_outlined
                                                    : Icons.visibility_outlined,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 28,
                                          ),
                                          AuthTextField(
                                            title: 'Confirm Password',
                                            hintText: 'Confirm Your Password',
                                            onChanged: (input) {
                                              confirmPassword = input;
                                              setState(() {});
                                            },
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "Please Enter password to Confirm";
                                              } else if (value != password) {
                                                return "Password does not match";
                                              }
                                            },
                                            isObscure: confirmObscure,
                                            suffixIcon: GestureDetector(
                                              onTap: () {
                                                confirmObscure =
                                                    !confirmObscure;
                                                setState(() {});
                                              },
                                              child: Icon(
                                                confirmObscure
                                                    ? Icons
                                                        .visibility_off_outlined
                                                    : Icons.visibility_outlined,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 28,
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                setState(() {
                                                  load = true;
                                                });
                                                log(email!);
                                                log(name!);
                                                log(password!);
                                                log(widget.role);
                                                var response = await http.post(
                                                    Uri.parse(
                                                        "https://sgp-feedback-system.herokuapp.com/api/signUp"),
                                                    headers: {
                                                      'Content-Type':
                                                          'application/json'
                                                    },
                                                    body: jsonEncode({
                                                      'email': email,
                                                      'password': password,
                                                      'userName': name,
                                                      'role': widget.role,
                                                      "institute":
                                                          widget.institute,
                                                      "department":
                                                          widget.department
                                                    }));
                                                setState(() {
                                                  load = false;
                                                });
                                                if (response.statusCode ==
                                                    200) {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              VerificationScreen(
                                                                email: email!,
                                                                role:
                                                                    widget.role,
                                                              )));
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
                                                print(response.body);
                                              }
                                            },
                                            child: Container(
                                              width: size.width,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 5),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 16),
                                              decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black,
                                                      blurRadius: 2.0,
                                                      spreadRadius: 0.0,
                                                    ),
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          16.0),
                                                  color: Color(0xff4A5CFF)),
                                              child: load
                                                  ? Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        SizedBox(
                                                            height: 24,
                                                            width: 24,
                                                            child:
                                                                CircularProgressIndicator(
                                                              color: kWhite,
                                                              strokeWidth: 3,
                                                            )),
                                                      ],
                                                    )
                                                  : Text(
                                                      'Signup',
                                                      style: theme
                                                          .textTheme.headline6!
                                                          .copyWith(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 16,
                                          ),
                                          RichText(
                                            textAlign: TextAlign.center,
                                            text: TextSpan(children: [
                                              TextSpan(
                                                  text: "Already a user?",
                                                  style: theme
                                                      .textTheme.bodyText1),
                                              WidgetSpan(
                                                  child: GestureDetector(
                                                child: Text(" Login",
                                                    style: theme
                                                        .textTheme.bodyText1!
                                                        .copyWith(
                                                            color: Color(
                                                                0xff4A5CFF),
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                onTap: () {
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              LoginScreen()));
                                                },
                                              ))
                                            ]),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // !_formKey.currentState!.validate()
                              //     ? SizedBox(
                              //         height: size.height * 0.1,
                              //       )
                              //     : SizedBox()
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
