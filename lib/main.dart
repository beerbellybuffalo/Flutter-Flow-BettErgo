import 'dart:developer';

import 'package:better_sitt/first_page/first_page_widget.dart';
import 'package:better_sitt/model/rawdata.dart';
import 'package:better_sitt/registration/registration_widget.dart';
import 'package:better_sitt/utils/positions_processing.dart';
import 'package:flutter/material.dart';
import 'package:better_sitt/today/today_widget.dart';
import 'package:intl/intl.dart';
import 'flutter_flow/flutter_flow_theme.dart';
import 'archive/archive_widget.dart';
import 'model/processeddata.dart';
import 'today/today_widget.dart';
import 'settings/settings_widget.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:async';
import 'package:flutter_blue/flutter_blue.dart';
import '../bluetooth/bluetooth_widget.dart';
import 'utils/boxes.dart';
import 'utils/positions_processing.dart';
import 'today/today_classes.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(RawDataAdapter());
  await Hive.openBox<RawData>('rawdata');
  Hive.registerAdapter(ProcessedDataAdapter());
  await Hive.openBox<ProcessedData>('processeddata');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BetterSitt',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FirstPageWidget(),
      debugShowCheckedModeBanner: false,
    );
  }
}

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
  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage ?? _currentPage;
    sumMinuteTimer = new Timer.periodic(Duration(minutes: 1), (timer){findModalPosition();});
  }

  @override
  void dispose(){
    super.dispose();
    sumMinuteTimer.cancel();
  }

  void findModalPosition() {
    log('FINDING MODAL POSITION');
    FlutterBlue.instance.connectedDevices.then((connectedDevicesList) {if(connectedDevicesList.isNotEmpty){
      //TODO summarise the rawdata and write to hive
      List<int> positionLs = List<int>.filled(19, 0); // 19 positions including null
      var box = Boxes.getRawDataBox();
      var box2 = Boxes.getProcessedDataBox();
      //Check if >= 1minute has elapsed
      if (box.getAt(box.length-1)!.dateTime.minute>box.getAt(0)!.dateTime.minute){
        for (int i=0;i<box.length;i++) {
          positionLs[box.getAt(i)!.position]++;
        }
        int modalPos = positionLs[0];
        for (int i=1;i<positionLs.length;i++){
          if (positionLs[i]>modalPos) {
            modalPos = positionLs[i];
          }
        }
        addProcessedData(box.getAt(box.length-2)!.dateTime, modalPos, checkPostureCategory(modalPos));
      }
      //connectedDevicesList.single.discoverServices().then((services) => services[2].characteristics.firstWhere((characteristic) => (characteristic.uuid.toString()=="4cee02fe-dc6f-4a6a-b8fa-789d79058177")));
      //device.discoverServices().then((services) => services[2].uuid);
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
