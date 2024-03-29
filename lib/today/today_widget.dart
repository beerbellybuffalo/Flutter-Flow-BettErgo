import 'dart:convert';
import 'dart:developer';

import 'package:better_sitt/model/rings.dart';
import 'package:better_sitt/model/visualisation_data.dart';
import 'package:better_sitt/utils/positions_processing.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:better_sitt/today/today_classes.dart';
import 'package:better_sitt/bluetooth/bluetooth_widget.dart';
import 'package:better_sitt/utils/boxes.dart';

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
  
  //DECLARING GLOBAL VARIABLES
  final pageViewController = PageController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String DayDate = DateFormat('MMM d').format(DateTime.now()).toString();
  //var to store Username from sharedprefs
  String? username;
  var table3 = Boxes.getVisualisationDataBox();

  //PostureGraph Stuff
  List<PostureTimingData> PostureTimingChartData = [];
  List<SittData> ringsData = [];
  //int timer_count =0;
  String totalSittingTime = "";
  String goodSittingTime = "";
  String postureChangeFrequency = "";
  double innerRing = 0;
  double outerRing = 0;

  //For top 3 positions
  //late List<String> postureImages;
  String top1PosImg = "assets/images/posture-0.png";
  String top2PosImg = "assets/images/posture-0.png";
  String top3PosImg = "assets/images/posture-0.png";

  Map<int,dynamic> imageDirectoriesMap = {
    0: 'assets/images/posture-0.png',
    1: 'assets/images/posture-1.png',
    2: 'assets/images/posture-2.png',
    3: 'assets/images/posture-3.png',
    4: 'assets/images/posture-4.png',
    5: 'assets/images/posture-5.png',
    6: 'assets/images/posture-6.png',
    7: 'assets/images/posture-7.png',
    8: 'assets/images/posture-8.png',
    9: 'assets/images/posture-9.png',
    10: 'assets/images/posture-10.png',
    11: 'assets/images/posture-11.png',
    12: 'assets/images/posture-12.png',
    13: 'assets/images/posture-13.png',
    14: 'assets/images/posture-14.png',
    15: 'assets/images/posture-15.png',
    16: 'assets/images/posture-16.png',
    17: 'assets/images/posture-17.png',
    18: 'assets/images/posture-18.png',
  };

  //TODO remove this after finish implementing apple
  //Apple Graph Stuff
  // final Random random = Random();
  // int count_2 = 0;
  List<AppleGraphData> appleChartData = [];
  bool pressAttention1 = true;
  bool pressAttention2 = false;
  bool pressAttention3 = false;

  //South of the border
  HiveRings yestRings = new HiveRings();
  HiveRings todayRings = new HiveRings();
  late String comparisonMessage;
  late String salutation;
  String percentageChange = "-";


  @override
  void initState() {
    //_initPostureImages();
    //set rings and graphs

    setState(() {
      getVisualisationData(table3.length-1).then((latestData) async {
        appleChartData = getAppleChartData(latestData!);
        ringsData = getRingsData(latestData!);
        PostureTimingChartData = getPostureTimingChartData(latestData!);
      });
    });

    // timer = Timer(const Duration(seconds: 3), () {
    //   if (mounted)
    //     setState(() {
    //       ringsData = getRingsData();
    //       PostureTimingChartData = getPostureTimingChartData();
    //       // text file update text to another time
    //       //updateString();
    //     });
    // });


    //set username
    getUsername().then((value) { setState(() {
      username = value;
    }); });
    //set today's posture graph information
    setState(() {
      if (table3.length>2){
        // try {
          top1PosImg = imageDirectoriesMap[table3
              .getAt(table3.length - 1)!
              .postureGraph
              .topThreePositions[0]] ?? 'assets/images/posture-0.png';
          top2PosImg = imageDirectoriesMap[table3
              .getAt(table3.length - 1)!
              .postureGraph
              .topThreePositions[1]] ?? 'assets/images/posture-0.png';
          top3PosImg = imageDirectoriesMap[table3
              .getAt(table3.length - 1)!
              .postureGraph
              .topThreePositions[2]] ?? 'assets/images/posture-0.png';
          todayRings = table3.getAt(table3.length - 1)!.rings;
          yestRings = table3.getAt(table3.length - 2)!.rings;
      //   }catch(e){
      //     print(e);
      //     log(table3.length - 1);
      //     log(getAt)
      //
      // }
      }
    });
    //set the comparison widget
    setState(() {
      percentageChange = getPercentageChange(yestRings, todayRings).abs().toString();
      setSalutation(getPercentageChange(yestRings, todayRings));
      setComparisonMessage(getPercentageChange(yestRings, todayRings));
    });

    // getVisualisationData(Boxes.getVisualisationDataBox().length-1).then((data) {top1Pos = data!.postureGraph.topThreePositions[0];
    //                                                                             top2Pos = data.postureGraph.topThreePositions[1];
    //                                                                             top3Pos = data.postureGraph.topThreePositions[2];
    //                                                                             todayRings = data.rings;});
    super.initState();
  }
  void setComparisonMessage(int _percentChange) {
    if (_percentChange<0){
      //return worsened message
      comparisonMessage = 'Your Sitting Habits have worsened';
    }
    else if (_percentChange>=0){
      //return improved message
      comparisonMessage = 'Your Sitting Habits have improved';
    }
  }

  void setSalutation(int _percentChange) {
    if (_percentChange<0){
      //return bad salutation
      salutation = 'Oops...';
    }
    else if (_percentChange>=0){
      //return good salutation
      salutation = 'Congrats!';
    }
  }

  // Future _initPostureImages() async {
  //   // final manifestContent = await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
  //   // final Map<String, dynamic> manifestMap = json.decode(manifestContent);
  //   //
  //   // final imagePaths = manifestMap.keys
  //   //     .where((String key) => key.contains('images/'))
  //   //     .where((String key) => key.contains('posture-'))
  //   //     //.where((String key) => key.contains('.png'))
  //   //     .toList();
  //   //
  //   // setState(() {
  //   //   postureImages = imagePaths;
  //   //   String postures = "";
  //   //   postureImages.forEach((element) {postures += element;});
  //   //   log(postures);
  //   // });
  // }

  Future getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    print("Getting Username");
    String _username = (prefs.getString('Username') ?? "[Username]");
    return _username;
  }

  int getPercentageChange(HiveRings yestRings, HiveRings todayRings) {
    return (todayRings.goodSittingTime-yestRings.goodSittingTime)*100;
  }

  // late Timer timer;
  @override
  void dispose(){
    //TODO check if this solves the ring behaving weirdly
    //timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
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
                    Expanded(
                      flex: 2,
                      child: Container(
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
                    ),
                    Expanded(
                      flex: 4,
                      child: AutoSizeText(
                        'Hello, $username',
                        textAlign: TextAlign.left,
                        style: FlutterFlowTheme.title3.override(
                          fontFamily: 'Poppins',
                          fontSize: 40,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),

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
                            "Today's Score:",
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
                                  dataSource: ringsData,
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
                height: MediaQuery.of(context).size.height * 0.31,
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
                                              majorGridLines: MajorGridLines(
                                                width: 1,
                                                color: Colors.white24,
                                                //dashArray: <double>[2.3,2.3]
                                              ),
                                               minorGridLines: MinorGridLines(
                                                 width: 0.5,
                                                 color: Colors.white24,
                                              //   dashArray: <double>[2.3,2.3]
                                               ),

                                              minorTicksPerInterval:3,
                                              labelStyle: TextStyle(
                                                color: Colors.white38,
                                                fontFamily: 'Poppins'
                                          )),
                                          primaryYAxis: NumericAxis(
                                            minimum: 0,
                                            maximum: 60,
                                            desiredIntervals: 2,
                                            majorGridLines: MajorGridLines(width: 0),
                                            labelStyle: TextStyle(
                                              color: Colors.white38,
                                              fontFamily: 'Poppins',
                                            )
                                          ),
                                          title: ChartTitle(
                                              borderWidth: 5,
                                              alignment: ChartAlignment.near,
                                              text: 'Today, $DayDate',
                                              textStyle: TextStyle(
                                                color: Color(0xFFdfdfdf),
                                                fontSize: 14,
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
                                        height: 24,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.darkGrey, ),
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Center(
                                                child: MaterialButton(
                                                  height: 20,
                                                  minWidth: 100,
                                                  //color: Theme.of(context).primaryColor,
                                                  //textColor: Colors.black87,
                                                  child: Text(
                                                    'Back Supported \n F/S/B',
                                                    textAlign: TextAlign.center,
                                                    style: new TextStyle(
                                                      fontSize: 10.0,
                                                      fontFamily: 'Poppins',
                                                      // color: Theme.of(context).primaryColor,
                                                      color: pressAttention1 ? Colors.white : Colors.white54
                                                    ),
                                                  ),
                                                  onPressed: () async {
                                                    setState(() {
                                                      pressAttention1 = true;
                                                      pressAttention2 = false;
                                                      pressAttention3 = false;
                                                    }); // Set state
                                                    appleChartData.clear();
                                                    getVisualisationData(table3.length-1).then((latestData) async {
                                                      appleChartData = getAppleChartData(latestData!);
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Center(
                                                child: MaterialButton(
                                                  height: 20,
                                                  //minWidth: 100,
                                                  //color: Theme.of(context).primaryColor,
                                                  //textColor: Colors.black87,
                                                  child: Text(
                                                    'Back Leaning \n L/M/R',
                                                    textAlign: TextAlign.center,
                                                    style: new TextStyle(
                                                      fontSize: 10.0,
                                                      fontFamily: 'Poppins',
                                                      color: pressAttention2 ? Colors.white : Colors.white54
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      pressAttention1 = false;
                                                      pressAttention2 = true;
                                                      pressAttention3 = false;
                                                    });
                                                    appleChartData.clear();
                                                    getVisualisationData(table3.length-1).then((latestData) async {
                                                      appleChartData = getAppleChartData(latestData!);
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Center(
                                                child: MaterialButton(
                                                  height: 20,
                                                  minWidth: 100,
                                                  //color: Theme.of(context).primaryColor,
                                                  //textColor: Colors.black87,
                                                  child: Text(
                                                    'Legs Supported',
                                                    textAlign: TextAlign.center,
                                                    style: new TextStyle(
                                                      fontSize: 11.0,
                                                      fontFamily: 'Poppins',
                                                      color: pressAttention3 ? Colors.white : Colors.white54
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      pressAttention1 = false;
                                                      pressAttention2 = false;
                                                      pressAttention3 = true;
                                                    });
                                                    appleChartData.clear();
                                                    getVisualisationData(table3.length-1).then((latestData) async {
                                                      appleChartData = getAppleChartData(latestData!);
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                    )
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
                                  primaryXAxis: CategoryAxis(
                                      labelStyle: TextStyle(
                                        color: Colors.white54,
                                        fontFamily: 'Poppins',
                                        fontSize: 7.88,
                                        fontStyle: FontStyle.italic,
                                        //fontWeight: FontWeight.w500
                                      ),
                                      desiredIntervals: 17,
                                      majorGridLines: MajorGridLines(
                                        color: Colors.white24,
                                        //dashArray: <double>[2.3,2.3]
                                      )
                                  ),
                                  primaryYAxis: CategoryAxis(
                                      labelStyle: TextStyle(
                                        color: Colors.white54,
                                        fontFamily: 'Poppins',
                                        fontSize: 10,
                                      ),
                                      majorGridLines: MajorGridLines(
                                        color: Colors.white24,
                                      )
                                  ),
                                  title: ChartTitle(
                                      borderWidth: 12,
                                      alignment: ChartAlignment.near,
                                      text: 'Posture Timing in Mins',
                                      textStyle: TextStyle(
                                        color: Color(0xFFdfdfdf),
                                        fontSize: 12,
                                        fontFamily: 'Poppins',
                                      ),

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
                                      // borderRadius: BorderRadius.only(
                                      //     topLeft: Radius.circular(3),
                                      //     topRight: Radius.circular(3)
                                      // ),
                                    ),
                                  ],
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
                        Expanded(
                          child: Padding(
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
                                  ],
                                ),
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
                                width: 90,
                                height: 90,
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                                child: Image.asset(
                                  '$top1PosImg', //$top1PosImg
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Container(
                                width: 90,
                                height: 90,
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                                child: Image.asset(
                                  '$top2PosImg', //$top2PosImg
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Container(
                                width: 90,
                                height: 90,
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                                child: Image.asset(
                                  '$top3PosImg', //$top3PosImg
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
                            '$salutation',
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
                                    '$comparisonMessage',
                                    style: FlutterFlowTheme.bodyText1.override(
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  Text(
                                    '$percentageChange%', //$percentageChange
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

  // String updateString(){
  //   if (timer_count == 0){
  //     totalSittingTime = '6hr 45min';
  //     goodSittingTime = '3hr 25min';
  //   } else if (timer_count == 1){
  //     totalSittingTime = '7hr 03min';
  //     goodSittingTime = '3hr 43min';
  //   } else if (timer_count == 2){
  //     totalSittingTime = '7hr 15min';
  //     goodSittingTime = '3hr 55min';
  //   // } else if (timer_count == 3){
  //   //   totalSittingTime = '5hr 44min';
  //   //   goodSittingTime = '3hr 28min';
  //   }
  //   return totalSittingTime;
  // }

  List<SittData> getRingsData(VisualisationData latestData) {
    totalSittingTime = latestData.rings.totalSittingTime.toString();
    goodSittingTime = latestData.rings.goodSittingTime.toString();
    postureChangeFrequency = latestData.rings.postureChangeFrequency.toString();
    innerRing = latestData.rings.innerRing;
    outerRing = latestData.rings.outerRing;
    ringsData = <SittData>[
        SittData('Total Time', innerRing, FlutterFlowTheme.naplesYellow),
        SittData('Good Time', outerRing, Color(0xFF00DBA3)), //FlutterFlowTheme.secondaryColor
      ];
      // totalSittingTime = '6hr 41min';
      // goodSittingTime = '3hr 25min';
    return ringsData;
  }

  List<PostureTimingData> getPostureTimingChartData(VisualisationData latestData) {
    List<int> GreenLs = latestData.postureGraph.greenPositionTime;
    List<int> YellowLs = latestData.postureGraph.yellowPositionTime;
    List<int> RedLs = latestData.postureGraph.redPositionTime;
    PostureTimingChartData = <PostureTimingData>[
        PostureTimingData('P1', GreenLs[0], YellowLs[0], RedLs[0]), // POS G Y R
        PostureTimingData('P2', GreenLs[1], YellowLs[1], RedLs[1]),
        PostureTimingData('P3', GreenLs[2], YellowLs[2], RedLs[2]),
        PostureTimingData('P4', GreenLs[3], YellowLs[3], RedLs[3]),
        PostureTimingData('P5', GreenLs[4], YellowLs[4], RedLs[4]),
        PostureTimingData('P6', GreenLs[5], YellowLs[5], RedLs[5]),
        PostureTimingData('P7', GreenLs[6], YellowLs[6], RedLs[6]),
        PostureTimingData('P8', GreenLs[7], YellowLs[7], RedLs[7]),
        PostureTimingData('P8', GreenLs[8], YellowLs[8], RedLs[8]),
        PostureTimingData('P9', GreenLs[9], YellowLs[9], RedLs[9]),
        PostureTimingData('P10', GreenLs[10], YellowLs[10], RedLs[10]),
        PostureTimingData('P11', GreenLs[11], YellowLs[11], RedLs[11]),
        PostureTimingData('P12', GreenLs[12], YellowLs[12], RedLs[12]),
        PostureTimingData('P13', GreenLs[13], YellowLs[13], RedLs[13]),
        PostureTimingData('P14', GreenLs[14], YellowLs[14], RedLs[14]),
        PostureTimingData('P15', GreenLs[15], YellowLs[15], RedLs[15]),
        PostureTimingData('P16', GreenLs[16], YellowLs[16], RedLs[16]),
        PostureTimingData('P17', GreenLs[17], YellowLs[17], RedLs[17]),
        PostureTimingData('P18', GreenLs[18], YellowLs[18], RedLs[18]),
      ];
    return PostureTimingChartData;
  }

  // double _getRandomValue(int min, int max) {
  //   return min + random.nextInt(max - min).toDouble();
  // }

  List<AppleGraphData> getAppleChartData(VisualisationData latestData) {
    List<int> FactorLs = List<int>.filled(24, 0, growable: false);
    List<int> TotalLs = latestData.appleGraph.totalTime;
    if (pressAttention1){
      FactorLs = latestData.appleGraph.backSupp;
    }
    else if (pressAttention2){
      FactorLs = latestData.appleGraph.backCenter;
    }
    else if (pressAttention3){
      FactorLs = latestData.appleGraph.legSupp;
    }
    appleChartData.add(AppleGraphData(
        x: '1', y: FactorLs[0], y2: TotalLs[0]));
    appleChartData.add(AppleGraphData(
        x: '2', y: FactorLs[1], y2: TotalLs[1]));
    appleChartData.add(AppleGraphData(
        x: '3', y: FactorLs[2], y2: TotalLs[2]));
    appleChartData.add(AppleGraphData(
        x: '4', y: FactorLs[3], y2: TotalLs[3]));
    appleChartData.add(AppleGraphData(
        x: '5', y: FactorLs[4], y2: TotalLs[4]));
    appleChartData.add(AppleGraphData(
        x: '6', y: FactorLs[5], y2: TotalLs[5]));
    appleChartData.add(AppleGraphData(
        x: '7', y: FactorLs[6], y2: TotalLs[6]));
    appleChartData.add(AppleGraphData(
        x: '8', y: FactorLs[7], y2: TotalLs[7]));
    appleChartData.add(AppleGraphData(
        x: '9', y: FactorLs[8], y2: TotalLs[8]));
    appleChartData.add(AppleGraphData(
        x: '10', y: FactorLs[9], y2: TotalLs[9]));
    appleChartData.add(AppleGraphData(
        x: '11', y: FactorLs[10], y2: TotalLs[10]));
    appleChartData.add(AppleGraphData(
        x: '12', y: FactorLs[11], y2: TotalLs[11]));
    appleChartData.add(AppleGraphData(
        x: '13', y: FactorLs[12], y2: TotalLs[12]));
    appleChartData.add(AppleGraphData(
        x: '14', y: FactorLs[13], y2: TotalLs[13]));
    appleChartData.add(AppleGraphData(
        x: '15', y: FactorLs[14], y2: TotalLs[14]));
    appleChartData.add(AppleGraphData(
        x: '16', y: FactorLs[15], y2: TotalLs[15]));
    appleChartData.add(AppleGraphData(
        x: '17', y: FactorLs[16], y2: TotalLs[16]));
    appleChartData.add(AppleGraphData(
        x: '18', y: FactorLs[17], y2: TotalLs[17]));
    appleChartData.add(AppleGraphData(
        x: '19', y: FactorLs[18], y2: TotalLs[18]));
    appleChartData.add(AppleGraphData(
        x: '20', y: FactorLs[19], y2: TotalLs[19]));
    appleChartData.add(AppleGraphData(
        x: '21', y: FactorLs[20], y2: TotalLs[20]));
    appleChartData.add(AppleGraphData(
        x: '22', y: FactorLs[21], y2: TotalLs[21]));
    appleChartData.add(AppleGraphData(
        x: '23', y: FactorLs[22], y2: TotalLs[22]));
    appleChartData.add(AppleGraphData(
        x: '24', y: FactorLs[23], y2: TotalLs[23]));

    return appleChartData;
  }

}

// FOR UPDATING VISUALISATION IN MAIN PAGE, rmb to use SETSTATE()
Future<void> updateVisualisation() async {
  var table3 = Boxes.getVisualisationDataBox();
  getVisualisationData(table3.length-1).then((latestData) async {
    updateRings(latestData!);
    await updateAppleGraph(latestData);
    await updatePostureGraph(latestData);
  });
}

void updateRings(VisualisationData latestData) { //CALL THIS WHEN REFRESH TODAY PAGE

}

Future<void> updateAppleGraph(VisualisationData latestData) async { //CALL THIS WHEN REFRESH TODAY PAGE
  //set a variable to store the previous entry's hour, int prevIndex
  //create 4 lists with 24 variables each corresponding to the 24 hours in a day.
  // List<double> TotalLs = List<double>.filled(24, 0, growable: false);
  // List<double> isBackLs = List<double>.filled(24, 0, growable: false);
  // List<double> isSideLs = List<double>.filled(24, 0, growable: false);
  // List<double> isLegLs = List<double>.filled(24, 0, growable: false);

  // for row in hive table,
  //    get timestamp    //example: String formattedTime = DateFormat.Hm().format(dateTime); // this format -> 17:08
  //    take the HOUR from formattedTime
  //    if HOUR == prevIndex > add to List[HOUR] for each of the 4 lists //HOUR is ith index
  //    else add to List[HOUR+1], prevIndex = HOUR

  //  pass these variables into syncfusion AppleGraph
}

Future<void> updatePostureGraph(VisualisationData latestData) async { //CALL THIS WHEN REFRESH TODAY PAGE

}


class SittData {
  SittData(this.name, this.data,this.pointColour);
  final String name;
  final double data;
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
  final int? y;
  final int? y2;
}