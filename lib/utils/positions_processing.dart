import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:better_sitt/model/positions.dart';
import 'package:flutter/material.dart';
import 'package:sklite/tree/tree.dart';
import 'package:sklite/utils/io.dart';

import 'boxes.dart';

Future<Map> getData(context) async {
  String data =
  await DefaultAssetBundle.of(context).loadString("assets/yixuan.json");
  // final jsonResult = await json.decode(data);
  // return jsonResult;
  return json.decode(data);
}

Future<void> addPositions(String dateStr,int position ) async {
  DateTime date =  DateTime.parse("2012-02-27 " + dateStr);

  final position = Positions()
    ..dateTime = date
    ..position = 0;

  final box = Boxes.getPositions();
  box.add(position);
}

class Model{
  DecisionTreeClassifier model;

  // Private constructor, use create() to get an instance
  Model._();

// Future that completes when the new Calendar is ready to use
  static Future<Model> create() async {
    Model model = Model._();
    await model._getModel();
    stderr.writeln("Model is"+model.model.toString());
    return model;
  }

  Future<void> _getModel() async {
    log("loading model");
    loadModel("postureprediction_tree.json").then((x) {
      log("loading model");
      stderr.writeln(x);

      this.model =  DecisionTreeClassifier.fromMap(json.decode(x));
      log("Model loaded: "+this.model.toString());
    });

    // String modelWeights =await loadModel("postureprediction_tree.json");
    stderr.writeln("Hello");
    // this.model = DecisionTreeClassifier.fromMap(json.decode(modelWeights));
    stderr.writeln("function model is"+model.toString());
  }

  Future<int> predict(List<double >input) async {
    log(this.model.predict(input).toString());
    return this.model.predict(input);
  }

}
