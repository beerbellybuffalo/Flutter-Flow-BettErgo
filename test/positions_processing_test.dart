import 'dart:developer';
import 'dart:io';


import 'package:better_sitt/utils/positions_processing.dart';

import 'package:flutter_test/flutter_test.dart';




void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();


  test('Model prediction testing no one sitting', () async {
    List<double> input = [0,0,0,0,0,0,0,0,0,0,0,170,66];
    int prediction = await predict(input);
    expect(prediction, 0);
  });

  test('Model prediction testing leaning forward, middle', () async {
    List<double> input = [98.53,0.0,102.2,256.65,100.73,197.07,232.36,108.18,179.61,0.0,0.0,170,66];
    int prediction = await predict(input);
    expect(prediction, 10);
  });

  test('Model prediction testing supported, middle', () async {
    List<double> input = [104.03,0.0,97.31,271.67,80.95,172.65,181.68,134.92,168.86,59.83,54.0,170,66];
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
