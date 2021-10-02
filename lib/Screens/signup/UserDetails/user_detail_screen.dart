import 'package:animate_do/animate_do.dart';
import 'package:feedsys/Screens/signup/UserDetails/data/institute_details.dart';
import 'package:feedsys/Screens/signup/UserDetails/desktop_user_details.dart';
import 'package:feedsys/Screens/signup/signupscreen.dart';
import 'package:feedsys/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:feedsys/Widgets/dropdown.dart' as d;

class CategorySelection extends StatefulWidget {
  const CategorySelection({Key? key}) : super(key: key);

  @override
  _CategorySelectionState createState() => _CategorySelectionState();
}

class _CategorySelectionState extends State<CategorySelection> {
  final InstituteData _instituteData = InstituteData();
  List<String> departmentList = [];
  String? userCollege;
  String? dept;
  int selectedIndex = -1;
  int pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData theme = Theme.of(context);

    if (userCollege != null) {
      departmentList = _instituteData.department[userCollege] ?? [];
    }
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Padding(
        padding: EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            pageIndex == 0
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Select Your Category',
                        style: theme.textTheme.headline6!.copyWith(
                            fontSize: 28.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 64.0,
                      ),
                      Center(
                          child: Container(
                        height: size.height * 0.45,
                        width: size.width,
                        child: SingleChildScrollView(
                          child: Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 20,
                              runSpacing: 20,
                              children: List.generate(
                                _instituteData.categoryList.length,
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
                                    height: size.width * 0.37 > 150
                                        ? 150
                                        : size.width * 0.37,
                                    // width: size.width > 150 ? 150 : size.width,
                                    width: size.width * 0.37 > 150
                                        ? 150
                                        : size.width * 0.37,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: selectedIndex == index
                                                ? kPrimary
                                                : Colors.grey),
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                        color: Colors.white),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            'images/${_instituteData.categoryList[index].toLowerCase()}.svg',
                                            width: 75,
                                            height: 75,
                                            color: selectedIndex == index
                                                ? kPrimary
                                                : Colors.black,
                                          ),
                                          SizedBox(
                                            height: 16.0,
                                          ),
                                          Text(
                                            "${_instituteData.categoryList[index]}",
                                            style: theme.textTheme.headline6!
                                                .copyWith(
                                                    color:
                                                        selectedIndex == index
                                                            ? kPrimary
                                                            : Colors.black),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                        ),
                      )),
                    ],
                  )
                : SlideInRight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Select your Institute',
                          style: theme.textTheme.headline6!.copyWith(
                              fontSize: 28.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 64.0,
                        ),
                        Center(
                            child: Container(
                          height: size.height * 0.45,
                          width: size.width,
                          child: SingleChildScrollView(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              UserDetailTitle(
                                title: 'College',
                              ),
                              SizedBox(
                                height: 16.0,
                              ),
                              Container(
                                width: 380,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 14.0, vertical: 4.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.0),
                                    border: Border.all(color: Colors.grey)),
                                child: d.DropdownButtonHideUnderline(
                                  child: d.DropdownButton<String>(
                                    borderRadius: BorderRadius.vertical(
                                      bottom: Radius.circular(12),
                                    ),
                                    dropdownColor: kBackgroundColor,
                                    focusColor: kBackgroundColor,
                                    value: userCollege,
                                    icon: Icon(Icons.expand_more_outlined),
                                    style: theme.textTheme.headline6!
                                        .copyWith(fontSize: 16.0),
                                    iconEnabledColor: Colors.black,
                                    items: _instituteData.collegeList
                                        .map<d.DropdownMenuItem<String>>(
                                            (String value) {
                                      return d.DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: theme.textTheme.headline6!
                                              .copyWith(fontSize: 16.0),
                                        ),
                                      );
                                    }).toList(),
                                    hint: Text(
                                      "Select college",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        userCollege = value!;
                                        dept = null;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 32.0,
                              ),
                              UserDetailTitle(
                                title: 'Department',
                              ),
                              SizedBox(
                                height: 16.0,
                              ),
                              Container(
                                width: 380,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 14.0, vertical: 4.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.0),
                                    border: Border.all(color: Colors.grey)),
                                child: d.DropdownButtonHideUnderline(
                                  child: d.DropdownButton<String>(
                                    borderRadius: BorderRadius.vertical(
                                      bottom: Radius.circular(12),
                                    ),
                                    dropdownColor: kBackgroundColor,
                                    focusColor: Colors.white,
                                    value: dept,
                                    icon: Icon(Icons.expand_more_outlined),
                                    style: theme.textTheme.headline6!
                                        .copyWith(fontSize: 16.0),
                                    iconEnabledColor: Colors.black,
                                    items: departmentList
                                        .map<d.DropdownMenuItem<String>>(
                                            (String value) {
                                      return d.DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: theme.textTheme.headline6!
                                              .copyWith(fontSize: 16.0),
                                        ),
                                      );
                                    }).toList(),
                                    hint: Text(
                                      "Select department",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        dept = value!;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          )),
                        )),
                      ],
                    ),
                  ),
            SizedBox(
              height: size.height * 0.15,
            ),
            GestureDetector(
              onTap: pageIndex == 0
                  ? selectedIndex == -1
                      ? null
                      : () {
                          setState(() {
                            pageIndex = 1;
                          });
                        }
                  : dept != null && userCollege != null
                      ? () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignupScreen(
                                      role: _instituteData
                                          .categoryList[selectedIndex]
                                          .toLowerCase())));
                        }
                      : null,

              // selectedIndex == -1
              //     ? null
              //     : pageIndex == 0
              //         ? () {
              //             setState(() {
              //               pageIndex = 1;
              //             });
              //           }
              //         : () {
              //             Navigator.push(
              //                 context,
              //                 MaterialPageRoute(
              //                     builder: (context) => SignupScreen(
              //                         role: _instituteData
              //                             .categoryList[selectedIndex]
              //                             .toLowerCase())));
              //           },
              child: Container(
                width: 250,
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
                    color: pageIndex == 0
                        ? selectedIndex == -1
                            ? Colors.grey
                            : kPrimary
                        : dept != null && userCollege != null
                            ? kPrimary
                            : Colors.grey),
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
      ),
    );
  }
}
