import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import '../main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalParticularsWidget extends StatefulWidget {
  PersonalParticularsWidget({Key? key}) : super(key: key);

  @override
  _PersonalParticularsWidgetState createState() =>
      _PersonalParticularsWidgetState();
}

class _PersonalParticularsWidgetState extends State<PersonalParticularsWidget> {
  // TextEditingController contactnoController;
  // TextEditingController emailController;
  // TextEditingController heightController;
  // TextEditingController weightController;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  //initialise controllers
  final contactnoController = TextEditingController();
  final emailController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();

  late String initContactNo;
  late String initEmail;
  late String initHeight;
  late String initWeight;

  @override
  void initState() {
    super.initState();
    //get stored Personal Particulars from sharedpreferences
    getParticulars();

    //initialise controller textfields
    contactnoController.text = initContactNo;
    emailController.text = initEmail;
    heightController.text = initHeight;
    weightController.text = initWeight;

    //add Listeners to store the new input values
    contactnoController.addListener(updateContactNo);
    emailController.addListener(updateEmail);
    heightController.addListener(updateHeight);
    weightController.addListener(updateWeight);
  }

  void getParticulars() async {
    final prefs = await SharedPreferences.getInstance();
     setState(() {
      initContactNo = (prefs.getString('ContactNo') ?? "-");
      initEmail = (prefs.getString('Email') ?? "-");
      initHeight = (prefs.getString('Height') ?? "-");
      initWeight = (prefs.getString('Weight') ?? "-");
     });
  }

  void setParticulars() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('ContactNo', initContactNo);
    print("updated contactno: $initContactNo");
    prefs.setString('Email', initEmail);
    print("updated email: $initEmail");
    prefs.setString('Height', initHeight);
    print("updated height: $initHeight");
    prefs.setString('Weight', initWeight);
    print("updated weight: $initWeight");
    setState(() {});
  }

  void updateContactNo() {
    initContactNo = '${contactnoController.text}';
    // final prefs = await SharedPreferences.getInstance();
    // prefs.setString('ContactNo', initContactNo);
  }
  void updateEmail() {
    initEmail = '${emailController.text}';
    // final prefs = await SharedPreferences.getInstance();
    // prefs.setString('Email', initEmail);
  }
  void updateHeight() {
    initHeight = '${heightController.text}';
    // final prefs = await SharedPreferences.getInstance();
    // prefs.setInt('Height', int.parse(initHeight));
  }
  void updateWeight() {
    initWeight = '${weightController.text}';
    // final prefs = await SharedPreferences.getInstance();
    // prefs.setInt('Weight', int.parse(initWeight));
  }
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Scaffold(
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
              alignment: Alignment(0, 1),
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.8,
                decoration: BoxDecoration(),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          decoration: BoxDecoration(),
                          child: Text(
                            'Personal Particulars',
                            style: FlutterFlowTheme.title1.override(
                              fontFamily: 'Poppins',
                              color: FlutterFlowTheme.tertiaryColor,
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          decoration: BoxDecoration(),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: emailController,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    labelText: 'email',
                                    labelStyle:
                                        FlutterFlowTheme.bodyText1.override(
                                      fontFamily: 'Poppins',
                                      color: FlutterFlowTheme.secondaryColor,
                                      fontSize: 16,
                                    ),
                                    hintText: 'user_name@email.com',
                                    hintStyle:
                                        FlutterFlowTheme.bodyText1.override(
                                      fontFamily: 'Poppins',
                                      color: FlutterFlowTheme.secondaryColor,
                                      fontSize: 16,
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 1,
                                      ),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(4.0),
                                        topRight: Radius.circular(4.0),
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 1,
                                      ),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(4.0),
                                        topRight: Radius.circular(4.0),
                                      ),
                                    ),
                                  ),
                                  style: FlutterFlowTheme.bodyText1.override(
                                    fontFamily: 'Poppins',
                                    color: FlutterFlowTheme.secondaryColor,
                                    fontSize: 16,
                                  ),
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return 'Field is required';
                                    }

                                    return null;
                                  },
                                ),
                              ),
                              Align(
                                alignment: Alignment(0, 0),
                                child: Icon(
                                  Icons.edit_outlined,
                                  color: Color(0xFF95A1AC),
                                  size: 24,
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          decoration: BoxDecoration(),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: contactnoController,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    labelText: 'contact number',
                                    labelStyle:
                                        FlutterFlowTheme.bodyText1.override(
                                      fontFamily: 'Poppins',
                                      color: FlutterFlowTheme.secondaryColor,
                                      fontSize: 16,
                                    ),
                                    hintText: '87654321',
                                    hintStyle:
                                        FlutterFlowTheme.bodyText1.override(
                                      fontFamily: 'Poppins',
                                      color: FlutterFlowTheme.secondaryColor,
                                      fontSize: 16,
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 1,
                                      ),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(4.0),
                                        topRight: Radius.circular(4.0),
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 1,
                                      ),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(4.0),
                                        topRight: Radius.circular(4.0),
                                      ),
                                    ),
                                  ),
                                  style: FlutterFlowTheme.bodyText1.override(
                                    fontFamily: 'Poppins',
                                    color: FlutterFlowTheme.secondaryColor,
                                    fontSize: 16,
                                  ),
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return 'Field is required';
                                    }

                                    return null;
                                  },
                                ),
                              ),
                              Align(
                                alignment: Alignment(0, 0),
                                child: Icon(
                                  Icons.edit_outlined,
                                  color: Color(0xFF95A1AC),
                                  size: 24,
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          decoration: BoxDecoration(),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: heightController,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    labelText: 'height in cm',
                                    labelStyle:
                                        FlutterFlowTheme.bodyText1.override(
                                      fontFamily: 'Poppins',
                                      color: FlutterFlowTheme.secondaryColor,
                                      fontSize: 16,
                                    ),
                                    hintText: '180',
                                    hintStyle:
                                        FlutterFlowTheme.bodyText1.override(
                                      fontFamily: 'Poppins',
                                      color: FlutterFlowTheme.secondaryColor,
                                      fontSize: 16,
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 1,
                                      ),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(4.0),
                                        topRight: Radius.circular(4.0),
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 1,
                                      ),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(4.0),
                                        topRight: Radius.circular(4.0),
                                      ),
                                    ),
                                  ),
                                  style: FlutterFlowTheme.bodyText1.override(
                                    fontFamily: 'Poppins',
                                    color: FlutterFlowTheme.secondaryColor,
                                    fontSize: 16,
                                  ),
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return 'Field is required';
                                    }

                                    return null;
                                  },
                                ),
                              ),
                              Align(
                                alignment: Alignment(0, 0),
                                child: Icon(
                                  Icons.edit_outlined,
                                  color: Color(0xFF95A1AC),
                                  size: 24,
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          decoration: BoxDecoration(),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: weightController,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    labelText: 'weight in kg',
                                    labelStyle:
                                        FlutterFlowTheme.bodyText1.override(
                                      fontFamily: 'Poppins',
                                      color: FlutterFlowTheme.secondaryColor,
                                      fontSize: 16,
                                    ),
                                    hintText: '70',
                                    hintStyle:
                                        FlutterFlowTheme.bodyText1.override(
                                      fontFamily: 'Poppins',
                                      color: FlutterFlowTheme.secondaryColor,
                                      fontSize: 16,
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 1,
                                      ),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(4.0),
                                        topRight: Radius.circular(4.0),
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 1,
                                      ),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(4.0),
                                        topRight: Radius.circular(4.0),
                                      ),
                                    ),
                                  ),
                                  style: FlutterFlowTheme.bodyText1.override(
                                    fontFamily: 'Poppins',
                                    color: FlutterFlowTheme.secondaryColor,
                                    fontSize: 16,
                                  ),
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return 'Field is required';
                                    }

                                    return null;
                                  },
                                ),
                              ),
                              Align(
                                alignment: Alignment(0, 0),
                                child: Icon(
                                  Icons.edit_outlined,
                                  color: Color(0xFF95A1AC),
                                  size: 24,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.06,
                        decoration: BoxDecoration(),
                        child: Align(
                          alignment: Alignment(0, 0),
                          child: FFButtonWidget(
                            onPressed: () async {
                              //STORE KEY VALUE PAIRS WHEN THE CONFIRM BUTTON IS PRESSED
                              setParticulars();

                              //These are in case we wanna use it for ML in future
                              //prefs.setInt('HeightInt', int.parse(initContactNo));
                              //prefs.setInt('WeightInt', int.parse(initContactNo));

                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      NavBarPage(initialPage: 'Settings'),
                                ),
                              );
                            },
                            text: 'Confirm',
                            options: FFButtonOptions(
                              width: double.infinity,
                              height: double.infinity,
                              color: FlutterFlowTheme.secondaryColor,
                              textStyle: FlutterFlowTheme.subtitle2.override(
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
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
