import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:better_sitt/model/rawdata.dart';
import 'package:flutter/material.dart';
import 'package:sklite/tree/tree.dart';
import 'package:sklite/utils/io.dart';

import 'boxes.dart';


//Read data from json, in place of bluetooth, can take away
Future<Map> getData(context) async {
  String data =
  await DefaultAssetBundle.of(context).loadString("assets/yixuan.json");
  // final jsonResult = await json.decode(data);
  // return jsonResult;
  return json.decode(data);
}

//Adds a position and datetime in hive
Future<void> addRawData(DateTime dateTime,int position ) async {

  final position = RawData()
    ..dateTime = dateTime
    ..position = 0;

  final box = Boxes.getRawDataBox();
  box.add(position);
}

//Given an index, get the row in hive
Future<void> getRawData(int index) async{
  final box = Boxes.getRawDataBox();
  box.getAt(index);
}

// Predicts and stores the value in hive
Future<void> predictAndStore(DateTime dateTime, List<double> sensor_vals) async{
  final model = await Model.create();
  int position = model.predict(sensor_vals);
  addRawData(dateTime, position);
}

class Model{
  late DecisionTreeClassifier model;

  // Private constructor, use create() to get an instance
  Model._();

  // Future that completes when the new Model is ready to use
  static Future<Model> create() async {
    Model model = Model._();
    await model._getModel();
    return model;
  }

  // Constructs model from weights in postureprediction.json
  Future<void> _getModel() async {
    String x = await loadModel("assets/model/postureprediction_tree.json");
    this.model =  DecisionTreeClassifier.fromMap(json.decode(x));
    log("Model loaded: "+this.model.toString());
  }

  //predicts given a list of values
  int predict(List<double >input) {
    return this.model.predict(input);
  }

}
