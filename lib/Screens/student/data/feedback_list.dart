import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<List> getFeedbackList() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String? id = preferences.getString('_id');
  String? token = preferences.getString('token');

  var UserResponse = await http.get(
      Uri.parse("https://sgp-feedback-system.herokuapp.com/api/user?id=$id"),
      headers: {'Authorization': 'Bearer $token'});
  String institute = jsonDecode(UserResponse.body)['institute'];
  String dept = jsonDecode(UserResponse.body)['department'];
  int sem = jsonDecode(UserResponse.body)['sem'];

  var feedbackListResponse = await http.get(
      Uri.parse(
          "https://sgp-feedback-system.herokuapp.com/api/getfeedbacklist?institute=$institute&department=$dept&sem=$sem"),
      headers: {'Authorization': 'Bearer $token'});

  return jsonDecode(feedbackListResponse.body);
}

Future<List> getAllFeedbackList() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String? token = preferences.getString('token');
  var feedbackListResponse = await http.get(
      Uri.parse(
          "https://sgp-feedback-system.herokuapp.com/api/getfeedbacklist"),
      headers: {'Authorization': 'Bearer $token'});

  return jsonDecode(feedbackListResponse.body);
}
