import 'package:feedsys/Screens/signupscreen.dart';
import 'package:feedsys/constants/colors.dart';
import 'package:flutter/material.dart';

class CategorySelection extends StatefulWidget {
  const CategorySelection({Key? key}) : super(key: key);

  @override
  _CategorySelectionState createState() => _CategorySelectionState();
}

class _CategorySelectionState extends State<CategorySelection> {
  final List<String> categoryList = ["Student", "Faculty", "Admin", "Alumni"];
  int selectedIndex = -1;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: List.generate(
                    categoryList.length,
                    (index) => GestureDetector(
                      onTap: () {
                        if (selectedIndex == index) {
                          selectedIndex = -1;
                          setState(() {});
                        } else {
                          selectedIndex = index;
                          setState(() {});
                        }
                      },
                      child: Container(
                        height: size.width * 0.4,
                        width: size.width * 0.4,
                        decoration: BoxDecoration(
                            border: Border.all(color: kPrimary),
                            borderRadius: BorderRadius.circular(40),
                            color: selectedIndex == index
                                ? kPrimary
                                : Colors.white),
                        child: Center(
                          child: Text(
                            "${categoryList[index]}",
                            style: theme.textTheme.headline6!.copyWith(
                                color: selectedIndex == index
                                    ? kWhite
                                    : Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ))),
          SizedBox(
            height: size.height * 0.15,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SignupScreen(
                          role: categoryList[selectedIndex].toLowerCase())));
            },
            child: Container(
              width: size.width * 0.85,
              margin: EdgeInsets.symmetric(horizontal: 5),
              padding: EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 2.0,
                      spreadRadius: 0.0,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(16.0),
                  color: Color(0xff4A5CFF)),
              child: Text(
                'Next',
                style: theme.textTheme.headline6!.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
