import 'package:better_sitt/utils/boxes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import '../main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyDataWidget extends StatefulWidget {
  MyDataWidget({Key? key}) : super(key: key);

  @override
  _MyDataWidgetState createState() => _MyDataWidgetState();
}

class _MyDataWidgetState extends State<MyDataWidget> {
  final currentPWController = TextEditingController();
  final newPWController = TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late String alertDialogText;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _clearDataDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are You Sure?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text("Wipe today's data. This action is irreversible."),
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
                clearData().then((value) => _confirmClearDialog());
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  Future<void> clearData() async{
    //Clears Table2 Data
    var box1 = Boxes.getRawDataBox();
    var box2 = Boxes.getProcessedDataBox();
    var box3 = Boxes.getVisualisationDataBox();
    // for (int i=0;i<box.length;i++) {
    //   box.delete(i);
    // }
    box1.clear();
    box2.clear();
    box3.clear();
  }

  Future<void> _confirmClearDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Wipe Complete!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("No more data from the past 24 hours"),
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
                            _clearDataDialog();
                          },
                          text: 'Wipe Local Storage Data',
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
