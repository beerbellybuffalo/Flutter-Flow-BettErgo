import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NoBluetoothWidget extends StatefulWidget {
  NoBluetoothWidget({Key key}) : super(key: key);

  @override
  _NoBluetoothWidgetState createState() => _NoBluetoothWidgetState();
}

class _NoBluetoothWidgetState extends State<NoBluetoothWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.primaryColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('FloatingActionButton pressed ...');
        },
        backgroundColor: Color(0xFF0E4BEF),
        elevation: 8,
        child: Icon(
          Icons.bluetooth_rounded,
          color: FlutterFlowTheme.tertiaryColor,
          size: 28,
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.primaryColor,
              ),
              child: Text(
                'Not connected to BetterSitt.\nCheck that the device is switched on before initiating connection.',
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.subtitle1.override(
                  fontFamily: 'Poppins',
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
