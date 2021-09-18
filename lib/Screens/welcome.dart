import 'package:feedsys/Screens/categoryselection.dart';
import 'package:feedsys/Screens/loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WelcomeScreen extends ConsumerWidget {
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final ThemeData theme = Theme.of(context);
    final Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                  alignment: Alignment.topCenter,
                  child: SvgPicture.asset(
                    'images/welcome_bg_name.svg',
                    // height: size.height * 0.19,
                    fit: BoxFit.fill,
                  )),
              Center(
                child: Image.asset(
                  'images/welcome_vector.jpg',
                  height: size.height * 0.38,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Provide Feedback on the go. Analyze the responses in much better and convinent way',
                  style: theme.textTheme.bodyText2!
                      .copyWith(fontFamily: 'Montserrat', fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 35,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 45),
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all()),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
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
              SizedBox(
                height: 16,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 45),
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                decoration: BoxDecoration(
                    color: Color(0xff4A5CFF),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all()),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CategorySelection()));
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
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0).copyWith(bottom: 20),
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: 3,
                  effect: WormEffect(
                    dotHeight: 10,
                    dotWidth: 10,
                    activeDotColor: Color(0xff4A5CFF),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
