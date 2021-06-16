import '../flutter_flow/flutter_flow_calendar.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ArchiveWidget extends StatefulWidget {
  ArchiveWidget({Key key}) : super(key: key);

  @override
  _ArchiveWidgetState createState() => _ArchiveWidgetState();
}

class _ArchiveWidgetState extends State<ArchiveWidget> {
  DateTimeRange calendarSelectedDay;
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
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
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
          Padding(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.4,
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
            ),
          )
        ],
      ),
    );
  }
}
