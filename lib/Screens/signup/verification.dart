import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:feedsys/Screens/home/homeScreen.dart';
import 'package:feedsys/Screens/signup/signupscreen.dart';
import 'package:feedsys/components/textfileds.dart';
import 'package:feedsys/components/validators.dart';
import 'package:feedsys/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:http/http.dart' as http;

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({Key? key, required this.email, required this.role})
      : super(key: key);
  final String email;
  final String role;

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController otpController = TextEditingController();
  late final StreamController<ErrorAnimationType>? errorController;

  int starttimer = 30;
  late Timer time;
  bool load = false;
  void timer() {
    time = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (starttimer == 0) {
        setState(() {
          starttimer = 30;
          timer.cancel();
        });
      } else {
        starttimer--;
        setState(() {});
      }
    });
  }

  void initState() {
    super.initState();
    errorController = StreamController<ErrorAnimationType>();
  }

  void dispose() {
    time.cancel();
    errorController!.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          color: Color(0xff4A5CFF),
          child: Stack(children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 32,
                    ),
                  )),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                height: size.height * 0.58,
                width: size.width - 50,
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
                        'OTP Verification',
                        style: theme.textTheme.headline6!.copyWith(
                            fontSize: 28,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        'A verification code has been sent to ${widget.email}',
                        style: theme.textTheme.subtitle1!.copyWith(
                          fontSize: 12,
                          fontFamily: 'Montserrat',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      Expanded(
                        child: Form(
                          key: _formKey,
                          child: ListView(
                            shrinkWrap: true,
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                              // left: 16,
                              // right: 16
                            ),
                            children: [
                              PinCodeTextField(
                                appContext: context,
                                length: 6,
                                onChanged: (otp) {
                                  setState(() {});
                                },
                                controller: otpController,
                                autoDismissKeyboard: true,
                                autoDisposeControllers: false,
                                animationType: AnimationType.fade,
                                enableActiveFill: true,
                                errorAnimationController: errorController,
                                keyboardType: TextInputType.number,
                                // onCompleted: (a) {
                                //   errorController!
                                //       .add(ErrorAnimationType.shake);
                                // },
                                pinTheme: PinTheme(
                                  fieldOuterPadding:
                                      EdgeInsets.symmetric(horizontal: 2),
                                  activeColor: kPrimary.withOpacity(0.2),
                                  activeFillColor: kPrimary.withOpacity(0.2),
                                  inactiveFillColor: kPrimary.withOpacity(0.2),
                                  inactiveColor: kPrimary.withOpacity(0.2),
                                  selectedFillColor: Colors.transparent,
                                  fieldWidth: 40,
                                  shape: PinCodeFieldShape.box,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(children: [
                                  TextSpan(
                                      text: "Didn't receive OTP?",
                                      style: theme.textTheme.bodyText1),
                                  WidgetSpan(
                                      child: GestureDetector(
                                    child: Text(
                                        starttimer == 30
                                            ? " Resend"
                                            : " Resend in $starttimer sec",
                                        style: theme.textTheme.bodyText1!
                                            .copyWith(
                                                color: starttimer == 30
                                                    ? Color(0xff4A5CFF)
                                                    : theme.disabledColor,
                                                fontWeight: FontWeight.bold)),
                                    onTap: starttimer == 30
                                        ? () async {
                                            timer();
                                            bool resend = true;
                                            var response = await http.post(
                                                Uri.parse(
                                                    "https://sgp-feedback-system.herokuapp.com/api/verify"),
                                                headers: {
                                                  'Content-Type':
                                                      'application/json'
                                                },
                                                body: json.encode({
                                                  'email': widget.email,
                                                  'otp': 0,
                                                  'reSend': resend
                                                }));
                                            if (response.statusCode == 200) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      '${jsonDecode(response.body)['message']}'),
                                                  duration:
                                                      Duration(seconds: 2),
                                                ),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          "${jsonDecode(response.body)['message']}")));
                                            }

                                            setState(() {});
                                          }
                                        : () {},
                                    onDoubleTap: () {},
                                  )),
                                ]),
                              ),
                              SizedBox(
                                height: 48,
                              ),
                              GestureDetector(
                                onTap: otpController.text.length == 6
                                    ? () async {
                                        if (otpController.text.length == 6) {
                                          setState(() {
                                            load = true;
                                          });
                                          bool resend = false;
                                          var response = await http.post(
                                              Uri.parse(
                                                  "https://sgp-feedback-system.herokuapp.com/api/verify"),
                                              headers: {
                                                'Content-Type':
                                                    'application/json'
                                              },
                                              body: json.encode({
                                                'email': widget.email,
                                                'otp': otpController.text,
                                                'reSend': resend
                                              }));
                                          setState(() {
                                            load = false;
                                          });
                                          log(response.statusCode.toString());
                                          log(response.body);
                                          if (response.statusCode == 200) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        HomeScreen(
                                                          role: widget.role,
                                                        )));
                                          } else if (response.statusCode ==
                                              401) {
                                            errorController!
                                                .add(ErrorAnimationType.shake);
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
                                          errorController!
                                              .add(ErrorAnimationType.shake);
                                        }
                                      }
                                    : () {},
                                child: Container(
                                  width: size.width,
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16.0),
                                      color: otpController.text.length == 6
                                          ? Color(0xff4A5CFF)
                                          : theme.disabledColor),
                                  child: load
                                      ? Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                          'Verify',
                                          style: theme.textTheme.headline6!
                                              .copyWith(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                          textAlign: TextAlign.center,
                                        ),
                                ),
                              ),
                              SizedBox(
                                height: 32,
                              ),
                              Text(
                                "By signing in you accept our terms and condition",
                                textAlign: TextAlign.center,
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
          ]),
        ),
      ),
    );
  }
}
