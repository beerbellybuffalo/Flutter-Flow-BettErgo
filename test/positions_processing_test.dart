import 'dart:io';

import 'package:better_sitt/model/positions.dart';
import 'package:better_sitt/utils/positions_processing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';



void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Model prediction testing no one sitting', () async {
    List<double> input = [0,0,0,0,0,0,0,0,0,0,0,170,66];
    int prediction = await predict(input);
    expect(prediction, 0);
  });

  test('Model prediction testing leaning forward, middle', () async {
    List<double> input = [98.29,0.0,101.34,258.49,99.27,195.36,232.23,106.11,177.41,0.0,0.0,170,66];
    int prediction = await predict(input);
    expect(prediction, 10);
  });

  test('Model prediction testing supported, middle', () async {
    List<double> input = [87.06,0.0,98.53,254.21,100.73,189.74,232.36,101.1,168.38,0.0,1.4,170,66];
    int prediction = await predict(input);
    expect(prediction, 11);
  });
  // test('Model prediction testing leaning backward, middle', () async {
  //   // final model = await Model.create();
  //   List<double> input = [122.47,0.0,144.69,244.08,132.84,193.28,202.69,154.09,187.18,146.52,86.5,170,66];
  //   int prediction = await predict(input);
  //   expect(prediction, 12);
  // });
}