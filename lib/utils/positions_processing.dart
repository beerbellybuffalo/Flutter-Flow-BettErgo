import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:better_sitt/model/apple_graph.dart';
import 'package:better_sitt/model/posture_graph.dart';
import 'package:better_sitt/model/processed_data.dart';
import 'package:better_sitt/model/rings.dart';
import 'package:better_sitt/model/visualisation_data.dart';
import 'package:better_sitt/today/today_classes.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:better_sitt/model/raw_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:ml_dataframe/ml_dataframe.dart';
// import 'package:ml_algo/ml_algo.dart';
import 'package:sklite/utils/io.dart';
import 'package:sklite/tree/tree.dart';
import 'boxes.dart';

// Future<Model> futureModel = Model.create();

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

Future<void> clearRawDataTable() async{
  final box = Boxes.getRawDataBox();
  box.clear();
}

Future<void> clearProcessedTable() async{
  final box = Boxes.getProcessedDataBox();
  box.clear();
}

Future<void> clearVisualisationTable() async{
  final box = Boxes.getVisualisationDataBox();
  box.clear();
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

Future<void> putVisualisationData(HiveRings _rings, HiveAppleGraph _appleGraph, HivePostureGraph _postureGraph) async {

  final visualisationData = VisualisationData()
    ..rings = _rings
    ..appleGraph = _appleGraph
    ..postureGraph = _postureGraph;

  final box = Boxes.getVisualisationDataBox();
  box.put(DateTime.now().toIso8601String(), visualisationData);
}

//TODO getVisualisationData
Future<VisualisationData?> getVisualisationData(int index) async{
  final box = Boxes.getVisualisationDataBox();
  return box.getAt(index);
}

Future<int> predict(List<double> sensor_vals) async{
  var flag = sensor_vals.getRange(0, 9).toList().every((e)=>e==0);
  if (flag) {
    return 0;
  }else {
    String response = await rootBundle.loadString('assets/model/ml_algo.json');
    DecisionTreeClassifier model = await getModel();
    stderr.writeln("Model loaded: "+model.toString());
    // final model = DecisionTreeClassifier.fromJson(response);
    final data = sensor_vals.getRange(0, 9).toList()+sensor_vals.getRange(11, 13).toList();
    log(data.toString());
    // final df = DataFrame(data, headerExists: false);
    // int position = model
    //     .predict(df)
    //     .rows
    //     .first
    //     .first
    //     .toInt();
    // Model model = await futureModel;

    int position = model.predict(data);

    if (sensor_vals[9] ==0 && sensor_vals[10]== 0) {
      if (position == 2) {
        position = 1;
      } else if (position == 5) {
        position = 4;
      }
    } else{
      if (position ==1){
        position =2;
      }else if (position ==4){
        position =5;
      }
    }


    var left = (sensor_vals[0] + sensor_vals[3] + sensor_vals[6]) / 3;
    var right = (sensor_vals[2] + sensor_vals[5] + sensor_vals[8]) / 3;


    if ((left - right).abs() < 50) {
      return position + 6;
    } else if (left > right) {
      return position;
    } else {
      return position +12;
    }
  }

}

// Predicts and stores the value in hive
Future<void> predictAndStore(DateTime dateTime, List<double> sensor_vals) async{
  int position =  await predict(sensor_vals);
  addRawData(dateTime, position);
}

// static Future<Model> create() async {
//   Model model = Model();
//   await model._getModel();
//   return model;
// }

// Constructs model from weights in postureprediction.json
Future<DecisionTreeClassifier> getModel() async {
  String x = await loadModel("assets/model/postureprediction_tree.json");
  // log("some string" +x);
  DecisionTreeClassifier model =  DecisionTreeClassifier.fromMap(json.decode(x));
  log("Model loaded: "+model.toString());
  return model;
}

// class Model{
//   // DecisionTreeClassifier model;
//
//   // Private constructor, use create() to get an instance
//   // Model._();
//
//   // Future that completes when the new Model is ready to use
//   static Future<Model> create() async {
//     Model model = Model();
//     await model._getModel();
//     return model;
//   }
//
//   // Constructs model from weights in postureprediction.json
//   Future<void> _getModel() async {
//     String x = await loadModel("assets/model/postureprediction.json");
//     this.model =  DecisionTreeClassifier.fromMap(json.decode(x));
//     log("Model loaded: "+this.model.toString());
//   }
//
//   //predicts given a list of values
//   int predict(List<double >input) {
//     return this.model.predict(input);
//   }
// }