class FeedbackDetails {
  final String? name;
  final String? institute;
  final String? department;
  final int? sem;
  final int? year;
  final String? questionTemplate;
  final String? description;
  final String? feedbackOf;
  final String? startDate;
  final String? endDate;

  const FeedbackDetails({
    required this.name,
    required this.institute,
    required this.department,
    required this.sem,
    required this.year,
    required this.questionTemplate,
    required this.description,
    required this.feedbackOf,
    required this.startDate,
    required this.endDate,
  });
}
