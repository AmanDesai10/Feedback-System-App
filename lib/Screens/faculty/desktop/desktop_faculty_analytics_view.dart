import 'package:feedsys/Screens/student/student_profile.dart';
import 'package:feedsys/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DesktopFacultyAnalyticsScreen extends StatefulWidget {
  const DesktopFacultyAnalyticsScreen(
      {Key? key,
      required this.title,
      required this.que,
      required this.analytics})
      : super(key: key);
  final String title;
  final List que;
  final List analytics;

  @override
  _DesktopFacultyAnalyticsScreenState createState() =>
      _DesktopFacultyAnalyticsScreenState();
}

class _DesktopFacultyAnalyticsScreenState
    extends State<DesktopFacultyAnalyticsScreen> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 15.0,
            runSpacing: 10.0,
            children: [
              ...List.generate(widget.que.length, (index) {
                TooltipBehavior _toolTip = TooltipBehavior(
                    enable: true,
                    color: kWhite,
                    duration: 1.0,
                    textStyle: const TextStyle(color: Colors.black));
                return Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: kPrimary),
                      color: kBackgroundColor),
                  width: size.width * 0.29,
                  height: size.height * 0.55,
                  margin: EdgeInsets.only(bottom: 32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TitleText(
                          text: widget.que[index],
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Expanded(
                        child: SfCircularChart(
                          tooltipBehavior: _toolTip,
                          palette: [
                            Color.fromRGBO(255, 99, 132, 0.1),
                            Color.fromRGBO(54, 162, 235, 0.1),
                            Color.fromRGBO(255, 206, 86, 1),
                            Color.fromRGBO(75, 192, 192, 1),
                            Color.fromRGBO(153, 102, 255, 1)
                          ],
                          legend: Legend(
                              isVisible: true,
                              position: LegendPosition.bottom,
                              overflowMode: LegendItemOverflowMode.wrap),
                          series: _getDefaultPieSeries(widget.analytics[index]),
                        ),
                      ),
                    ],
                  ),
                );
              })
            ],
          ),
        ),
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
          enableTooltip: true,
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
