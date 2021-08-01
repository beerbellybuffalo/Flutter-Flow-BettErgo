import 'dart:developer';
import 'dart:io';

import 'package:better_sitt/model/processeddata.dart';
import 'package:better_sitt/model/rawdata.dart';
import 'package:better_sitt/utils/boxes.dart';
import 'package:better_sitt/utils/positions_processing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sklite/tree/tree.dart';



void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  // WidgetsFlutterBinding.ensureInitialized();
  // await Hive.initFlutter();
  //
  // Hive.registerAdapter(PositionsAdapter());
  // await Hive.openBox<Positions>('Table 2');

  await Hive.initFlutter();
  //
  Hive.registerAdapter(RawDataAdapter());
  await Hive.openBox<RawData>('rawdata');
  Hive.registerAdapter(ProcessedDataAdapter());
  await Hive.openBox<ProcessedData>('processeddata');


  // test("test test",() {
  //   expect("1","1");
  // });
  //
  // test("Model setting up", () async {
  //   final model = await Model.create();
  //   expect(model.model is DecisionTreeClassifier,true);
  // });
  //
  // test('Model prediction testing', () async {
  //   final model = await Model.create();
  //   List<double> input = [0,0,0,0,0,0,0,0,0];
  //   int prediction = model.predict(input);
  //   expect(prediction, 2);
  // });

  test('Check Hive Tables', () async {

    var table1 = Boxes.getRawDataBox();
    var table2 = Boxes.getProcessedDataBox();
    print(table1.values);
    print(table2.values);
    //LOG TABLE 1 DATA
    String table1Data = "table1Data: ";
    for (int i=0;i<table1.length;i++) {
      getRawData(i).then((rawData) => table1Data += (rawData!.dateTime.toString() + rawData.position.toString() + "\n"));
    }
    print(table1Data);
    //LOG TABLE 2 DATA
    String table2Data = "table2Data: ";
    for (int i=0;i<table2.length;i++) {
      getProcessedData(i).then((processedData) {table2Data += (processedData!.dateTime.toString() + processedData.position.toString() + processedData.category.toString() + "\n");});
    }
    print(table2Data);
    expect(table2Data, null);
  });

  // test('Hive input',(){
  //   addPositions("00:00:00",0);
  //   getPositions(0);
  // });
}