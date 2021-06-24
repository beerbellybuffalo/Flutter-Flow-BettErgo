import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';
import 'dart:math';

class TodayWidget extends StatefulWidget {
  TodayWidget({Key key}) : super(key: key);

  @override
  _TodayWidgetState createState() => _TodayWidgetState();
}

class _TodayWidgetState extends State<TodayWidget> {
  final pageViewController = PageController();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  //Graph Stuff
  List<SittData> chartData;
  int _count =0;
  String totalSittingTime;
  String goodSittingTime;

  Timer timer;
  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    chartData = getChartData();

    timer = Timer(const Duration(seconds: 3), () {
      if (mounted)
        setState(() {
          chartData = getChartData();
          // text file update text to another time
          updateString();
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
                      'Hello, Friendo',
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
                              annotations: <CircularChartAnnotation>[
                                CircularChartAnnotation(
                                    widget: Container(
                                      child: const Text("Graph",
                                          style: TextStyle(
                                              color: Color.fromRGBO(0, 0, 0, 0.5), fontSize: 16)),
                                    ))
                              ],

                              // legend: Legend(
                              //     isVisible: true,
                              //     overflowMode: LegendItemOverflowMode.wrap,
                              //     toggleSeriesVisibility: true,
                              //     borderColor: Colors.white,
                              //     borderWidth: 0),

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
                                child: Image.asset(
                                  'assets/images/Total Sitting Minutes.png',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Card(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              color: FlutterFlowTheme.darkGrey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            )
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment(0, 0.9),
                        child: SmoothPageIndicator(
                          controller: pageViewController,
                          count: 3,
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
                                'assets/images/upright.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(),
                              child: Image.asset(
                                'assets/images/leanback.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(),
                              child: Image.asset(
                                'assets/images/leanforward.png',
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
    if (_count == 0){
      totalSittingTime = '5hr 41min';
      goodSittingTime = '3hr 25min';
    } else if (_count == 1){
      totalSittingTime = '5hr 42min';
      goodSittingTime = '3hr 26min';
    } else if (_count == 2){
      totalSittingTime = '5hr 43min';
      goodSittingTime = '3hr 27min';
    } else if (_count == 3){
      totalSittingTime = '5hr 44min';
      goodSittingTime = '3hr 28min';
    }
    return totalSittingTime;
  }

  List<SittData> getChartData() {
    if (_count == 0) {
      chartData = <SittData>[
        SittData('My Ass', 35, Color(0xFF1A535C)),
        SittData('Second Ass', 40, Color(0xFF00DBA3)),// 1
      ];
      _count++;
    } else if (_count == 1) {
      chartData = <SittData>[
        SittData('My Ass', 50, Color(0xFF1A535C)),
        SittData('Second Ass', 70, Color(0xFF00DBA3)),// 4
      ];
      _count++;
    } else if (_count == 2) {
      chartData = <SittData>[
        SittData('My Ass', 40, Color(0xFF1A535C)),
        SittData('Second Ass', 50, Color(0xFF00DBA3)),// 2
      ];//2413
      _count++;
    } else if (_count == 3) {
      chartData = <SittData>[
        SittData('My Ass', 55, Color(0xFF1A535C)),
        SittData('Second Ass', 80, Color(0xFF00DBA3)),// 5
      ];
      _count++;
    } else if (_count == 4) {
      chartData = <SittData>[
        SittData('My Ass', 45, Color(0xFF1A535C)),
        SittData('Second Ass', 60, Color(0xFF00DBA3)),// 3
      ];
      _count = 0;
    }
    // if (timer != null) {
    //   timer!.cancel();
    // }
    return chartData;
  }

}

class SittData {
  SittData(this.name, this.data,this.pointColour);
  final String name;
  final int data;
  final Color pointColour;
}