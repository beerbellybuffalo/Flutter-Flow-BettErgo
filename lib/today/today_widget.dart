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

  //Graph2 Stuff
  late List<SittData> infoData;
  late List<PostureTimingData> PostureTimingChartData;
  int timer_count =0;
  late String totalSittingTime;
  late String goodSittingTime;

  //Apple Graph Stuff
  final Random random = Random();
  int count_2 = 0;
  List<AppleGraphData> appleChartData = [];
  bool pressAttention1 = false;
  bool pressAttention2 = false;
  bool pressAttention3 = false;
  @override
  void initState() {
    appleChartData = data2;
    super.initState();
  }

  late Timer timer;
  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    infoData = getChartData();
    PostureTimingChartData = getPostureTimingChartData();

    timer = Timer(const Duration(seconds: 3), () {
      if (mounted)
        setState(() {
          infoData = getChartData();
          PostureTimingChartData = getPostureTimingChartData();
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
                  mainAxisAlignment: MainAxisAlignment.spaceAround, // initially spaceEvenly
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
                      textAlign: TextAlign.left,
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
                                  dataSource: infoData,
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
                              ),)],
                        ), // Total Sitting Time
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              'Good Sitting Time',
                              style: FlutterFlowTheme.bodyText1.override(
                                fontFamily: 'Poppins',
                                color: FlutterFlowTheme.secondaryColor,
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
                        ), // Good Sitting Time
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
                              ),)],)], // Position Change Frequency
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
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        child: SfCartesianChart(
                                          primaryXAxis: CategoryAxis(
                                              majorGridLines: MajorGridLines(width: 0),
                                              labelStyle: TextStyle(
                                                color: Colors.white38,
                                                fontFamily: 'Poppins'
                                          )),
                                          primaryYAxis: NumericAxis(
                                            maximum: 60,
                                            majorGridLines: MajorGridLines(width: 0),
                                            labelStyle: TextStyle(
                                              color: Colors.white38,
                                              fontFamily: 'Poppins'
                                            )
                                          ),
                                          title: ChartTitle(
                                              borderWidth: 5,
                                              alignment: ChartAlignment.near,
                                              text: 'Apple Graph',
                                              textStyle: TextStyle(
                                                color: Color(0xFFdfdfdf),
                                                fontSize: 10,
                                                fontFamily: 'Poppins',
                                              )
                                            ),
                                            backgroundColor: FlutterFlowTheme.darkGrey,
                                            series: <ChartSeries<AppleGraphData, String>>[
                                              StackedColumnSeries<AppleGraphData, String>(
                                                dataSource: appleChartData,
                                                xValueMapper: (AppleGraphData data, _) => data.x,
                                                yValueMapper: (AppleGraphData data, _) => data.y,
                                                borderWidth: 0.4,
                                                //borderColor: Colors.white54,
                                                //color: Color(0xFFdfdfdf),
                                                color: Color(0xFF00DBA3),
                                                name: 'Sales1',
                                              ),
                                              StackedColumnSeries<AppleGraphData, String>(
                                                dataSource: appleChartData,
                                                xValueMapper: (AppleGraphData data, _) => data.x,
                                                yValueMapper: (AppleGraphData data, _) => data.y2,
                                                //color: FlutterFlowTheme.darkGrey,
                                                color: Color(0xFFFF6B6B),
                                                borderWidth: 0.4,
                                                //borderColor: Colors.white54,
                                                name: 'Sales1',
                                              )
                                            ]),
                                      ),
                                    ),
                                    Container(
                                        // width: double.infinity,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.darkGrey,
                                        ),
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Center(
                                                child: MaterialButton(
                                                  height: 15,
                                                  minWidth: 100,
                                                  //color: Theme.of(context).primaryColor,
                                                  //textColor: Colors.black87,
                                                  child: Text(
                                                    'Material Button',
                                                    style: new TextStyle(
                                                      fontSize: 12.0,
                                                      fontFamily: 'Poppins',
                                                      // color: Theme.of(context).primaryColor,
                                                      color: pressAttention1 ? Colors.white : Colors.white70
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    if (2 == 0) {
                                                      appleChartData.clear();
                                                      appleChartData = data2;
                                                    } else {
                                                      appleChartData.clear();
                                                      appleChartData = getAppleChartData();
                                                    }
                                                    count_2++;
                                                    setState(() {
                                                      pressAttention1 = true;
                                                      pressAttention2 = false;
                                                      pressAttention3 = false;
                                                    }); // Set state
                                                  },
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Center(
                                                child: MaterialButton(
                                                  height: 15,
                                                  //minWidth: 100,
                                                  //color: Theme.of(context).primaryColor,
                                                  //textColor: Colors.black87,
                                                  child: Text(
                                                    'Material Button',
                                                    style: new TextStyle(
                                                      fontSize: 12.0,
                                                      fontFamily: 'Poppins',
                                                      color: pressAttention2 ? Colors.white : Colors.white70
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    if (count_2 == 0) {
                                                      appleChartData.clear();
                                                      appleChartData = data2;
                                                    } else {
                                                      appleChartData.clear();
                                                      appleChartData = getAppleChartData();
                                                    }
                                                    count_2++;
                                                    setState(() {
                                                      pressAttention1 = false;
                                                      pressAttention2 = true;
                                                      pressAttention3 = false;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Center(
                                                child: MaterialButton(
                                                  height: 15,
                                                  minWidth: 100,
                                                  //color: Theme.of(context).primaryColor,
                                                  //textColor: Colors.black87,
                                                  child: Text(
                                                    'Material Button',
                                                    style: new TextStyle(
                                                      fontSize: 12.0,
                                                      fontFamily: 'Poppins',
                                                      color: pressAttention3 ? Colors.white : Colors.white70
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    if (count_2 == 0) {
                                                      appleChartData.clear();
                                                      appleChartData = data2;
                                                    } else {
                                                      appleChartData.clear();
                                                      appleChartData = getAppleChartData();
                                                    }
                                                    count_2++;
                                                    setState(() {
                                                      pressAttention1 = false;
                                                      pressAttention2 = false;
                                                      pressAttention3 = true;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ))
                                  ],

                                )
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
                                  backgroundColor: FlutterFlowTheme.darkGrey,
                                  legend: Legend(isVisible: false),
                                  series: <ChartSeries>[
                                    StackedColumnSeries<PostureTimingData, String>(
                                      width: 0.5,
                                      dataSource: PostureTimingChartData,
                                      // animationDuration: 2500,
                                      xValueMapper: (PostureTimingData data, _) => data.postureCategory,
                                      yValueMapper: (PostureTimingData data, _) => data.green,
                                      name: 'p1',
                                      color: Color(0xFFFF6B6B),
                                    ),
                                    StackedColumnSeries<PostureTimingData, String>(
                                      width: 0.5,
                                      dataSource: PostureTimingChartData,
                                      // animationDuration: 2500,
                                      xValueMapper: (PostureTimingData data, _) => data.postureCategory,
                                      yValueMapper: (PostureTimingData data, _) => data.yellow,
                                      name: 'p2',
                                      color: Color(0xFFFFE66D),
                                    ),
                                    StackedColumnSeries<PostureTimingData, String>(
                                      width: 0.5,
                                      dataSource: PostureTimingChartData,
                                      // animationDuration: 2500,
                                      xValueMapper: (PostureTimingData data, _) => data.postureCategory,
                                      yValueMapper: (PostureTimingData data, _) => data.red,
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
      infoData = <SittData>[
        SittData('My Ass', 35, FlutterFlowTheme.naplesYellow),
        SittData('Second Ass', 40, Color(0xFF00DBA3)),
      ];
      totalSittingTime = '6hr 41min';
      goodSittingTime = '3hr 25min';
      timer_count++;
     } else if (timer_count == 1) {
      infoData = <SittData>[
        SittData('My Ass', 37, FlutterFlowTheme.naplesYellow),
        SittData('Second Ass', 45, Color(0xFF00DBA3)),
      ];
      totalSittingTime = '6hr 45min';
      goodSittingTime = '3hr 29min';
      timer_count++;
    } else if (timer_count == 2) {
      infoData = <SittData>[
        SittData('My Ass', 40, FlutterFlowTheme.naplesYellow),
        SittData('Second Ass', 50, Color(0xFF00DBA3)),
      ];//2413
      totalSittingTime = '6hr 50min';
      goodSittingTime = '3hr 32min';
      timer_count++;
    } else if (timer_count == 3) {
      infoData = <SittData>[
        SittData('My Ass', 45, FlutterFlowTheme.bittersweetRed),
        SittData('Second Ass', 55, Color(0xFF00DBA3)),
      ];
      totalSittingTime = '7hr 05min';
      goodSittingTime = '3hr 44min';
      timer_count++;
    }
     else if (timer_count == 4) {
      infoData = <SittData>[
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
    return infoData;
  }

  List<PostureTimingData> getPostureTimingChartData() {
    if (timer_count == 0) {
      PostureTimingChartData = <PostureTimingData>[
        PostureTimingData('P1', 15, 0, 13),
        PostureTimingData('P2', 3, 0, 4),
        PostureTimingData('P3', 0, 0, 0),
        PostureTimingData('P4', 0, 0, 0),
        PostureTimingData('P5', 13, 2, 0),
        PostureTimingData('P6', 0, 0, 0),
        PostureTimingData('P7', 0, 5, 0),
        PostureTimingData('P8', 0, 1, 0),

      ];
      timer_count++;
    } else if (timer_count == 1) {
      PostureTimingChartData = <PostureTimingData>[
        PostureTimingData('P1', 15, 4, 6),
        PostureTimingData('P2', 3, 0, 4),
        PostureTimingData('P3', 0, 0, 0),
        PostureTimingData('P4', 0, 0, 0),
        PostureTimingData('P5', 13, 2, 5),
        PostureTimingData('P6', 0, 0, 0),
        PostureTimingData('P7', 0, 8, 0),
        PostureTimingData('P8', 0, 5, 0),
      ];
      timer_count++;
    } else if (timer_count == 2) {
      PostureTimingChartData = <PostureTimingData>[
        PostureTimingData('P1', 21, 4, 6),
        PostureTimingData('P2', 3, 0, 4),
        PostureTimingData('P3', 2, 0, 0),
        PostureTimingData('P4', 0, 0, 0),
        PostureTimingData('P5', 13, 10, 5),
        PostureTimingData('P6', 0, 0, 0),
        PostureTimingData('P7', 0, 12, 0),
        PostureTimingData('P8', 0, 5, 3),
      ];
      timer_count = 0;
    }
    return PostureTimingChartData;
  }

  List<AppleGraphData> data2 = [
    AppleGraphData(x: '1', y: 5, y2: 55),
    AppleGraphData(x: '2', y: 10, y2: 50),
    AppleGraphData(x: '3', y: 15, y2: 45),
    AppleGraphData(x: '4', y: 20, y2: 40),
    AppleGraphData(x: '5', y: 25, y2: 35),
    AppleGraphData(x: '6', y: 30, y2: 30),
    AppleGraphData(x: '7', y: 35, y2: 25),
    AppleGraphData(x: '8', y: 40, y2: 20),
    AppleGraphData(x: '9', y: 45, y2: 15),
    AppleGraphData(x: '10', y: 50, y2: 10),
    AppleGraphData(x: '11', y: 55, y2: 5),
    AppleGraphData(x: '12', y: 60, y2: 0),
    AppleGraphData(x: '13', y: 55, y2: 5),
    AppleGraphData(x: '14', y: 50, y2: 10),
    AppleGraphData(x: '15', y: 45, y2: 15),
    AppleGraphData(x: '16', y: 40, y2: 20),
    AppleGraphData(x: '17', y: 35, y2: 25),
    AppleGraphData(x: '18', y: 30, y2: 30),
    AppleGraphData(x: '19', y: 25, y2: 35),
    AppleGraphData(x: '20', y: 20, y2: 40),
    AppleGraphData(x: '21', y: 15, y2: 45),
    AppleGraphData(x: '22', y: 10, y2: 50),
    AppleGraphData(x: '23', y: 5, y2: 55),
    AppleGraphData(x: '24', y: 0, y2: 60), ];

  double _getRandomValue(int min, int max) {
    return min + random.nextInt(max - min).toDouble();
  }

  List<AppleGraphData> getAppleChartData() {
    appleChartData.add(AppleGraphData(
        x: '1', y: _getRandomValue(0, 30), y2: _getRandomValue(2, 15)));
    appleChartData.add(AppleGraphData(
        x: '2', y: _getRandomValue(0, 30), y2: _getRandomValue(2, 15)));
    appleChartData.add(AppleGraphData(
        x: '3', y: _getRandomValue(0, 30), y2: _getRandomValue(2, 15)));
    appleChartData.add(AppleGraphData(
        x: '4', y: _getRandomValue(0, 30), y2: _getRandomValue(2, 15)));
    appleChartData.add(AppleGraphData(
        x: '5', y: _getRandomValue(0, 30), y2: _getRandomValue(2, 15)));
    appleChartData.add(AppleGraphData(
        x: '6', y: _getRandomValue(0, 30), y2: _getRandomValue(2, 15)));
    appleChartData.add(AppleGraphData(
        x: '7', y: _getRandomValue(0, 30), y2: _getRandomValue(2, 15)));
    appleChartData.add(AppleGraphData(
        x: '8', y: _getRandomValue(0, 30), y2: _getRandomValue(2, 15)));
    appleChartData.add(AppleGraphData(
        x: '9', y: _getRandomValue(0, 30), y2: _getRandomValue(2, 15)));
    appleChartData.add(AppleGraphData(
        x: '10', y: _getRandomValue(0, 30), y2: _getRandomValue(2, 15)));
    appleChartData.add(AppleGraphData(
        x: '11', y: _getRandomValue(0, 30), y2: _getRandomValue(2, 15)));
    appleChartData.add(AppleGraphData(
        x: '12', y: _getRandomValue(0, 30), y2: _getRandomValue(2, 15)));
    appleChartData.add(AppleGraphData(
        x: '13', y: _getRandomValue(0, 30), y2: _getRandomValue(2, 15)));
    appleChartData.add(AppleGraphData(
        x: '14', y: _getRandomValue(0, 30), y2: _getRandomValue(2, 15)));
    appleChartData.add(AppleGraphData(
        x: '15', y: _getRandomValue(0, 30), y2: _getRandomValue(2, 15)));
    appleChartData.add(AppleGraphData(
        x: '16', y: _getRandomValue(0, 30), y2: _getRandomValue(2, 15)));
    appleChartData.add(AppleGraphData(
        x: '17', y: _getRandomValue(0, 30), y2: _getRandomValue(2, 15)));
    appleChartData.add(AppleGraphData(
        x: '18', y: _getRandomValue(0, 30), y2: _getRandomValue(2, 15)));
    appleChartData.add(AppleGraphData(
        x: '19', y: _getRandomValue(0, 30), y2: _getRandomValue(2, 15)));
    appleChartData.add(AppleGraphData(
        x: '20', y: _getRandomValue(0, 30), y2: _getRandomValue(2, 15)));
    appleChartData.add(AppleGraphData(
        x: '21', y: _getRandomValue(0, 30), y2: _getRandomValue(2, 15)));
    appleChartData.add(AppleGraphData(
        x: '22', y: _getRandomValue(0, 30), y2: _getRandomValue(2, 15)));
    appleChartData.add(AppleGraphData(
        x: '23', y: _getRandomValue(0, 30), y2: _getRandomValue(2, 15)));
    appleChartData.add(AppleGraphData(
        x: '24', y: _getRandomValue(0, 30), y2: _getRandomValue(2, 15)));

    return appleChartData;
  }


}



class SittData {
  SittData(this.name, this.data,this.pointColour);
  final String name;
  final int data;
  final Color pointColour;
}

class PostureTimingData {
  PostureTimingData( this.postureCategory, this.green, this.yellow, this.red);
  final String postureCategory;
  final num green;
  final num yellow;
  final num red;
}

class AppleGraphData {
  AppleGraphData({this.x, this.y, this.y2});
  final String? x;
  final double? y;
  final double? y2;
}