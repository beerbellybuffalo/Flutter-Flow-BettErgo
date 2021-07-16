import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
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

Future<void> addPositions(DateTime dateTime,int position ) async {

  final position = Positions()
    ..dateTime = dateTime
    ..position = 0;

  final box = Boxes.getPositions();
  box.add(position);
}

Future<void> getPositions(int index) async{
  final box = Boxes.getPositions();
  box.getAt(index);
}

Future<void> predictAndStore(DateTime dateTime, List<double> sensor_vals) async{
  final model = await Model.create();
  int position = model.predict(sensor_vals);
  addPositions(dateTime, position);
}

class Model{
  DecisionTreeClassifier model;

  // Private constructor, use create() to get an instance
  Model._();

// Future that completes when the new Calendar is ready to use
  static Future<Model> create() async {
    Model model = Model._();
    await model._getModel();
    return model;
  }

  Future<void> _getModel() async {
    String x = await loadModel("assets/model/postureprediction_tree.json");
    this.model =  DecisionTreeClassifier.fromMap(json.decode(x));
    log("Model loaded: "+this.model.toString());
  }

  int predict(List<double >input) {
    return this.model.predict(input);
  }

}
