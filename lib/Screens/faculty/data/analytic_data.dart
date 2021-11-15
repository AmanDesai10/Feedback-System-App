class FeedBack {
  final String? title;
  final String? description;

  const FeedBack({required this.title, required this.description});
}

class FeedbackAnalytics {
  final String feedbackOf;
  final List? analytic;
  final List? que;

  FeedbackAnalytics({this.que, this.analytic, required this.feedbackOf});
}

class Courses {
  final String id;
  final String name;
  final String code;

  Courses({required this.id, required this.name, required this.code});
}
