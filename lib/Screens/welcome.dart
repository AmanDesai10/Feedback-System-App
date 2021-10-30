import 'package:feedsys/Screens/signup/UserDetails/user_detail_screen.dart';
import 'package:feedsys/Screens/login/loginscreen.dart';
import 'package:feedsys/Screens/signup/UserDetails/userdetail_view.dart';
import 'package:feedsys/constants/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          height: size.height,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  ClipPath(
                    child: Container(
                      width: size.width,
                      height: size.height * 0.18,
                      color: kPrimary,
                      child: Center(
                        child: Transform.translate(
                          offset: Offset(0, -10),
                          child: Text(
                            kIsWeb ? 'FeedSys Web' : 'FeedSys',
                            style: theme.textTheme.headline6!.copyWith(
                                color: kWhite,
                                fontWeight: FontWeight.bold,
                                fontSize: 30.0),
                          ),
                        ),
                      ),
                    ),
                    clipper: CustomClipPath(),
                  ),
                ],
              ),
              // Align(
              //     alignment: Alignment.topCenter,
              //     child: SvgPicture.asset(
              //       'images/welcome_bg_name.svg',
              //       // height: size.height * 0.19,
              //       fit: BoxFit.fill,
              //     )),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Image.asset(
                      'images/welcome_vector.jpg',
                      height: size.height * 0.38,
                    ),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: size.width > 450 ? 450 : null,
                      child: Text(
                        'Provide Feedback on the go. Analyze the responses in much better and convinent way',
                        style: theme.textTheme.bodyText2!
                            .copyWith(fontFamily: 'Montserrat', fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  // Spacer(),
                  SizedBox(
                    height: 48.0, //initially it was 0.1
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 45),
                        width: size.width > 450 ? 450 : double.maxFinite,
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all()),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(
                                color: Color(0xff4A5CFF),
                                fontFamily: 'Montserrat',
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 45, vertical: 16),
                        width: size.width > 450 ? 450 : double.maxFinite,
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                        decoration: BoxDecoration(
                            color: Color(0xff4A5CFF),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all()),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UserDetailView()));
                          },
                          child: Text(
                            'Signup',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Montserrat',
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 32,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  var radius = 10.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width / 4, size.height - 80, size.width / 1.8, size.height - 20);
    path.quadraticBezierTo(
        (size.width * 0.8), size.height + 20, size.width, size.height - 50);
    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
