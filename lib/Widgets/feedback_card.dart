// import 'dart:convert';

// import 'package:feedsys/Screens/student/data/feedback_data.dart';
// import 'package:feedsys/Screens/student/student_feedback_question_screen.dart';
// import 'package:feedsys/constants/colors.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class FeedbackCard extends StatelessWidget {
//   const FeedbackCard({Key? key, required this.data, required this.id})
//       : super(key: key);

//   final FeedbackData data;
//   final String id;

//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.of(context).size;
//     final ThemeData theme = Theme.of(context);
//     return GestureDetector(
//       onTap: () async {
//         var response = await http.get(Uri.parse(
//             'https://sgp-feedback-system.herokuapp.com/api/getfeedbackque?id=$id'));
//         // questions = jsonDecode(response.body)['questions'];
//         List questions = jsonDecode(response.body)[0]['questions'];
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => StudentFeedbackQuestionScreen(
//                       questions: questions,
//                     )));
//       },
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
//         margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//         height: 110,
//         width: size.width - 50,
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(color: kPrimary),
//             color: kBackgroundColor),
//         child: Row(
//           children: [
//             CircleAvatar(
//               radius: 32.0,
//             ),
//             SizedBox(width: 16.0),
//             Expanded(
//               child: Container(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Text(
//                       data.title,
//                       style: theme.textTheme.headline6,
//                     ),
//                     SizedBox(
//                       height: 16.0,
//                     ),
//                     Text(
//                       'Due in ${data.date} days',
//                     )
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
