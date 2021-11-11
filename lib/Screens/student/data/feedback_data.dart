class FeedbackData {
  const FeedbackData(
      {required this.title, this.date, this.imgurl, required this.feedbackId});

  final String title;
  final int? date;
  final String? imgurl;
  final String? feedbackId;
}
