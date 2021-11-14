import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class FacultyAnalyticsScreen extends StatefulWidget {
  const FacultyAnalyticsScreen(
      {Key? key,
      required this.title,
      required this.que,
      required this.analytics})
      : super(key: key);
  final String title;
  final List que;
  final List analytics;

  @override
  _FacultyAnalyticsScreenState createState() => _FacultyAnalyticsScreenState();
}

class _FacultyAnalyticsScreenState extends State<FacultyAnalyticsScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ...List.generate(
              widget.que.length,
              (index) => Container(
                    margin: EdgeInsets.only(bottom: 32.0),
                    child: SfCircularChart(
                      title: ChartTitle(
                          text: widget.que[index],
                          textStyle: TextStyle(fontWeight: FontWeight.bold)),
                      legend: Legend(
                          isVisible: true, position: LegendPosition.bottom),
                      series: _getDefaultPieSeries(widget.analytics[index]),
                    ),
                  ))
        ],
      ),
    );
  }

  List<PieSeries<FeedbackQueAndResponse, String>> _getDefaultPieSeries(
      Map<String, dynamic> analytic) {
    final List<FeedbackQueAndResponse> pieData = <FeedbackQueAndResponse>[
      FeedbackQueAndResponse(
          option: 'Completely Agree',
          response: analytic['1'],
          shortOption: 'C. Agree'),
      FeedbackQueAndResponse(
        option: 'Agree',
        shortOption: 'Agree',
        response: analytic['2'],
      ),
      FeedbackQueAndResponse(
        option: 'Neutral',
        shortOption: 'Neutral',
        response: analytic['3'],
      ),
      FeedbackQueAndResponse(
        option: 'Disagree',
        shortOption: 'Disagree',
        response: analytic['4'],
      ),
      FeedbackQueAndResponse(
        option: 'Completely Disagree',
        shortOption: 'C. Disagree',
        response: analytic['5'],
      ),
    ];
    return <PieSeries<FeedbackQueAndResponse, String>>[
      PieSeries<FeedbackQueAndResponse, String>(
          explode: false,
          explodeIndex: 0,
          explodeOffset: '10%',
          dataSource: pieData,
          xValueMapper: (FeedbackQueAndResponse data, _) =>
              data.option as String,
          yValueMapper: (FeedbackQueAndResponse data, _) => data.response,
          dataLabelMapper: (FeedbackQueAndResponse data, _) =>
              '${data.shortOption} ${data.response.toString()}',
          startAngle: 90,
          endAngle: 90,
          radius: '100%',
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            showZeroValue: false,
          )),
    ];
  }
}

class FeedbackQueAndResponse {
  final String? option;
  final int? response;
  final String? shortOption;

  const FeedbackQueAndResponse(
      {required this.option,
      required this.shortOption,
      required this.response});
}
