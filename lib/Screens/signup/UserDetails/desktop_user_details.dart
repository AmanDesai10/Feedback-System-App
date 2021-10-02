import 'package:feedsys/Screens/signup/UserDetails/data/institute_details.dart';
import 'package:feedsys/Screens/signup/signupscreen.dart';
import 'package:feedsys/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:feedsys/Widgets/dropdown.dart' as d;

class DesktopDetailSelection extends StatefulWidget {
  const DesktopDetailSelection({Key? key}) : super(key: key);

  @override
  _DesktopDetailSelectionState createState() => _DesktopDetailSelectionState();
}

class _DesktopDetailSelectionState extends State<DesktopDetailSelection> {
  final InstituteData _instituteData = InstituteData();
  List<String> departmentList = [];
  String? userCollege;
  String? dept;
  int selectedIndex = -1;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData theme = Theme.of(context);

    if (userCollege != null) {
      departmentList = _instituteData.department[userCollege] ?? [];
    }
    return Scaffold(
      body: Container(
        height: size.height,
        child: Center(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: SvgPicture.asset('images/topleft.svg'),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: SvgPicture.asset('images/bottomright.svg'),
              ),
              Padding(
                padding: const EdgeInsets.all(35.0)
                    .copyWith(left: size.width * 0.2, right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome to Feedsys, please fill below details to get started',
                      style: theme.textTheme.headline5!
                          .copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(
                      height: 64.0,
                    ),
                    Container(
                      height: size.height * 0.5,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            UserDetailTitle(
                              title: 'Select Category',
                            ),
                            SizedBox(
                              height: 16.0,
                            ),
                            Wrap(
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
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10.0),
                                      width:
                                          size.width > 150 ? 150 : size.width,
                                      decoration: BoxDecoration(
                                          border: Border.all(color: kPrimary),
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          color: selectedIndex == index
                                              ? kPrimary
                                              : Colors.white),
                                      child: Center(
                                        child: Text(
                                          "${_instituteData.categoryList[index]}",
                                          style: theme.textTheme.headline6!
                                              .copyWith(
                                                  color: selectedIndex == index
                                                      ? kWhite
                                                      : Colors.black),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                )),
                            SizedBox(
                              height: 32.0,
                            ),
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
                                  focusColor: Colors.white,
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
                            SizedBox(
                              height: 32.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: size.height * 0.15),
                  child: GestureDetector(
                    onTap: selectedIndex != -1 &&
                            dept != null &&
                            userCollege != null
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
                    child: Container(
                      width: size.width > 450 ? 450 : null,
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
                          color: selectedIndex != -1 &&
                                  dept != null &&
                                  userCollege != null
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
                ),
              ),
              // Center(
              //     child: Wrap(
              //         spacing: 20,
              //         runSpacing: 20,
              //         children: List.generate(
              //           categoryList.length,
              //           (index) => GestureDetector(
              //             onTap: () {
              //               if (selectedIndex == index) {
              //                 selectedIndex = -1;
              //                 setState(() {});
              //               } else {
              //                 selectedIndex = index;
              //                 setState(() {});
              //               }
              //             },
              //             child: Container(
              //               padding: EdgeInsets.symmetric(vertical: 10.0),
              //               width: size.width > 150 ? 150 : size.width,
              //               decoration: BoxDecoration(
              //                   border: Border.all(color: kPrimary),
              //                   borderRadius: BorderRadius.circular(40),
              //                   color: selectedIndex == index
              //                       ? kPrimary
              //                       : Colors.white),
              //               child: Center(
              //                 child: Text(
              //                   "${categoryList[index]}",
              //                   style: theme.textTheme.headline6!.copyWith(
              //                       color: selectedIndex == index
              //                           ? kWhite
              //                           : Colors.black),
              //                   textAlign: TextAlign.center,
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ))),
              // SizedBox(
              //   height: size.height * 0.15,
              // ),
              // GestureDetector(
              //   onTap: selectedIndex == -1
              //       ? null
              //       : () {
              //           Navigator.push(
              //               context,
              //               MaterialPageRoute(
              //                   builder: (context) => SignupScreen(
              //                       role: categoryList[selectedIndex]
              //                           .toLowerCase())));
              //         },
              //   child: Container(
              //     width: size.width > 450 ? 450 : null,
              //     margin: EdgeInsets.symmetric(horizontal: 5),
              //     padding: EdgeInsets.symmetric(vertical: 16),
              //     decoration: BoxDecoration(
              //         boxShadow: [
              //           BoxShadow(
              //             color: Colors.black,
              //             blurRadius: 2.0,
              //             spreadRadius: 0.0,
              //           ),
              //         ],
              //         borderRadius: BorderRadius.circular(16.0),
              //         color: selectedIndex == -1 ? Colors.grey : kPrimary),
              //     child: Text(
              //       'Next',
              //       style: theme.textTheme.headline6!.copyWith(
              //           fontSize: 16,
              //           fontWeight: FontWeight.bold,
              //           color: Colors.white),
              //       textAlign: TextAlign.center,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserDetailTitle extends StatelessWidget {
  const UserDetailTitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Text(
      title,
      style: theme.textTheme.headline6!.copyWith(fontWeight: FontWeight.bold),
      textAlign: TextAlign.start,
    );
  }
}
