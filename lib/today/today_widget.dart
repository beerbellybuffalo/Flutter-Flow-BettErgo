import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:better_sitt/today/today_classes.dart';

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';
import 'dart:math';

class TodayWidget extends StatefulWidget {
  TodayWidget({Key? key}) : super(key: key);

  @override
  _TodayWidgetState createState() => _TodayWidgetState();
}

class _TodayWidgetState extends State<TodayWidget> {
  final pageViewController = PageController();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  //Graph Stuff
  late List<SittData> chartData;
  late List<PositionBarData> barChartData;
  int timer_count =0;
  late String totalSittingTime;
  late String goodSittingTime;

  late Timer timer;
  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    chartData = getChartData();
    barChartData = getBarChartData();

    timer = Timer(const Duration(seconds: 3), () {
      if (mounted)
        setState(() {
          chartData = getChartData();
          barChartData = getBarChartData();
          // text file update text to another time
          //updateString();
        });
    });

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.darkGrey,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                    topLeft: Radius.circular(0),
                    topRight: Radius.circular(0),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 76,
                      height: 76,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        'assets/images/UI_avatar@2x.png',
                      ),
                    ),
                    AutoSizeText(
                      'Hello, Bob',
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.title3.override(
                        fontFamily: 'Poppins',
                        fontSize: 40,
                        fontWeight: FontWeight.normal,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.25,
                decoration: BoxDecoration(),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.35,
                      decoration: BoxDecoration(),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Today\'s Score:',
                            style: FlutterFlowTheme.bodyText1.override(
                              fontFamily: 'Poppins',
                            ),
                          ),
                          // Padding(
                          //   padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          // ),
                          Container(
                            height: MediaQuery.of(context).size.width * 0.35,
                            width: MediaQuery.of(context).size.width * 0.35,
                            child: SfCircularChart(
                              series: <CircularSeries>[
                                RadialBarSeries<SittData, String>(
                                  dataSource: chartData,
                                  xValueMapper: (SittData data, _) => data.name,
                                  yValueMapper: (SittData data, _) => data.data,
                                  pointColorMapper: (SittData data, _) => data.pointColour,
                                  maximumValue: 100,
                                  innerRadius: '60%',
                                  cornerStyle: CornerStyle.bothCurve,
                                  trackColor: Color(0xFF181819)
                                  //dataLabelSettings: DataLabelSettings(isVisible: true)
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Sitting Time',
                              style: FlutterFlowTheme.bodyText1.override(
                                fontFamily: 'Poppins',
                              ),
                            ),
                            Text(
                              '$totalSittingTime',
                              style: FlutterFlowTheme.title1.override(
                                fontFamily: 'Poppins',
                                color: FlutterFlowTheme.tertiaryColor,
                                fontSize: 22,
                                fontWeight: FontWeight.normal,
                              ),
                            )
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              'Good Sitting Time',
                              style: FlutterFlowTheme.bodyText1.override(
                                fontFamily: 'Poppins',
                              ),
                            ),
                            Text(
                              '$goodSittingTime',
                              style: FlutterFlowTheme.bodyText1.override(
                                fontFamily: 'Poppins',
                                color: FlutterFlowTheme.secondaryColor,
                                fontSize: 22,
                                fontWeight: FontWeight.normal,
                              ),
                            )
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              'Position Change Frequency',
                              style: FlutterFlowTheme.bodyText1.override(
                                fontFamily: 'Poppins',
                              ),
                            ),
                            Text(
                              '48m',
                              style: FlutterFlowTheme.bodyText1.override(
                                fontFamily: 'Poppins',
                                fontSize: 22,
                                fontWeight: FontWeight.normal,
                              ),
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.3,
                decoration: BoxDecoration(),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
                        child: PageView(
                          controller: pageViewController,
                          scrollDirection: Axis.horizontal,
                          children: [
                            Card(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.asset(
                                  'assets/images/Daily Posture Card.png',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Card(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: SfCartesianChart(
                                  title: ChartTitle(
                                      borderWidth: 20,
                                      alignment: ChartAlignment.near,
                                      text: 'Posture Timing in Mins',
                                      textStyle: TextStyle(
                                        color: Color(0xFFdfdfdf),
                                        fontSize: 10,
                                        fontFamily: 'Poppins',
                                      )
                                  ),
                                  backgroundColor: Color(0xFF545454),
                                  legend: Legend(isVisible: false),
                                  series: <ChartSeries>[
                                    StackedColumnSeries<PositionBarData, String>(
                                      dataSource: barChartData,
                                      //animationDuration: 1000,
                                      xValueMapper: (PositionBarData data, _) => data.expenseCategory,
                                      yValueMapper: (PositionBarData data, _) => data.green,
                                      name: 'p1',
                                      color: Color(0xFFFF6B6B),
                                    ),
                                    StackedColumnSeries<PositionBarData, String>(
                                      dataSource: barChartData,
                                      //animationDuration: 1000,
                                      xValueMapper: (PositionBarData data, _) => data.expenseCategory,
                                      yValueMapper: (PositionBarData data, _) => data.yellow,
                                      name: 'p2',
                                      color: Color(0xFFFFE66D),
                                    ),
                                    StackedColumnSeries<PositionBarData, String>(
                                      dataSource: barChartData,
                                      //animationDuration: 1000,
                                      xValueMapper: (PositionBarData data, _) => data.expenseCategory,
                                      yValueMapper: (PositionBarData data, _) => data.red,
                                      color: Color(0xFF00DBA3),
                                      name: 'p3',
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(3),
                                          topRight: Radius.circular(3)),
                                    ),
                                  ],
                                  primaryXAxis: CategoryAxis(
                                      labelStyle: TextStyle(
                                          color: Colors.white38,
                                          fontFamily: 'Poppins',
                                          fontSize: 12,
                                          //fontStyle: FontStyle.italic,
                                          //fontWeight: FontWeight.w500
                                      )
                                  ),
                                  primaryYAxis: CategoryAxis(
                                      labelStyle: TextStyle(
                                        color: Colors.white38,
                                        fontFamily: 'Poppins',
                                        fontSize: 10,
                                        //fontStyle: FontStyle.italic,
                                        //fontWeight: FontWeight.w500
                                      )
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment(0, 0.9),
                        child: SmoothPageIndicator(
                          controller: pageViewController,
                          count: 2,
                          axisDirection: Axis.horizontal,
                          onDotClicked: (i) {
                            pageViewController.animateToPage(
                              i,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.ease,
                            );
                          },
                          effect: ExpandingDotsEffect(
                            expansionFactor: 2,
                            spacing: 8,
                            radius: 16,
                            dotWidth: 14,
                            dotHeight: 14,
                            dotColor: Color(0xFF9E9E9E),
                            activeDotColor: FlutterFlowTheme.tertiaryColor,
                            paintStyle: PaintingStyle.fill,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  color: FlutterFlowTheme.darkGrey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 1, 0, 0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 1, 0, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Top 3 Positions Today',
                                  style: FlutterFlowTheme.bodyText1.override(
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                Icon(
                                  Icons.info,
                                  color: FlutterFlowTheme.tertiaryColor,
                                  size: 24,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(),
                              child: Image.asset(
                                'assets/images/posture-yyy.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(),
                              child: Image.asset(
                                'assets/images/posture-nny.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(),
                              child: Image.asset(
                                'assets/images/posture-nyn.png',
                                fit: BoxFit.contain,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  color: FlutterFlowTheme.darkGrey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            'Congrats!',
                            textAlign: TextAlign.start,
                            style: FlutterFlowTheme.title3.override(
                              fontFamily: 'Poppins',
                              fontSize: 22,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    'Your Sitting Habits have improved',
                                    style: FlutterFlowTheme.bodyText1.override(
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  Text(
                                    '12%',
                                    style: FlutterFlowTheme.bodyText2.override(
                                      fontFamily: 'Poppins',
                                      fontSize: 22,
                                    ),
                                  ),
                                  Text(
                                    'since Yesterday',
                                    style: FlutterFlowTheme.bodyText1.override(
                                      fontFamily: 'Poppins',
                                      color: FlutterFlowTheme.tertiaryColor,
                                    ),
                                  )
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Learn more about good sitting habits',
                            style: FlutterFlowTheme.bodyText1.override(
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            ' here',
                            style: FlutterFlowTheme.bodyText1.override(
                              fontFamily: 'Poppins',
                              color: FlutterFlowTheme.secondaryColor,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String updateString(){
    if (timer_count == 0){
      totalSittingTime = '6hr 45min';
      goodSittingTime = '3hr 25min';
    } else if (timer_count == 1){
      totalSittingTime = '7hr 03min';
      goodSittingTime = '3hr 43min';
    } else if (timer_count == 2){
      totalSittingTime = '7hr 15min';
      goodSittingTime = '3hr 55min';
    // } else if (timer_count == 3){
    //   totalSittingTime = '5hr 44min';
    //   goodSittingTime = '3hr 28min';
    }
    return totalSittingTime;
  }

  List<SittData> getChartData() {
    if (timer_count == 0) {
      chartData = <SittData>[
        SittData('My Ass', 35, FlutterFlowTheme.naplesYellow),
        SittData('Second Ass', 40, Color(0xFF00DBA3)),
      ];
      totalSittingTime = '6hr 41min';
      goodSittingTime = '3hr 25min';
      timer_count++;
     } else if (timer_count == 1) {
      chartData = <SittData>[
        SittData('My Ass', 37, FlutterFlowTheme.naplesYellow),
        SittData('Second Ass', 45, Color(0xFF00DBA3)),
      ];
      totalSittingTime = '6hr 45min';
      goodSittingTime = '3hr 29min';
      timer_count++;
    } else if (timer_count == 2) {
      chartData = <SittData>[
        SittData('My Ass', 40, FlutterFlowTheme.naplesYellow),
        SittData('Second Ass', 50, Color(0xFF00DBA3)),
      ];//2413
      totalSittingTime = '6hr 50min';
      goodSittingTime = '3hr 32min';
      timer_count++;
    } else if (timer_count == 3) {
      chartData = <SittData>[
        SittData('My Ass', 45, FlutterFlowTheme.bittersweetRed),
        SittData('Second Ass', 55, Color(0xFF00DBA3)),
      ];
      totalSittingTime = '7hr 05min';
      goodSittingTime = '3hr 44min';
      timer_count++;
    }
     else if (timer_count == 4) {
      chartData = <SittData>[
        SittData('My Ass', 50, Color(0xFFFF6B6B)),
        SittData('Second Ass', 60, Color(0xFF00DBA3)),
      ];
      totalSittingTime = '7hr 20min';
      goodSittingTime = '3hr 53min';
      timer_count = 0;
    }
    // if (timer != null) {
    //   timer.cancel();
    // }
    return chartData;
  }

  List<PositionBarData> getBarChartData() {
    if (timer_count == 0) {
      barChartData = <PositionBarData>[
        PositionBarData('P1', 15, 0, 13),
        PositionBarData('P2', 3, 0, 4),
        PositionBarData('P3', 0, 0, 0),
        PositionBarData('P4', 0, 0, 0),
        PositionBarData('P5', 13, 2, 0),
        PositionBarData('P6', 0, 0, 0),
        PositionBarData('P7', 0, 5, 0),
        PositionBarData('P8', 0, 1, 0),

      ];
      timer_count++;
    } else if (timer_count == 1) {
      barChartData = <PositionBarData>[
        PositionBarData('P1', 15, 4, 6),
        PositionBarData('P2', 3, 0, 4),
        PositionBarData('P3', 0, 0, 0),
        PositionBarData('P4', 0, 0, 0),
        PositionBarData('P5', 13, 2, 5),
        PositionBarData('P6', 0, 0, 0),
        PositionBarData('P7', 0, 8, 0),
        PositionBarData('P8', 0, 5, 0),
      ];
      timer_count++;
    } else if (timer_count == 2) {
      barChartData = <PositionBarData>[
        PositionBarData('P1', 21, 4, 6),
        PositionBarData('P2', 3, 0, 4),
        PositionBarData('P3', 2, 0, 0),
        PositionBarData('P4', 0, 0, 0),
        PositionBarData('P5', 13, 10, 5),
        PositionBarData('P6', 0, 0, 0),
        PositionBarData('P7', 0, 12, 0),
        PositionBarData('P8', 0, 5, 3),
      ];
      timer_count = 0;
    }
    return barChartData;
  }

}



class SittData {
  SittData(this.name, this.data,this.pointColour);
  final String name;
  final int data;
  final Color pointColour;
}

class PositionBarData {
  PositionBarData( this.expenseCategory, this.green, this.yellow, this.red);
  final String expenseCategory;
  final num green;
  final num yellow;
  final num red;

}