import 'dart:io';

import 'package:better_sitt/model/positions.dart';
import 'package:better_sitt/utils/positions_processing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:sklite/tree/tree.dart';



void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  // // WidgetsFlutterBinding.ensureInitialized();
  // // await Hive.initFlutter();
  //
  // Hive.registerAdapter(PositionsAdapter());
  // await Hive.openBox<Positions>('positions');


  test("Model setting up", () async {
    final model = await Model.create();
    expect(model.model is DecisionTreeClassifier,true);
  });

  test('Model prediction testing', () async {
    final model = await Model.create();
    List<double> input = [0,0,0,0,0,0,0,0,0];
    int prediction = model.predict(input);
    expect(prediction, 2);
  });

  // test('Hive input',(){
  //   addPositions("00:00:00",0);
  //   getPositions(0);
  // });
}