import 'dart:convert';
import 'dart:developer';

import 'package:better_sitt/utils/boxes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import '../main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_blue/flutter_blue.dart';

class NotifWidget extends StatefulWidget {
  NotifWidget({Key? key}) : super(key: key);

  @override
  _NotifWidgetState createState() => _NotifWidgetState();
}

class _NotifWidgetState extends State<NotifWidget> {
  final currentPWController = TextEditingController();
  final newPWController = TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late String alertDialogText;
  final flutterBlue = FlutterBlue.instance;

  @override
  void initState() {
    super.initState();
  }
  //TODO access this in main
  void setHaptics(String _pulseDecision) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('Haptics', _pulseDecision);
    if (_pulseDecision == "1"){
      log("updated Haptics: Constant");
    }
    else if(_pulseDecision == "2") {
      log("updated Haptics: Intermittent");
    }
    setState(() {});
  }

  Future<void> _setConstantPulseDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Constant Pulse?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text("Haptic Feedback will be received in a single 500ms pulse."),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('NO'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),

            TextButton(
              child: const Text('YES'),
              onPressed: () {
                setConstantPulse().then((value) => Navigator.of(context).pop());
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _setIntermittentPulseDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Intermittent Pulse?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text("Haptic Feedback will be received in multiple rapid pulses."),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('NO'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),

            TextButton(
              child: const Text('YES'),
              onPressed: () {
                setIntermittentPulse().then((value) => Navigator.of(context).pop());
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> setConstantPulse() async{
    flutterBlue.connectedDevices.then((connectedDevicesList) {if(connectedDevicesList.isNotEmpty){
      String pulseDecision = "1";
      List<BluetoothCharacteristic> cList;
      connectedDevicesList.single.discoverServices().then((services) async {
        cList = services[2].characteristics;
        //String temp = "cList: ";
        //cList.forEach((element) { temp += element.descriptors.toString();});
        //log(temp);
        log("number of characteristics: "+cList.length.toString());
        //cList.firstWhere((c) => c.uuid.toString()=="c53e7632-9a2b-4272-b1a8-d2f4d658752a").write(utf8.encode(pulseDecision));
        await cList.last.write(utf8.encode(pulseDecision));
        log("LONG PULSE SENT");
        setHaptics(pulseDecision);
      });
    }
    else {_showNotConnectedDialog();}
    });
  }

  Future<void> setIntermittentPulse() async{
    flutterBlue.connectedDevices.then((connectedDevicesList) {if(connectedDevicesList.isNotEmpty){
      String pulseDecision = "2";
      List<BluetoothCharacteristic> cList;
      connectedDevicesList.single.discoverServices().then((services) async {
        cList = services[2].characteristics;
        log("number of characteristics: "+cList.length.toString());
        await cList.firstWhere((c) => c.uuid.toString()=="c53e7632-9a2b-4272-b1a8-d2f4d658752a").write(utf8.encode(pulseDecision));
        log("INTERMITTENT PULSE SENT");
        setHaptics(pulseDecision);
      });
    }
    else {_showNotConnectedDialog();}
    });
  }

  Future<void> _showNotConnectedDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('BetterSitt not detected'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Please ensure Bluetooth is on and you are connected to BetterSitt."),
              ],
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Align(
            alignment: Alignment(0, 0),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.tertiaryColor,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: Image.asset(
                    'assets/images/Registration Empty.png',
                  ).image,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment(0, 0),
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.8,
              decoration: BoxDecoration(),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FFButtonWidget(
                          onPressed: () async {
                            _setConstantPulseDialog();
                          },
                          text: 'Constant Pulse',
                          options: FFButtonOptions(
                            // width: 90,
                            // height: 40,
                            color: FlutterFlowTheme.bittersweetRed,
                            textStyle: FlutterFlowTheme.bodyText2.override(
                              fontFamily: 'Poppins',
                              color: FlutterFlowTheme.primaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            elevation: 3,
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 1,
                            ),
                            borderRadius: 8,
                          ),
                        ),
                        FFButtonWidget(
                          onPressed: () async {
                            _setIntermittentPulseDialog();
                          },
                          text: 'Intermittent Pulse',
                          options: FFButtonOptions(
                            // width: 90,
                            // height: 40,
                            color: FlutterFlowTheme.bittersweetRed,
                            textStyle: FlutterFlowTheme.bodyText2.override(
                              fontFamily: 'Poppins',
                              color: FlutterFlowTheme.primaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            elevation: 3,
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 1,
                            ),
                            borderRadius: 8,
                          ),
                        )

                      ],
                    ),
                  )

                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
