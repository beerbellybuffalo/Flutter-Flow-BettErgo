import 'dart:developer';
import 'dart:io';

import 'package:better_sitt/utils/positions_processing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sklite/tree/tree.dart';

void main() {
  test("Model setting up", () async {

    final model = await Model.create();
    stderr.writeln("Model is"+model.model.toString());
    expect(model.model, null);
  });
  // test('Model testing', () async {
  //   final model = Model();
  //   List<double> input = [0,0,0,0,0,0,0,0,0];
  //   int prediction = await model.predict(input);
  //
  //   log(prediction.toString());
  //
  //   expect(prediction, 1);
  // });
}