import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class FacultyAnalyticsScreen extends StatefulWidget {
  const FacultyAnalyticsScreen({Key? key, required this.title})
      : super(key: key);
  final String title;

  @override
  _FacultyAnalyticsScreenState createState() => _FacultyAnalyticsScreenState();
}

class _FacultyAnalyticsScreenState extends State<FacultyAnalyticsScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: SfCircularChart(
            title: ChartTitle(text: widget.title),
            legend: Legend(isVisible: true, position: LegendPosition.bottom),
            series: _getDefaultPieSeries(),
          ),
        )
      ],
    );
  }

  List<PieSeries<FeedbackQueAndResponse, String>> _getDefaultPieSeries() {
    final List<FeedbackQueAndResponse> pieData = <FeedbackQueAndResponse>[
      FeedbackQueAndResponse(
        option: 'Completely Agree',
        response: 13,
      ),
      FeedbackQueAndResponse(
        option: 'Agree',
        response: 24,
      ),
      FeedbackQueAndResponse(
        option: 'Neutral',
        response: 25,
      ),
      FeedbackQueAndResponse(
        option: 'Disagree',
        response: 38,
      ),
      FeedbackQueAndResponse(
        option: 'CompletelyDisagree',
        response: 38,
      ),
    ];
    return <PieSeries<FeedbackQueAndResponse, String>>[
      PieSeries<FeedbackQueAndResponse, String>(
          explode: true,
          explodeIndex: 0,
          explodeOffset: '10%',
          dataSource: pieData,
          xValueMapper: (FeedbackQueAndResponse data, _) =>
              data.option as String,
          yValueMapper: (FeedbackQueAndResponse data, _) => data.response,
          startAngle: 90,
          endAngle: 90,
          radius: '100%',
          dataLabelSettings: const DataLabelSettings(isVisible: true)),
    ];
  }
}

class FeedbackQueAndResponse {
  final String? option;
  final int? response;

  const FeedbackQueAndResponse({required this.option, required this.response});
}
