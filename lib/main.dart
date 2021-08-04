import 'dart:developer';

import 'package:better_sitt/first_page/first_page_widget.dart';
import 'package:better_sitt/model/raw_data.dart';
import 'package:better_sitt/registration/registration_widget.dart';
import 'package:better_sitt/utils/positions_processing.dart';
import 'package:flutter/material.dart';
import 'package:better_sitt/today/today_widget.dart';
import 'package:intl/intl.dart';
import 'flutter_flow/flutter_flow_theme.dart';
import 'archive/archive_widget.dart';
import 'model/processed_data.dart';
// import 'package:better_sitt/login_v1/models/user.dart';
// import 'package:better_sitt/login_v1/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'login_v1/authentication_services.dart';
import 'login_v1/login_v1_widget.dart';
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
  await Hive.openBox<RawData>('rawdata');
  Hive.registerAdapter(ProcessedDataAdapter());
  await Hive.openBox<ProcessedData>('processeddata');

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

        '/today': (context) => TodayWidget(),
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

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage ?? _currentPage;
    sumMinuteTimer = new Timer.periodic(Duration(minutes: 1), (timer){findModalPosition();});
    oneSecTimer = new Timer.periodic(Duration(seconds: 1), (timer){updateRawData();});
    checkHiveTables().then((value) {
      print(table1Data);
      print(table2Data);
    });
  }

  Future<void> checkHiveTables() async {

    var table1 = Boxes.getRawDataBox();
    var table2 = Boxes.getProcessedDataBox();
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
  }

  @override
  void dispose(){
    //log("NavBarPage was Killed");
    super.dispose();
    sumMinuteTimer.cancel();
    oneSecTimer.cancel();
  }

  void findModalPosition() {
    log("Checking if need to find Modal Position...");
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
      if (box.getAt(box.length-1)!.dateTime.minute>box.getAt(0)!.dateTime.minute){
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
        //decide whether to input 'A' or 'B' into the box
        String addCat;
        if (checkPostureCategory(modalPos)=='A' && isBreak()) {
          addCat = 'B';
        }
        else{addCat = checkPostureCategory(modalPos);}
        //add entry to Table2
        addProcessedData(box.getAt(box.length-2)!.dateTime, modalPos, addCat);
        //TODO add entry to Table3
        //var box3 = Boxes.getVisualisationDataBox();
        //get the entry
        //updateApple();
        //TODO Clear Table 1?
        box.clear();
      }
    }});
  }

  Future<void> writeContent(List<double> sensorData) async {//sensorData is in bytes

    // log(sensorData.toString());
    DateTime currentDatetime = DateTime.now();
    predictAndStore(currentDatetime,sensorData);
  }

  Future<void> logAndWriteSensorData(List<BluetoothDevice> connectedDevicesList) async {
    connectedDevicesList.single.discoverServices().then((services) => services[2].characteristics.last.read().then((sensorDataBytes) {
      List<double> sensorData = (String.fromCharCodes(sensorDataBytes)).split(",").map(double.parse).toList();
      //Show incoming data in Run Log
      log(sensorData.toString());
      //Write to Hive
      try{
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
      'Today': TodayWidget(),
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
