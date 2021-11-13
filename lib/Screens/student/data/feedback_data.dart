class FeedbackData {
  const FeedbackData(
      {required this.title,
      this.days,
      this.imgurl,
      required this.feedbackId,
      required this.desc,
      required this.createdBy});

  final String title;
  final int? days;
  final String createdBy;
  final String desc;
  final String? imgurl;
  final String? feedbackId;
}
