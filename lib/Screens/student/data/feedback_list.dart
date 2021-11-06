import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<List> getFeedbackList() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String? id = preferences.getString('_id');
  var UserResponse = await http.get(
      Uri.parse("https://sgp-feedback-system.herokuapp.com/api/user?id=$id"));
  String institute = jsonDecode(UserResponse.body)['institute'];
  String dept = jsonDecode(UserResponse.body)['department'];
  int sem = jsonDecode(UserResponse.body)['sem'];

  var feedbackListResponse = await http.get(Uri.parse(
      "https://sgp-feedback-system.herokuapp.com/api/getfeedbacklist?institute=$institute&department=$dept&sem=$sem"));

  return jsonDecode(feedbackListResponse.body);
}

Future<List> getAllFeedbackList() async {
  var feedbackListResponse = await http.get(Uri.parse(
      "https://sgp-feedback-system.herokuapp.com/api/getfeedbacklist"));

  return jsonDecode(feedbackListResponse.body);
}
