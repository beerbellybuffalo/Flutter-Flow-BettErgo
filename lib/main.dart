import 'dart:convert';
import 'dart:developer';

import 'package:better_sitt/first_page/first_page_widget.dart';
import 'package:better_sitt/flutter_flow/flutter_flow_calendar.dart';
import 'package:better_sitt/model/raw_data.dart';
import 'package:better_sitt/model/visualisation_data.dart';
import 'package:better_sitt/registration/registration_widget.dart';
import 'package:better_sitt/today/today_widget_filled.dart';
import 'package:better_sitt/utils/positions_processing.dart';
import 'package:flutter/material.dart';
import 'package:better_sitt/today/today_widget.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_theme.dart';
import 'archive/archive_widget.dart';
import 'hive_viewing.dart';
import 'model/apple_graph.dart';
import 'model/posture_graph.dart';
import 'model/processed_data.dart';
// import 'package:better_sitt/login_v1/models/user.dart';
// import 'package:better_sitt/login_v1/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'login_v1/authentication_services.dart';
import 'login_v1/login_v1_widget.dart';
import 'model/rings.dart';
import 'settings/settings_widget.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:async';
import 'package:flutter_blue/flutter_blue.dart';
import '../flutter_blue_widgets.dart'; //these are taken from github example, like buildServiceTiles etc.
import '../bluetooth/bluetooth_widget.dart';
import 'utils/boxes.dart';
import 'today/today_classes.dart';


Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(RawDataAdapter());
  Hive.registerAdapter(ProcessedDataAdapter());
  Hive.registerAdapter(VisualisationDataAdapter());
  Hive.registerAdapter(HiveRingsAdapter());
  Hive.registerAdapter(HivePostureGraphAdapter());
  Hive.registerAdapter(HiveAppleGraphAdapter());
  await Hive.openBox<RawData>('rawdata');
  await Hive.openBox<ProcessedData>('processeddata');
  await Hive.openBox<VisualisationData>('visualisationdata');

  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BetterSitt',
      //theme: ThemeData(primarySwatch: Colors.blue),
      home: FirstPageWidget(),
      debugShowCheckedModeBanner: false,
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/first': (context) => FirstPageWidget(),

        '/today': (context) => TodayWidgetFilled(), // change to TodayWidget() for non-demo use
      },
    );
  }
}

// class AuthenticationWrapper extends StatelessWidget {
//   const AuthenticationWrapper({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//
//     final fireBaseUser = context.watch<User>();
//     if (fireBaseUser != null){
//       return NavBarPage();
//     }
//     return LoginV1Widget();
//   }
// }


class NavBarPage extends StatefulWidget {
  NavBarPage({Key? key, this.initialPage}) : super(key: key);

  final String? initialPage;

  @override
  _NavBarPageState createState() => _NavBarPageState();
}

/// This is the private State class that goes with NavBarPage.
class _NavBarPageState extends State<NavBarPage> {
  String _currentPage = 'Today';
  late Timer sumMinuteTimer;
  late Timer oneSecTimer;
  String table1Data = "table1Data: ";
  String table2Data = "table2Data: ";
  String table3Data = "table3Data: ";

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage ?? _currentPage;
    sumMinuteTimer = new Timer.periodic(Duration(minutes: 1), (timer){updateProcessedData();
    //TODO check if necessary to send reminders, then send
    });
    oneSecTimer = new Timer.periodic(Duration(seconds: 1), (timer){updateRawData();});
    checkHiveTables().then((value) {
      print(table1Data);
      print(table2Data);
      print(table3Data);
    });
    //TODO check if Table 3 has an entry for today, if don't have then addVisualisationData
    var table3 = Boxes.getVisualisationDataBox();
    //if the latest entry in table 3 is not from today, then create new entry
    if (table3.length==0){
      putVisualisationData(new HiveRings(), new HiveAppleGraph(), new HivePostureGraph());
      return;
    }
    if (isSameDay(DateTime.parse(table3.getAt(table3.length-1)!.key), DateTime.now())==false){
      putVisualisationData(new HiveRings(), new HiveAppleGraph(), new HivePostureGraph());
    }
  }

  Future<void> checkHiveTables() async {

    var table1 = Boxes.getRawDataBox();
    var table2 = Boxes.getProcessedDataBox();
    var table3 = Boxes.getVisualisationDataBox();
    //print(table1.values);
    //print(table2.values);
    //LOG TABLE 1 DATA
    for (int i=0;i<table1.length;i++) {
    getRawData(i).then((rawData) {
      table1Data +=
      ("DATETIME " + rawData!.dateTime.toString() + "  POS " + rawData.position.toString() + "\n");
    });
    }

    //LOG TABLE 2 DATA
    for (int i=0;i<table2.length;i++) {
    getProcessedData(i).then((processedData) {
      table2Data += ("DATETIME" + processedData!.dateTime.toString() + "  POS" + processedData.position.toString() + "  CATEGORY" + processedData.category.toString() + "\n");
    });
    }

    //LOG TABLE 3 DATA
    for (int i=0;i<table3.length;i++) {
      getVisualisationData(i).then((visualisationData) {
        table3Data += ("RINGS -> totalSittingTime: " + visualisationData!.rings.totalSittingTime.toString() + " goodSittingTime: " + visualisationData.rings.goodSittingTime.toString() + " posChangeFrequency: " + visualisationData.rings.postureChangeFrequency.toString() + "\nAPPLEGRAPH -> " + "backCentered: " + visualisationData.appleGraph.backCenter.toString() + "\nbackSupported: " + visualisationData.appleGraph.backSupp.toString() + "\nlegSupported: " + visualisationData.appleGraph.legSupp.toString() + "\nPOSTUREGRAPH -> " + "top3Pos: " + visualisationData.postureGraph.topThreePositions.toString());
      });
    }
  }

  @override
  void dispose(){
    //log("NavBarPage was Killed");
    super.dispose();
    sumMinuteTimer.cancel();
    oneSecTimer.cancel();
  }

  //1. Find Modal POSITION 2. Find Position CATEGORY G/Y/R/A/B 3. Update Table 2
  void updateProcessedData() {
    log("Checking for if need to update Processed Data...");
    log(DateFormat.Hm().format(DateTime.now()));
    FlutterBlue.instance.connectedDevices.then((connectedDevicesList) {if(connectedDevicesList.isNotEmpty){
      //TODO summarise the rawdata and write to hive
      String connectedString = "";
      connectedDevicesList.forEach((element) {connectedString += element.name;});
      log("Connected Devices: "+connectedString);
      List<int> positionLs = List<int>.filled(19, 0); // 19 positions including null
      var box = Boxes.getRawDataBox();
      var box2 = Boxes.getProcessedDataBox();
      //Check if >= 1minute has elapsed
      if (box.isNotEmpty){
        if (box.getAt(box.length-1)!.dateTime.minute>box.getAt(0)!.dateTime.minute){
          //1. Find Modal POSITION
          log('FINDING MODAL POSITION');
          for (int i=0;i<box.length;i++) {
            positionLs[box.getAt(i)!.position]++;
          }
          int modalPos = 0;
          for (int i=1;i<positionLs.length;i++){
            if (positionLs[i]>positionLs[i-1]) {
              modalPos = i;
            }
          }
          //2. Find Position CATEGORY G/Y/R/A/B
          //decide if 'A or 'B'
          String addCat;
          if (checkPostureCategory(modalPos)=='AWAY') {
            if (isBreak()){
              addCat = 'B';
            }
            else {
              addCat = 'A';
            }
          }
          else{
            //get list containing [String newCat, bool needReminder]
            List<dynamic> catBoolList = setCategoryAndRemind(modalPos);
            addCat = catBoolList[0];
            //Send Reminder if necessary
            if(catBoolList[1]==true){
              sendReminder();
            }
          }
          //add entry to Table2
          addProcessedData(box.getAt(box.length-2)!.dateTime, modalPos, addCat);
          //TODO UPDATE Table 3 latest entry
          var box3 = Boxes.getVisualisationDataBox();
          if (box3.isNotEmpty){
            getVisualisationData(box3.length-1).then((data) {
              //Set HiveRings
              HiveRings todayRings = data!.rings;
              todayRings.totalSittingTime = calcTotalTime();
              todayRings.goodSittingTime = calcGoodTime();
              todayRings.postureChangeFrequency = calcPostureChangeFreq(todayRings);
              todayRings.innerRing = calcInner(todayRings);
              todayRings.outerRing = calcOuter(todayRings);

              //Set HiveAppleGraph
              //first make use of appleGraph methods
              AppleGraph appleGraph = new AppleGraph();
              appleGraph.fillAppleOneShot();
              //copy over to HiveAppleGraph
              HiveAppleGraph hAppleGraph = data.appleGraph;
              hAppleGraph.backSupp = appleGraph.backSupp;
              hAppleGraph.legSupp = appleGraph.legSupp;
              hAppleGraph.backCenter = appleGraph.backCenter;
              hAppleGraph.totalTime = appleGraph.totalTime;

              //Set HivePostureGraph
              //first make use of postureGraph methods
              PostureGraph postureGraph = new PostureGraph();
              postureGraph.fillInPositionTimeLs();
              postureGraph.calculateTotalSittingPerHour();
              postureGraph.setTopThreePositions();
              //copy over to HivePostureGraph
              HivePostureGraph hPostureGraph = data.postureGraph;
              hPostureGraph.topThreePositions = postureGraph.topThreePositions;
              hPostureGraph.totalSittingPerHour = postureGraph.totalSittingPerHour;
              hPostureGraph.greenPositionTime = postureGraph.greenPositionTime;
              hPostureGraph.yellowPositionTime = postureGraph.yellowPositionTime;
              hPostureGraph.redPositionTime = postureGraph.redPositionTime;

              data.save();
              log("TABLE 3 UPDATED");
            });

          }
          //updateAppleData();
          //TODO Clear Table 1?
          box.clear();
        }

      }
    }});
  }

  Future<void> sendReminder() async{
    FlutterBlue.instance.connectedDevices.then((connectedDevicesList) async {if(connectedDevicesList.isNotEmpty){
      final prefs = await SharedPreferences.getInstance();
      String pulseDecision = prefs.getString('Haptics')??"1";
      List<BluetoothCharacteristic> cList;
      connectedDevicesList.single.discoverServices().then((services) {
        cList = services[2].characteristics;
        log(cList.toString());
        //SEND HAPTIC FEEDBACK
        cList.firstWhere((c) => c.uuid.toString()=="c53e7632-9a2b-4272-b1a8-d2f4d658752a").write(utf8.encode(pulseDecision));
      });
    }});
  }


  Future<void> writeContent(List<double> sensorData) async {//sensorData is in bytes

    // log(sensorData.toString());
    DateTime currentDatetime = DateTime.now();
    predictAndStore(currentDatetime,sensorData);
  }

  //connectedDevicesList.single.discoverServices().then((services) => services[2].characteristics.firstWhere((c) => c.uuid.toString()=="4cee02fe-dc6f-4a6a-b8fa-789d79058177").read().then((sensorDataBytes) {
  Future<void> logAndWriteSensorData(List<BluetoothDevice> connectedDevicesList) async {
    connectedDevicesList.single.discoverServices().then((services) => services[2].characteristics.last.read().then((sensorDataBytes) {
      List<double> sensorData = (String.fromCharCodes(sensorDataBytes)).split(",").map(double.parse).toList();
      //Show incoming data in Run Log
      log(sensorData.toString());
      //Write to Hive
      try{
        sensorData.add(170); //height
        sensorData.add(63); //weight
        writeContent(sensorData);
      } catch(e){
        log(e.toString());
        log("FAILED TO WRITE TO HIVE");
      }
    }));
  }

  Future<void> logUUID(List<BluetoothDevice> connectedDevicesList) async {
    String UUID = "-";
    connectedDevicesList.single.discoverServices().then((services) {UUID = services[2].characteristics.last.uuid.toString();} );
    log("UUID: "+UUID);
  }


  void updateRawData() {
    log("Checking for incoming Raw Data...");
    log(DateFormat.Hms().format(DateTime.now()));
    FlutterBlue.instance.connectedDevices.then((connectedDevicesList) {if(connectedDevicesList.isNotEmpty) {
      try{
        logAndWriteSensorData(connectedDevicesList);
        //connectedDevicesList.single.discoverServices().then((services) => services[2].characteristics.firstWhere((characteristic) => (characteristic.uuid.toString()=="4cee02fe-dc6f-4a6a-b8fa-789d79058177")).read().then((sensorData) => writeContent(sensorData)));
        log("UPDATED RAW DATA");
      } catch(e){
        log(e.toString());
        log("COULD NOT UPDATE");
      }

      // BluetoothCharacteristic.fromProto(p);
      // c.read().then((sensorData) => writeContent(sensorData))
      //                         .catchError((error){
      //                           print('Caught $error');
      //                         });

    }});
  }


  @override
  Widget build(BuildContext context) {
    final tabs = {
      'Archive': ArchiveWidget(),
      'Today': TodayWidgetFilled(), //TodayWidget(), for the actual
      'Settings': SettingsWidget(),
    };
    return Scaffold(
      body: tabs[_currentPage],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.date_range,
              size: 24,
            ),
            activeIcon: Icon(
              Icons.date_range_outlined,
              size: 24,
            ),
            label: 'Archive',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.data_usage,
              size: 24,
            ),
            activeIcon: Icon(
              Icons.data_usage_outlined,
              size: 24,
            ),
            label: 'Today',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
              size: 24,
            ),
            activeIcon: Icon(
              Icons.settings_outlined,
              size: 24,
            ),
            label: 'Settings',
          )
        ],
        backgroundColor: FlutterFlowTheme.primaryColor,
        currentIndex: tabs.keys.toList().indexOf(_currentPage),
        selectedItemColor: FlutterFlowTheme.secondaryColor,
        unselectedItemColor: FlutterFlowTheme.tertiaryColor,
        onTap: (i) => setState(() => _currentPage = tabs.keys.toList()[i]),
        showSelectedLabels: true,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
