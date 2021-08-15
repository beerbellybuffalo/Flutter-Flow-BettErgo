import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:better_sitt/model/processed_data.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:better_sitt/model/raw_data.dart';
import 'package:flutter/material.dart';
import 'package:sklite/tree/tree.dart';
import 'package:sklite/utils/io.dart';

import 'boxes.dart';

//Read data from json, inplace of bluetooth, can take away
Future<Map> getData(context) async {
  String data =
      await DefaultAssetBundle.of(context).loadString("assets/yixuan.json");
  // final jsonResult = await json.decode(data);
  // return jsonResult;
  return json.decode(data);
}

//Adds a position and datetime in hive
Future<void> addRawData(DateTime dateTime,int position ) async {

  final rawData = RawData()
    ..dateTime = dateTime
    ..position = position;

  final box = Boxes.getRawDataBox();
  box.add(rawData);
}

//Given an index, get the object aka "row" in hive
Future<RawData?> getRawData(int index) async{
  final box = Boxes.getRawDataBox();
  return box.getAt(index);
}

Future<void> addProcessedData(DateTime _dateTime,int _position,String _category) async {

  final processedData = ProcessedData()
    ..dateTime = _dateTime
    ..position = _position
    ..category = _category;

  final box = Boxes.getProcessedDataBox();
  box.add(processedData);
}

//Given an index, get the object aka "row" in hive
Future<ProcessedData?> getProcessedData(int index) async{
  final box = Boxes.getProcessedDataBox();
  return box.getAt(index);
}

<<<<<<< HEAD
// Predicts and stores the value in hive
Future<void> predictAndStore(DateTime dateTime, List<double> sensor_vals) async {
  final model = await Model.create();
  int position = model.predict(sensor_vals);
  addRawData(dateTime, position);
}

class Model {
  late DecisionTreeClassifier model;

  // Private constructor, use create() to get an instance
  Model._();
=======
>>>>>>> parent of 821f272 (Merge pull request #6 from beerbellybuffalo/daniel)

  // Future that completes when the new Model is ready to use
  static Future<Model> create() async {
    stderr.writeln("harlo");
    Model model = Model._();
    await model._getModel();
    return model;
  }

  // Constructs model from weights in postureprediction.json
  Future<void> _getModel() async {
    String x = await loadModel("assets/model/postureprediction_tree.json");
    this.model = DecisionTreeClassifier.fromMap(json.decode(x));
    log("Model loaded: " + this.model.toString());
  }

  //predicts given a list of values
  int predict(List<double> input) {
    return this.model.predict(input);
  }
}
