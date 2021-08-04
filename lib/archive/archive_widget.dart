import '../flutter_flow/flutter_flow_calendar.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:better_sitt/today/today_widget.dart';

class ArchiveWidget extends StatefulWidget {
  ArchiveWidget({Key? key}) : super(key: key);

  @override
  _ArchiveWidgetState createState() => _ArchiveWidgetState();
}

class _ArchiveWidgetState extends State<ArchiveWidget> {
  late DateTimeRange calendarSelectedDay;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    calendarSelectedDay = DateTimeRange(
      start: DateTime.now().startOfDay,
      end: DateTime.now().endOfDay,
    );
  }

  @override
  Widget build(BuildContext context) {
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
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.darkGrey,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: new Stack(
                  alignment: const Alignment(5, 0.6),
                    children:<Widget>[FlutterFlowCalendar(

                  color: FlutterFlowTheme.secondaryColor,
                  iconColor: FlutterFlowTheme.tertiaryColor,
                  weekFormat: false,
                  weekStartsMonday: false,
                  onChange: (DateTimeRange newSelectedDate) {
                    setState(() => calendarSelectedDay = newSelectedDate);
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
                ),
                      rowDayScore()
                ]
                // )
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget rowDayScore(){
    return Row( mainAxisSize: MainAxisSize.min,
        children: [Expanded(child:colDayScore()),Expanded(child:colDayScore()),Expanded(child:colDayScore()),Expanded(child:colDayScore()),Expanded(child:colDayScore()),Expanded(child:colDayScore()),Expanded(child:colDayScore()),
        ]);
  }

  Widget colDayScore(){
    return Column(
      children:[
        SizedBox(height: 275),
    Expanded(
    child:dayScore()
    ),
    Expanded(
    child:dayScore()
    ),
    Expanded(
    child:dayScore()
    ),
    Expanded(
    child:dayScore()
    ),
    Expanded(
    child:dayScore()
    ), SizedBox(width: 100)
    ]);
  }
  Widget dayScore(){
    return SfCircularChart(
      series: <CircularSeries>[
        RadialBarSeries<SittData, String>(
            dataSource: <SittData>[
              SittData('My Ass', 50, Color(0xFFFF6B6B)),
            ],
            xValueMapper: (SittData data, _) => data.name,
            yValueMapper: (SittData data, _) => data.data,
            pointColorMapper: (SittData data, _) => data.pointColour,
            maximumValue: 100,
            innerRadius: '80%',
            radius: '110%',
            cornerStyle: CornerStyle.bothCurve,
            trackColor: Color(0xFF181819)
          // dataLabelSettings: DataLabelSettings(isVisible: true)
        ) ],
    );
  }
}
