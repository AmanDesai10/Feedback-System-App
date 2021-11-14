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
