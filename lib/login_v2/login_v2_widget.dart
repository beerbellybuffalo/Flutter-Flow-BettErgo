import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginV2Widget extends StatefulWidget {
  LoginV2Widget({Key? key}) : super(key: key);

  @override
  _LoginV2WidgetState createState() => _LoginV2WidgetState();
}

class _LoginV2WidgetState extends State<LoginV2Widget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment(0, 0),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
