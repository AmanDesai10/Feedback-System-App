class FeedbackDetails {
  final String? name;
  final String? institute;
  final String? department;
  final int? sem;
  final int? year;
  final String? questionTemplateId;
  final String? questionTemplate;
  final String? description;
  final String? feedbackOf;
  final String? startDate;
  final String? endDate;
  final String? id;
  final String? createdBy;

  const FeedbackDetails(
      {required this.name,
      required this.institute,
      required this.department,
      required this.sem,
      required this.year,
      required this.questionTemplateId,
      required this.questionTemplate,
      required this.description,
      required this.feedbackOf,
      required this.startDate,
      required this.endDate,
      required this.id,
      this.createdBy});
}
