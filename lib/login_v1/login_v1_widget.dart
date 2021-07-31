import 'package:better_sitt/first_page/first_page_widget.dart';
// import 'package:better_sitt/login_v1/services/auth.dart';
import 'package:better_sitt/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import '../registration/registration_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

class LoginV1Widget extends StatefulWidget {
  LoginV1Widget({Key? key}) : super(key: key);

  @override
  _LoginV1WidgetState createState() => _LoginV1WidgetState();
}

class _LoginV1WidgetState extends State<LoginV1Widget> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late String _email, _password;
  final auth = FirebaseAuth.instance;
  late bool passwordVisibility;
  late String alertDialogText;
  late List<TextEditingController> controllerLs;

  // Authenticate
  //final AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();
    passwordVisibility = false;
    controllerLs = [emailTextController,passwordTextController];
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Unable to Login'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(alertDialogText),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> loginUser() async {
    final prefs = await SharedPreferences.getInstance();
    final anyEmptyFields = controllerLs.any((TextEditingController T) => T.text.isEmpty);
    final anyMismatched = (emailTextController.text!=prefs.getString('Email')||passwordTextController.text!=prefs.getString('Password'));
    //Alert Dialog if any uncompleted fields or conflicting passwords
    if (anyEmptyFields || anyMismatched) {
      if (anyEmptyFields){
        alertDialogText = "All Fields Must be Filled!";
      }
      else if (anyMismatched){
        alertDialogText = "Wrong Password or Email, try again!";
      }
      _showMyDialog();
      return false;
    }
    return true;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.primaryColor,
      body: Align(
        alignment: Alignment(0, 0),
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 1, 0, 0),
          child: Container(
            height: double.infinity,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment(0, -1),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(0),
                      child: Image.asset(
                        'assets/images/Logo_Login.png',
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment(0, 0),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 1, 0, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment(0, 0.85),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                              child: Container(
                                width: double.infinity,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.darkGrey,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(0),
                                    bottomRight: Radius.circular(0),
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30),
                                  ),
                                  shape: BoxShape.rectangle,
                                ),
                                child: SingleChildScrollView(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(0, 100, 0, 60),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(4, 0, 0, 20),
                                              child: Container(
                                                width: 300,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  color: Color(0xFFE0E0E0),
                                                  borderRadius: BorderRadius.circular(25),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                                  child: TextFormField(
                                                    controller: emailTextController,
                                                    obscureText: false,
                                                    onChanged: (value){
                                                      setState(() {
                                                        _email = value.trim();
                                                      });
                                                    },
                                                    decoration: InputDecoration(
                                                      hintText: 'Email',
                                                      hintStyle: GoogleFonts.getFont(
                                                            'Open Sans',
                                                            color: FlutterFlowTheme.mediumTurquoise,
                                                            fontWeight: FontWeight.normal),
                                                      enabledBorder: UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color:Color(0x00000000),
                                                          width: 1,
                                                        ),
                                                        borderRadius: const BorderRadius.only(
                                                          topLeft: Radius.circular(4.0),
                                                          topRight: Radius.circular(4.0),
                                                        ),
                                                      ),
                                                      focusedBorder: UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color:Color(0x00000000),
                                                          width: 1
                                                        ),
                                                        borderRadius: const BorderRadius.only(
                                                          topLeft: Radius.circular(4.0),
                                                          topRight: Radius.circular(4.0)
                                                        ),
                                                      ),
                                                    ),
                                                    style: GoogleFonts.getFont(
                                                      'Open Sans',
                                                      color: FlutterFlowTheme.mediumTurquoise,
                                                      fontWeight: FontWeight.normal,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(4, 0, 4, 20),
                                              child: Container(
                                                width: 300,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  color: Color(0xFFE0E0E0),
                                                  borderRadius: BorderRadius.circular(25),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.fromLTRB(20, 2, 20, 2),
                                                  child: TextFormField(
                                                    controller: passwordTextController,
                                                    obscureText: !passwordVisibility,
                                                    onChanged: (value){
                                                      setState(() {
                                                        _email = value.trim();
                                                      });
                                                    },
                                                    decoration: InputDecoration(
                                                      hintText: 'Password',
                                                      hintStyle:
                                                          GoogleFonts.getFont(
                                                            'Open Sans',
                                                            color: FlutterFlowTheme.mediumTurquoise,
                                                            fontWeight: FontWeight.normal,
                                                      ),
                                                      enabledBorder:
                                                          UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Color(0x00000000),
                                                          width: 1,
                                                        ),
                                                        borderRadius:
                                                            const BorderRadius.only(
                                                          topLeft: Radius.circular(4.0),
                                                          topRight: Radius.circular(4.0),
                                                        ),
                                                      ),
                                                      focusedBorder:
                                                          UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Color(0x00000000),
                                                          width: 1,
                                                        ),
                                                        borderRadius:
                                                            const BorderRadius.only(
                                                          topLeft: Radius.circular(4.0),
                                                          topRight: Radius.circular(4.0),
                                                        ),
                                                      ),
                                                      contentPadding:
                                                          EdgeInsets.fromLTRB(1, 12, 0, 0),
                                                      suffixIcon: InkWell(
                                                        onTap: () => setState(
                                                          () => passwordVisibility = !passwordVisibility,
                                                        ),
                                                        child: Icon(
                                                          passwordVisibility ? Icons.visibility_outlined
                                                              : Icons.visibility_off_outlined,
                                                          color: FlutterFlowTheme.mediumTurquoise,
                                                          size: 20,
                                                        ),
                                                      ),
                                                    ),
                                                    style: GoogleFonts.getFont(
                                                      'Open Sans',
                                                      color: FlutterFlowTheme
                                                          .mediumTurquoise,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 0, 0, 20),
                                              child: FFButtonWidget(
                                                onPressed: () async { // hereiam
                                                  try {
                                                    auth.signInWithEmailAndPassword(email: _email, password: _password);
                                                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => NavBarPage()));

                                                    // await Navigator.push(
                                                    //   context,
                                                    //   MaterialPageRoute(
                                                    //     builder: (context) => NavBarPage(),
                                                    //   ),
                                                    // );
                                                  } catch (e){
                                                    //
                                                   print('Account does not exist - Toast');
                                                   Fluttertoast.showToast(
                                                       msg: "Email/Password Not Found",
                                                       toastLength: Toast.LENGTH_SHORT,
                                                       gravity: ToastGravity.CENTER,
                                                       // timeInSecForIosWeb: 1,
                                                       backgroundColor: Colors.red,
                                                       textColor: Colors.white,
                                                       fontSize: 16.0
                                                   );
                                                  }
                                                onPressed: () async {
                                                  loginUser().then((isRegistered) {
                                                    if(isRegistered){
                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => NavBarPage(),),);
                                                    }
                                                  });
                                                  // print('Button pressed ...');
                                                },
                                                text: 'Log In',
                                                options: FFButtonOptions(
                                                  width: 300,
                                                  height: 50,
                                                  color: FlutterFlowTheme
                                                      .secondaryColor,
                                                  textStyle: FlutterFlowTheme
                                                      .subtitle2
                                                      .override(
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  borderSide: BorderSide(
                                                    color: Colors.transparent,
                                                    width: 0,
                                                  ),
                                                  borderRadius: 25,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              'Forgot password?',
                                              style: FlutterFlowTheme.bodyText1
                                                  .override(
                                                fontFamily: 'Poppins',
                                              ),
                                            )
                                          ],
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 20, 0, 20),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 38,
                                                    height: 38,
                                                    child: Stack(
                                                      children: [
                                                        Align(
                                                          alignment:
                                                              Alignment(0, 0),
                                                          child: Container(
                                                            width: 30,
                                                            height: 30,
                                                            clipBehavior:
                                                                Clip.antiAlias,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                            child:
                                                                Image.network(
                                                              'https://facebookbrand.com/wp-content/uploads/2019/04/f_logo_RGB-Hex-Blue_512.png?w=512&h=512',
                                                            ),
                                                          ),
                                                        ),
                                                        // Align(
                                                        //   alignment:
                                                        //       Alignment(0, 0),
                                                        //   child: FFButtonWidget(
                                                        //     onPressed: () {
                                                        //       print(
                                                        //           'Button pressed ...');
                                                        //     },
                                                        //     text: '',
                                                        //     icon: Icon(
                                                        //       Icons.add,
                                                        //       color: Colors
                                                        //           .transparent,
                                                        //       size: 15,
                                                        //     ),
                                                        //     options:
                                                        //         FFButtonOptions(
                                                        //       width: 30,
                                                        //       height: 30,
                                                        //       color: Colors
                                                        //           .transparent,
                                                        //       textStyle:
                                                        //           GoogleFonts
                                                        //               .getFont(
                                                        //         'Open Sans',
                                                        //         color: Color(
                                                        //             0xFF616161),
                                                        //         fontSize: 14,
                                                        //       ),
                                                        //       borderSide:
                                                        //           BorderSide(
                                                        //         color:
                                                        //             FlutterFlowTheme
                                                        //                 .darkGrey,
                                                        //         width: 0.5,
                                                        //       ),
                                                        //       borderRadius: 15,
                                                        //     ),
                                                        //   ),
                                                        // )
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            20, 0, 0, 0),
                                                    child: Container(
                                                      width: 38,
                                                      height: 38,
                                                      child: Stack(
                                                        children: [
                                                          Align(
                                                            alignment:
                                                                Alignment(0, 0),
                                                            child: Container(
                                                              width: 30,
                                                              height: 30,
                                                              clipBehavior: Clip
                                                                  .antiAlias,
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                              child:
                                                                  Image.network(
                                                                'https://i0.wp.com/nanophorm.com/wp-content/uploads/2018/04/google-logo-icon-PNG-Transparent-Background.png?w=1000&ssl=1',
                                                                fit: BoxFit
                                                                    .contain,
                                                              ),
                                                            ),
                                                          ),
                                                          // Align(
                                                          //   alignment:
                                                          //       Alignment(0, 0),
                                                          //   child: FFButtonWidget(
                                                          //     onPressed: () {
                                                          //       print(
                                                          //           'Button pressed ...');
                                                          //     },
                                                          //     text: '',
                                                          //     icon: Icon(
                                                          //       Icons.add,
                                                          //       color: Colors
                                                          //           .transparent,
                                                          //       size: 15,
                                                          //     ),
                                                          //     options:
                                                          //         FFButtonOptions(
                                                          //       width: 30,
                                                          //       height: 30,
                                                          //       color: Colors
                                                          //           .transparent,
                                                          //       textStyle:
                                                          //           GoogleFonts
                                                          //               .getFont(
                                                          //         'Open Sans',
                                                          //         color: Color(
                                                          //             0xFF616161),
                                                          //         fontSize: 14,
                                                          //       ),
                                                          //       borderSide:
                                                          //           BorderSide(
                                                          //         color:
                                                          //             FlutterFlowTheme
                                                          //                 .darkGrey,
                                                          //         width: 0.5,
                                                          //       ),
                                                          //       borderRadius: 15,
                                                          //     ),
                                                          //   ),
                                                          // )
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 0, 10, 0),
                                                  child: Text(
                                                    'Don\'t have an account?',
                                                    style: GoogleFonts.getFont(
                                                      'Open Sans',
                                                      color: Color(0xFFADADAD),
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    await Navigator.push(
                                                      context,
                                                      PageTransition(
                                                        type: PageTransitionType.topToBottom,
                                                        duration: Duration(
                                                            milliseconds: 300
                                                        ),
                                                        reverseDuration:
                                                            Duration(
                                                                milliseconds: 300
                                                            ),
                                                        child:
                                                            RegistrationWidget(),
                                                      ),
                                                    );
                                                  },
                                                  child: Text(
                                                    'Register here',
                                                    style: GoogleFonts.getFont(
                                                      'Open Sans',
                                                      color: FlutterFlowTheme.secondaryColor,
                                                      fontSize: 14,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                        Align(
                                          alignment: Alignment(0, -0.65),
                                          child: Padding(
                                            padding:
                                                EdgeInsets.fromLTRB(0, 4, 0, 0),
                                            child: Image.asset(
                                              'assets/images/Logo2.png',
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
