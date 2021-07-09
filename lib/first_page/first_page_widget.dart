import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import '../login_v1/login_v1_widget.dart';
import '../registration/registration_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

class FirstPageWidget extends StatefulWidget {
  FirstPageWidget({Key key}) : super(key: key);

  @override
  _FirstPageWidgetState createState() => _FirstPageWidgetState();
}

class _FirstPageWidgetState extends State<FirstPageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.primaryColor,
      body: Align(
        alignment: Alignment(0, 0),
        child: Container(
          height: double.infinity,
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFFEEEEEE),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: Image.asset(
                      'assets/images/MovingBG.gif',
                    ).image,
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(),
                              child: Image.asset(
                                'assets/images/Logo (Login).png',
                                fit: BoxFit.contain,
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(),
                              child: Align(
                                alignment: Alignment(0, 1),
                                child: Text(
                                  'Creating Better Ergonomic Habits',
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.subtitle1.override(
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                                child: Text(
                                  'The BettErgo app  pairs with our smart furniture to '
                                  'bring you the most accurate data  for managing your '
                                  'ergonomics',
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.bodyText2.override(
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment(0, -0.5),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                            child: FFButtonWidget(
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegistrationWidget(),
                                  ),
                                );
                              },
                              text: 'Register',
                              options: FFButtonOptions(
                                width: 130,
                                height: 40,
                                color: FlutterFlowTheme.bittersweetRed,
                                textStyle: FlutterFlowTheme.subtitle2.override(
                                  fontFamily: 'Poppins',
                                  color: FlutterFlowTheme.primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 1,
                                ),
                                borderRadius: 20,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment(0, -0.5),
                          child: FFButtonWidget(
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.bottomToTop,
                                  duration: Duration(milliseconds: 300),
                                  reverseDuration: Duration(milliseconds: 300),
                                  child: LoginV1Widget(),
                                ),
                              );
                            },
                            text: 'Log In',
                            options: FFButtonOptions(
                              width: 130,
                              height: 40,
                              color: FlutterFlowTheme.naplesYellow,
                              textStyle: FlutterFlowTheme.subtitle2.override(
                                fontFamily: 'Poppins',
                                color: FlutterFlowTheme.primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                              borderSide: BorderSide(
                                color: Colors.transparent,
                                width: 1,
                              ),
                              borderRadius: 20,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
