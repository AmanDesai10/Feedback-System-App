import 'dart:convert';

import 'package:http/http.dart' as http;

class QuestionTemplateDetials {
  final String? name;
  final List question;

  QuestionTemplateDetials({
    required this.name,
    required this.question,
  });
}

Future<List> getAlltemplateList() async {
  var feedbackListResponse = await http.get(Uri.parse(
      "https://sgp-feedback-system.herokuapp.com/api/getfeedbackque"));

  return jsonDecode(feedbackListResponse.body);
}
