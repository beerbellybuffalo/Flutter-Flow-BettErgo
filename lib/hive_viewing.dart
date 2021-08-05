import 'dart:convert';
import 'dart:developer';
import 'package:better_sitt/model/raw_data.dart';
import 'package:better_sitt/utils/boxes.dart';
import 'package:better_sitt/utils/positions_processing.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:sklite/tree/tree.dart';
import 'package:sklite/utils/io.dart';

import 'model/processed_data.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(RawDataAdapter());
  await Hive.openBox<RawData>('rawdata');
  Hive.registerAdapter(ProcessedDataAdapter());
  await Hive.openBox<ProcessedData>('processeddata');

  runApp(HiveViewing());
}

class HiveViewing extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: HiveViewingApp(title: 'Flutter Demo Home Page'),
    );
  }
}

class HiveViewingApp extends StatefulWidget {
  HiveViewingApp({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _HiveViewingState createState() => _HiveViewingState();
}

class _HiveViewingState extends State<HiveViewingApp> {
  var rawBox = Boxes.getRawDataBox();
  var processedBox = Boxes.getProcessedDataBox();
  var _currentState = "raw";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void addRandomData(){
    switch (_currentState) {
      case "raw":
        predictAndStore(DateTime(2021, 8, 5), [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 170, 66]);
        break;
      case "processed":
        addProcessedData(DateTime(2021, 8, 5),1,"G");
        break;
    }
  }
  void _openDrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }

  void _closeDrawer() {
    Navigator.of(context).pop();
  }

  void clearTable(){
    switch (_currentState) {
      case "raw":
        clearRawDataTable();
        break;
      case "processed":
        clearProcessedTable();
        break;
    }
  }


  Widget bodyFunction() {
    switch (_currentState) {
      case "raw":
        return ValueListenableBuilder<Box<RawData>>(
            valueListenable: rawBox.listenable(),
            builder: (context, box, _) {
              final positions = box.values.toList().cast<RawData>();
              return buildRawContent(positions);
            });
        break;
      case "processed":
        return ValueListenableBuilder<Box<ProcessedData>>(
            valueListenable: processedBox.listenable(),
            builder: (context, box, _) {
              final positions = box.values.toList().cast<ProcessedData>();
              return buildProcessedContent(positions);
            });
        break;
      default:
        return ValueListenableBuilder<Box<RawData>>(
            valueListenable: rawBox.listenable(),
            builder: (context, box, _) {
              final positions = box.values.toList().cast<RawData>();
              return buildRawContent(positions);
            });
        break;
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text(_currentState),
        centerTitle: true,
      ),
      body: bodyFunction(),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FloatingActionButton(
              onPressed:addRandomData,
              child: const Icon(Icons.add),
            ),
            FloatingActionButton(
              onPressed:clearTable,
              child: Icon(Icons.delete),
            )
          ],
        ),
      ),
    drawer: Drawer(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('This is the Drawer'),
            ElevatedButton(
              onPressed: (){setState(() {
                _currentState = "raw";
              });
              _closeDrawer();},
              child: const Text('RawData'),
            ),
            ElevatedButton(
              onPressed: (){setState(() {
                _currentState = "processed";
              });
              _closeDrawer();},
              child: const Text('Processed Data'),
            ),
            ElevatedButton(
              onPressed: (){_closeDrawer();},
              child: const Text('Visualisation Data (not yet)'),
            ),
          ],
        ),
      ),
    ),
    // Disable opening the drawer with a swipe gesture.
    drawerEnableOpenDragGesture: false,
  );

  Widget buildRawContent(List<RawData> positions) {
    if (positions.isEmpty) {
      return Center(
        child: Text(
          'No positions yet!',
          style: TextStyle(fontSize: 24),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: positions.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
                'Position: ${positions[index].position}, Time: ${positions[index].dateTime}'),
          );
        },
      );
    }
  }
  Widget buildProcessedContent(List<ProcessedData> positions) {
    if (positions.isEmpty) {
      return Center(
        child: Text(
          'No positions yet!',
          style: TextStyle(fontSize: 24),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: positions.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
                'Position: ${positions[index].position}, Time: ${positions[index].dateTime}'),
          );
        },
      );
    }
  }
}
