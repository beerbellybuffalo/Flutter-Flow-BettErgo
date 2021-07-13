import 'dart:convert';
import 'dart:developer';
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

  Model() {
    getModel();
  }

  void getModel() {
    loadModel("postureprediction_tree.json").then((x) {
      this.model =  DecisionTreeClassifier.fromMap(json.decode(x));
      log("Model loaded: "+this.model.toString());
    });
  }

  Future<int> modelPredict(List<double >input) async{
    log(this.model!.predict(input).toString());
    return this.model!.predict(input);
  }

}
