import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class QuestionTemplateDetials {
  final String? name;
  final List question;

  QuestionTemplateDetials({
    required this.name,
    required this.question,
  });
}

Future<List> getAlltemplateList() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String? token = preferences.getString('token');
  var feedbackListResponse = await http.get(
      Uri.parse("https://sgp-feedback-system.herokuapp.com/api/getfeedbackque"),
      headers: {'Authorization': 'Bearer $token'});

  return jsonDecode(feedbackListResponse.body);
}
