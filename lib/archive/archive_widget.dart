import 'dart:math';

import 'package:better_sitt/today/today_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../flutter_flow/flutter_flow_calendar.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ArchiveWidget extends StatefulWidget {
  ArchiveWidget({Key? key}) : super(key: key);

  @override
  _ArchiveWidgetState createState() => _ArchiveWidgetState();
}

class _ArchiveWidgetState extends State<ArchiveWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  //String selectedDay = DateFormat('MMM d').format(calendarSelectedDay).toString();
  final pageViewController = PageController();


  late DateTimeRange calendarSelectedDay;
  late String DayDate;

  // Format to retrieve from Firebase
  late String DataDayDate = DateFormat('yy-MM-dd').format(calendarSelectedDay.start).toString();

  // information data
  late String positionchangefrequency;

  //Graph2 Stuff
  late List<PostureTimingData> PostureTimingChartData;
  late List<SittData> infoData;
  int timer_count =0;
  late String totalSittingTime;
  late String goodSittingTime;

  //Apple Graph Stuff
  final Random random = Random();
  int count_2 = 0;
  List<AppleGraphData> appleChartData = [];
  bool pressAttention1 = true;
  bool pressAttention2 = false;
  bool pressAttention3 = false;


  @override
  void initState() {
    super.initState();
    calendarSelectedDay = DateTimeRange(
      start: DateTime.now().startOfDay,
      end: DateTime.now().endOfDay,
    );
    _getGoodSittingTime().then((value){ setState(() {
      goodSittingTime = value;
    });});
    _getTotalSittingTime().then((value){ setState(() {
      totalSittingTime = value;
    });});
    _getPositionChangeFrequency().then((value){ setState(() {
      positionchangefrequency = value;
    });});

  }

  Future<String> _getGoodSittingTime() async{

    final firebaseUser = await FirebaseAuth.instance.currentUser!;

    await FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid).collection('Information Data').doc('$DataDayDate').get().then((value){
      goodSittingTime = value['good_sitting_time'];
    });
    return goodSittingTime;
  }

  Future<String> _getTotalSittingTime() async{

    final firebaseUser = await FirebaseAuth.instance.currentUser!;

    await FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid).collection('Information Data').doc('$DataDayDate').get().then((value){
      totalSittingTime = value['total_sitting_time'];
    });
    return totalSittingTime;
  }

  Future<String> _getPositionChangeFrequency() async{

    final firebaseUser = await FirebaseAuth.instance.currentUser!;

    await FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid).collection('Information Data').doc('$DataDayDate').get().then((value){
      positionchangefrequency = value['position_change_frequency'];
    });
    return positionchangefrequency;
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {

        return AlertDialog(
          title: Text( '$DayDate',
                        style: TextStyle(
                          color: Colors.white,
                              fontSize: 24,
                        )
          ),
          backgroundColor: FlutterFlowTheme.primaryColor,
          insetPadding: EdgeInsets.all(10),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.25,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.primaryColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.25,
                        decoration: BoxDecoration(),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.width * 0.3,
                              width: MediaQuery.of(context).size.width * 0.50,
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
                                '$positionchangefrequency',
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
                                  'assets/images/posture-yyy.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Container(
                                width: 90,
                                height: 90,
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                                child: Image.asset(
                                  'assets/images/posture-nny.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Container(
                                width: 90,
                                height: 90,
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
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


                // Container(
                //   width: double.infinity,
                //   height: MediaQuery.of(context).size.height * 0.31,
                //   decoration: BoxDecoration(),
                //   child: Container(
                //     width: double.infinity,
                //     height: double.infinity,
                //     child: Stack(
                //       children: [
                //         Padding(
                //           padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
                //           child: PageView(
                //             controller: pageViewController,
                //             scrollDirection: Axis.horizontal,
                //             children: [
                //               Card(
                //                 clipBehavior: Clip.antiAliasWithSaveLayer,
                //                 shape: RoundedRectangleBorder(
                //                   borderRadius: BorderRadius.circular(15),
                //                 ),
                //                 child: ClipRRect(
                //                     borderRadius: BorderRadius.circular(15),
                //                     child: Column(
                //                       children: [
                //                         Expanded(
                //                           child: Container(
                //                             child: SfCartesianChart(
                //                                 primaryXAxis: CategoryAxis(
                //                                     majorGridLines: MajorGridLines(
                //                                       width: 1,
                //                                       color: Colors.white24,
                //                                       //dashArray: <double>[2.3,2.3]
                //                                     ),
                //                                     minorGridLines: MinorGridLines(
                //                                       width: 0.5,
                //                                       color: Colors.white24,
                //                                       //   dashArray: <double>[2.3,2.3]
                //                                     ),
                //                                     minorTicksPerInterval:3,
                //                                     labelStyle: TextStyle(
                //                                         color: Colors.white38,
                //                                         fontFamily: 'Poppins'
                //                                     )),
                //                                 primaryYAxis: NumericAxis(
                //                                     minimum: 0,
                //                                     maximum: 60,
                //                                     desiredIntervals: 3,
                //                                     majorGridLines: MajorGridLines(width: 0),
                //                                     labelStyle: TextStyle(
                //                                       color: Colors.white38,
                //                                       fontFamily: 'Poppins',
                //                                     )
                //                                 ),
                //                                 title: ChartTitle(
                //                                     borderWidth: 5,
                //                                     alignment: ChartAlignment.near,
                //                                     text: 'Today, $DayDate',
                //                                     textStyle: TextStyle(
                //                                       color: Color(0xFFdfdfdf),
                //                                       fontSize: 14,
                //                                       fontFamily: 'Poppins',
                //                                     )
                //                                 ),
                //                                 backgroundColor: FlutterFlowTheme.darkGrey,
                //                                 series: <ChartSeries<AppleGraphData, String>>[
                //                                   StackedColumnSeries<AppleGraphData, String>(
                //                                     dataSource: appleChartData,
                //                                     xValueMapper: (AppleGraphData data, _) => data.x,
                //                                     yValueMapper: (AppleGraphData data, _) => data.y,
                //                                     borderWidth: 0.4,
                //                                     //borderColor: Colors.white54,
                //                                     //color: Color(0xFFdfdfdf),
                //                                     color: Color(0xFF00DBA3),
                //                                     name: 'Sales1',
                //                                   ),
                //                                   StackedColumnSeries<AppleGraphData, String>(
                //                                     dataSource: appleChartData,
                //                                     xValueMapper: (AppleGraphData data, _) => data.x,
                //                                     yValueMapper: (AppleGraphData data, _) => data.y2,
                //                                     //color: FlutterFlowTheme.darkGrey,
                //                                     color: Color(0xFFFF6B6B),
                //                                     borderWidth: 0.4,
                //                                     //borderColor: Colors.white54,
                //                                     name: 'Sales1',
                //                                   )
                //                                 ]),
                //                           ),
                //                         ),
                //                         Container(
                //                             height: 24,
                //                             decoration: BoxDecoration(
                //                               color: FlutterFlowTheme.darkGrey, ),
                //                             child: Row(
                //                               children: <Widget>[
                //                                 Expanded(
                //                                   child: Center(
                //                                     child: MaterialButton(
                //                                       height: 20,
                //                                       minWidth: 100,
                //                                       //color: Theme.of(context).primaryColor,
                //                                       //textColor: Colors.black87,
                //                                       child: Text(
                //                                         'Back Supported \n F/S/B',
                //                                         textAlign: TextAlign.center,
                //                                         style: new TextStyle(
                //                                             fontSize: 10.0,
                //                                             fontFamily: 'Poppins',
                //                                             // color: Theme.of(context).primaryColor,
                //                                             color: pressAttention1 ? Colors.white : Colors.white54
                //                                         ),
                //                                       ),
                //                                       onPressed: () {
                //                                         appleChartData.clear();
                //                                         appleChartData = getAppleChartData();
                //                                         setState(() {
                //                                           pressAttention1 = true;
                //                                           pressAttention2 = false;
                //                                           pressAttention3 = false;
                //                                         }); // Set state
                //                                       },
                //                                     ),
                //                                   ),
                //                                 ),
                //                                 Expanded(
                //                                   child: Center(
                //                                     child: MaterialButton(
                //                                       height: 20,
                //                                       //minWidth: 100,
                //                                       //color: Theme.of(context).primaryColor,
                //                                       //textColor: Colors.black87,
                //                                       child: Text(
                //                                         'Back Leaning \n L/M/R',
                //                                         textAlign: TextAlign.center,
                //                                         style: new TextStyle(
                //                                             fontSize: 10.0,
                //                                             fontFamily: 'Poppins',
                //                                             color: pressAttention2 ? Colors.white : Colors.white54
                //                                         ),
                //                                       ),
                //                                       onPressed: () {
                //                                         // if (count_2 == 0) {
                //                                         //   appleChartData.clear();
                //                                         //   appleChartData = data2;
                //                                         // } else {
                //                                         //   appleChartData.clear();
                //                                         //   appleChartData = getAppleChartData();
                //                                         // }
                //                                         // count_2++;
                //                                         appleChartData.clear();
                //                                         appleChartData = getAppleChartData();
                //                                         setState(() {
                //                                           pressAttention1 = false;
                //                                           pressAttention2 = true;
                //                                           pressAttention3 = false;
                //                                         });
                //                                       },
                //                                     ),
                //                                   ),
                //                                 ),
                //                                 Expanded(
                //                                   child: Center(
                //                                     child: MaterialButton(
                //                                       height: 20,
                //                                       minWidth: 100,
                //                                       //color: Theme.of(context).primaryColor,
                //                                       //textColor: Colors.black87,
                //                                       child: Text(
                //                                         'Legs Supported',
                //                                         textAlign: TextAlign.center,
                //                                         style: new TextStyle(
                //                                             fontSize: 11.0,
                //                                             fontFamily: 'Poppins',
                //                                             color: pressAttention3 ? Colors.white : Colors.white54
                //                                         ),
                //                                       ),
                //                                       onPressed: () {
                //                                         // if (count_2 == 0) {
                //                                         //   appleChartData.clear();
                //                                         //   appleChartData = data2;
                //                                         // } else {
                //                                         //   appleChartData.clear();
                //                                         //   appleChartData = getAppleChartData();
                //                                         // }
                //                                         // count_2++;
                //                                         appleChartData.clear();
                //                                         appleChartData = getAppleChartData();
                //                                         setState(() {
                //                                           pressAttention1 = false;
                //                                           pressAttention2 = false;
                //                                           pressAttention3 = true;
                //                                         });
                //                                       },
                //                                     ),
                //                                   ),
                //                                 ),
                //                               ],
                //                             ))
                //                       ],
                //
                //                     )
                //                 ),
                //               ),
                //               Card(
                //                 clipBehavior: Clip.antiAliasWithSaveLayer,
                //                 shape: RoundedRectangleBorder(
                //                   borderRadius: BorderRadius.circular(15),
                //                 ),
                //                 child: ClipRRect(
                //                   borderRadius: BorderRadius.circular(15),
                //                   child: SfCartesianChart(
                //                     title: ChartTitle(
                //                       borderWidth: 12,
                //                       alignment: ChartAlignment.near,
                //                       text: 'Posture Timing in Mins',
                //                       textStyle: TextStyle(
                //                         color: Color(0xFFdfdfdf),
                //                         fontSize: 12,
                //                         fontFamily: 'Poppins',
                //                       ),
                //
                //                     ),
                //                     backgroundColor: FlutterFlowTheme.darkGrey,
                //                     legend: Legend(isVisible: false),
                //                     series: <ChartSeries>[
                //                       StackedColumnSeries<PostureTimingData, String>(
                //                         width: 0.5,
                //                         dataSource: PostureTimingChartData,
                //                         // animationDuration: 2500,
                //                         xValueMapper: (PostureTimingData data, _) => data.postureCategory,
                //                         yValueMapper: (PostureTimingData data, _) => data.green,
                //                         name: 'p1',
                //                         color: Color(0xFFFF6B6B),
                //                       ),
                //                       StackedColumnSeries<PostureTimingData, String>(
                //                         width: 0.5,
                //                         dataSource: PostureTimingChartData,
                //                         // animationDuration: 2500,
                //                         xValueMapper: (PostureTimingData data, _) => data.postureCategory,
                //                         yValueMapper: (PostureTimingData data, _) => data.yellow,
                //                         name: 'p2',
                //                         color: Color(0xFFFFE66D),
                //                       ),
                //                       StackedColumnSeries<PostureTimingData, String>(
                //                         width: 0.5,
                //                         dataSource: PostureTimingChartData,
                //                         // animationDuration: 2500,
                //                         xValueMapper: (PostureTimingData data, _) => data.postureCategory,
                //                         yValueMapper: (PostureTimingData data, _) => data.red,
                //                         color: Color(0xFF00DBA3),
                //                         name: 'p3',
                //                         borderRadius: BorderRadius.only(
                //                             topLeft: Radius.circular(3),
                //                             topRight: Radius.circular(3)),
                //                       ),
                //                     ],
                //                     primaryXAxis: CategoryAxis(
                //                         labelStyle: TextStyle(
                //                           color: Colors.white38,
                //                           fontFamily: 'Poppins',
                //                           fontSize: 12,
                //                           //fontStyle: FontStyle.italic,
                //                           //fontWeight: FontWeight.w500
                //                         ),
                //                         majorGridLines: MajorGridLines(
                //                           color: Colors.white24,
                //                           //dashArray: <double>[2.3,2.3]
                //                         )
                //                     ),
                //                     primaryYAxis: CategoryAxis(
                //                         labelStyle: TextStyle(
                //                           color: Colors.white38,
                //                           fontFamily: 'Poppins',
                //                           fontSize: 10,
                //                         ),
                //                         majorGridLines: MajorGridLines(
                //                           color: Colors.white24,
                //                         )
                //                     ),
                //                   ),
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ),
                //         Align(
                //           alignment: Alignment(0, 0.9),
                //           child: SmoothPageIndicator(
                //             controller: pageViewController,
                //             count: 2,
                //             axisDirection: Axis.horizontal,
                //             onDotClicked: (i) {
                //               pageViewController.animateToPage(
                //                 i,
                //                 duration: Duration(milliseconds: 500),
                //                 curve: Curves.ease,
                //               );
                //             },
                //             effect: ExpandingDotsEffect(
                //               expansionFactor: 2,
                //               spacing: 8,
                //               radius: 16,
                //               dotWidth: 14,
                //               dotHeight: 14,
                //               dotColor: Color(0xFF9E9E9E),
                //               activeDotColor: FlutterFlowTheme.tertiaryColor,
                //               paintStyle: PaintingStyle.fill,
                //             ),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),


                // Container( // hereiam backup
                //   width: double.infinity,
                //   height: 150,
                //   decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(15),
                //       color: FlutterFlowTheme.secondaryColor ),
                //   padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
                //   child: Text("You can make cool stuff!",
                //       style: TextStyle(fontSize: 24),
                //       textAlign: TextAlign.center
                //   ),
                // ),


                // Container( // hereiam backup
                //   width: double.infinity,
                //   height: 150,
                //   decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(15),
                //       color: FlutterFlowTheme.secondaryColor ),
                //   padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
                //   child: Text("You can make cool stuff!",
                //       style: TextStyle(fontSize: 24),
                //       textAlign: TextAlign.center
                //   ),
                // ),




              ],
            ),


              // Stack(
              //   overflow: Overflow.visible,
              //   alignment: Alignment.center,
              //   children: <Widget>[
              //     Container(
              //       width: double.infinity,
              //       height: 300,
              //       decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(15),
              //           color: Colors.lightBlue ),
              //       padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
              //       child: Text("You can make cool stuff!",
              //           style: TextStyle(fontSize: 24),
              //           textAlign: TextAlign.center
              //       ),
              //     ),
              //     Positioned(
              //         top: -100,
              //         child: Image.network("https://i.imgur.com/2yaf2wb.png",
              //             width: 150,
              //             height: 150
              //         )
              //     )
              //   ],
              // )



          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close',
                  style: TextStyle(
                    color: FlutterFlowTheme.secondaryColor)
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    infoData = getChartData();
    PostureTimingChartData = getPostureTimingChartData();


    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.primaryColor,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
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
                Expanded(
                  child: Align(
                    alignment: Alignment(0, 0.5),
                    child: AutoSizeText(
                      'Archive',
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.title3.override(
                        fontFamily: 'Poppins',
                        fontSize: 40,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.6,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.darkGrey,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: FlutterFlowCalendar(
                  color: FlutterFlowTheme.secondaryColor,
                  iconColor: FlutterFlowTheme.tertiaryColor,
                  weekFormat: false,
                  weekStartsMonday: false,
                  onChange: (DateTimeRange newSelectedDate) {
                    setState(() => calendarSelectedDay = newSelectedDate);
                    DayDate = DateFormat('EEE, MMM d').format(calendarSelectedDay.start).toString();
                    // = DateFormat('MMM d').format(DateTime.now()).toString();
                    _showMyDialog();
                  },
                  titleStyle: FlutterFlowTheme.title3.override(
                    fontFamily: 'Poppins',
                  ),
                  dayOfWeekStyle: TextStyle(
                    color: FlutterFlowTheme.tertiaryColor,
                  ),
                  dateStyle: TextStyle(
                    color: FlutterFlowTheme.tertiaryColor,
                  ),
                  selectedDateStyle: TextStyle(
                    color: FlutterFlowTheme.primaryColor,
                  ),
                  inactiveDateStyle: TextStyle(),
                )
              ),
            ),
          )
        ],
      ),
    );
  }

  List<SittData> getChartData() {
    infoData = <SittData>[
      SittData('My Ass', 35, FlutterFlowTheme.naplesYellow),
      SittData('Second Ass', 40, Color(0xFF00DBA3)),
    ];

    return infoData;
  }

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

  List<PostureTimingData> getPostureTimingChartData() {

      PostureTimingChartData = <PostureTimingData>[
        PostureTimingData('P1', 15, 0, 13),
        PostureTimingData('P2', 3, 0, 4),
        PostureTimingData('P3', 0, 0, 0),
        PostureTimingData('P4', 0, 0, 0),
        PostureTimingData('P5', 13, 2, 0),
        PostureTimingData('P6', 0, 0, 0),
        PostureTimingData('P7', 0, 5, 0),
        PostureTimingData('P8', 0, 1, 0),
        PostureTimingData('P8', 0, 0, 0),
      ];

    return PostureTimingChartData;
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



