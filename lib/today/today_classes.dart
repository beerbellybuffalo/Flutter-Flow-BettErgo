// // Things to do:
// // - Total Sitting Time
// // - Good Sitting Time
// // - Position Change Frequency
// // - Horizontal Scroll Charts:
// //    1. With Time
// //    2. Stacked Bar Graph, i.e. No Time
//

import 'dart:core';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import '../utils/positions_processing.dart';
import '../utils/boxes.dart';
import '../model/raw_data.dart';
import '../model/processed_data.dart';
import '../model/visualisation_data.dart';
//var inComingData = new List();


class Rings {
  int totalSittingTime = 0;
  int goodSittingTime = 0;
  int postureChangeFrequency = 0;
  double innerRing = 0;
  double outerRing = 0;
  //Constructor
  //Rings(this.totalSittingTime,this.goodSittingTime,this.postureChangeFrequency,this.innerRing,this.outerRing);

  //Setters TODO these are just methods now instead of actual setters cos idk how to use set
  void setTotalSitting(int t){
    totalSittingTime = t;
  }
  void setGoodSitting(int t){
    goodSittingTime = t;
  }
  void setPosChange(int t){
    postureChangeFrequency = t;
  }
  void setInner(double d){
    innerRing = d;
  }
  void setOuter(double d){
    outerRing = d;
  }

  //Methods
  double calcInner(){
    double inner = this.totalSittingTime/60; //in hours
    return inner;
  }
  double calcOuter(){
    double outer = (this.goodSittingTime/this.totalSittingTime)*100; //percentage
    var table2 = Boxes.getProcessedDataBox();
    return outer;
  }
//end of Rings class
}



int calcTotalTime(){
  int totalTime = 0;
  var table2 = Boxes.getProcessedDataBox();
  for (int i=0;i<table2.length;i++) {
    getProcessedData(i).then((processedData) {
      if (processedData!.category!='A'||processedData.category!='B') { //not away or break
        totalTime++; //add to count if sitting
      }
    });
  }
  return totalTime;
}


int calcGoodTime(){
  int goodTime = 0;
  var table2 = Boxes.getProcessedDataBox();
  for (int i=0;i<table2.length;i++) {
    getProcessedData(i).then((processedData) {
      if (processedData!.category=='G') {
        goodTime++; //add to count if G for good
      }
    });
  }
  return goodTime;
}

int calcPostureChangeFreq(Rings ringsInstance){
  int freq = 0;
  int prevPos = 0;
  var table2 = Boxes.getProcessedDataBox();
  //initialise prevPos
  getProcessedData(0).then((processedData) => prevPos = processedData!.position);
  for (int i=0;i<table2.length;i++) {
    getProcessedData(i).then((processedData) {
      if (processedData!.position != prevPos) {
        freq++; //add to change countmap obje
      }
    });
  }
  return (ringsInstance.totalSittingTime/freq).round(); //3.5 to 4, -3.5 to -4
}

class AppleGraph {
  //categorisation lists
  List<int> backSuppPostures = [2,5,8,11,14,17];
  List<int> backCenterPostures = [7,8,9,10,11,12];
  List<int> legSuppPostures = [4,5,6,10,11,12,16,17,18];

  var backSupp = List<int>.filled(24, 0, growable: false);
  var backCenter = List<int>.filled(24, 0, growable: false);
  var legSupp = List<int>.filled(24, 0, growable: false);
  var totalTime = List<int>.filled(24, 0, growable: false);

  //CONSTRUCTOR
  //AppleGraph(this.totalTime,this.backCenter,this.backSupp,this.legSupp);
  //Setters


  //Methods
  //1. One-shot version
  var table2 = Boxes.getProcessedDataBox();
  void fillAppleOneShot() {
    for (int i=0;i<table2.length;i++) {
      getProcessedData(i).then((processedData) {
        int hour = processedData!.dateTime.hour;
        if (backSuppPostures.contains(processedData.position)) {
          backSupp[hour]++;
        }
        else if (backCenterPostures.contains(processedData.position)) {
          backCenter[hour]++;
        }
        else if (legSuppPostures.contains(processedData.position)) {
          legSupp[hour]++;
        }
      });
    }
  }
  //2. Incremental version called every minute
  void updateApple(RawData data) {
    int hour = data.dateTime.hour;
    if (backSuppPostures.contains(data.position)) {
      backSupp[hour]++;
    }
    else if (backCenterPostures.contains(data.position)) {
      backCenter[hour]++;
    }
    else if (legSuppPostures.contains(data.position)) {
      legSupp[hour]++;
    }
  }

}

class PostureGraph{
  // Purpose of PostureGraph:
  //  1. Draw information from table 2 process it and push to list
  //  2. Hold the list[19] to plot the graph with

  // list[19]: corresponding to time spend in each position
  var greenPositionTime = new List.filled(19, 0); // [11]
  var yellowPositionTime = new List.filled(19, 0); // [2,5,8,14,17]
  var redPositionTime = new List.filled(19, 0); // [1,3,4,6,7,9,10,12,13,15,16,18]
  var totalSittingPerHour = new List.filled(19, 0);
  var topThreePositions = new List.filled(3, 0);

  //CONSTRUCTOR
  //PostureGraph(this.greenPositionTime,this.yellowPositionTime,this.redPositionTime,this.totalSittingPerHour,this.topThreePositions);

  Box<ProcessedData> box = Boxes.getProcessedDataBox();

  // // To continue where you left off
  // int lastInd = 0;

  void calculateTotalSittingPerHour(){
    for (int i = 0; i<greenPositionTime.length; i++){
      totalSittingPerHour[i] += greenPositionTime[i];
      totalSittingPerHour[i] += yellowPositionTime[i];
      totalSittingPerHour[i] += redPositionTime[i];
    }
  }

  //Add in time spent in each part of the list (see Alternative)
  void fillInPositionTimeLs(){
    // read whole list for 'G' an add to [11] of greenPositionTime
    for (int i = 0; i < box.length ; i++){
      getProcessedData(i).then((processedData){
        if( processedData!.category == 'G'){
          greenPositionTime[processedData.position]++; // only position 11 can be Green
        }
        if ( processedData.category == 'Y'){
          yellowPositionTime[processedData.position]++;
        }
        if ( processedData.category == 'R'){
          redPositionTime[processedData.position]++;
        }
      });
    }
  }
  // Alternative:
  //  everytime a reading is stored in table 2, a fn automatically updates
  //  the lists
  void updatePositionTimeLs(){
    // points to Table2.length
    getProcessedData(box.length-1).then((processedData){
      if (processedData!.category == 'G'){
        greenPositionTime[processedData.position]++;
      } else if (processedData.category == 'Y'){
        yellowPositionTime[processedData.position]++;
      } else if (processedData.category == 'R'){
        redPositionTime[processedData.position]++;
      }
    });
  }

  // returns list of Top 3 sitting position, i.e. [top,seconf,third]
  void setTopThreePositions (){
    int largestNum = 0;
    int secondNum = 0;
    int thirdNum = 0;

    List<int> ls = totalSittingPerHour;

    fillInPositionTimeLs();
    calculateTotalSittingPerHour();

    for (int i=0; i< ls.length; i++){
      if (ls[i] > largestNum){
        largestNum = ls[i];
      }
    }
    for (int i=0; i< ls.length; i++){
      if (ls[i] > secondNum && ls[i] != largestNum){
        secondNum = ls[i];
      }
    }
    for (int i=0; i< ls.length; i++){
      if (ls[i] > thirdNum && ls[i] < secondNum){
        thirdNum = ls[i];
      }
    }

    topThreePositions[0] = ls.indexOf(largestNum);
    topThreePositions[1] = ls.indexOf(secondNum);
    topThreePositions[2] = ls.indexOf(thirdNum);
    // return this.topThreePositions;
  }

}

// // For Total Sitting Time:
// class TotalSittingTime {
//   int totalSittingTime = 0;
//   int startingPoint = 0;
//   //var inComingData = new List();
//   var ls = []; //cannot initialise variable to List here because null safe?
//   var posNum = [1, 2, 3, 4, 5, 6, 7, 8];
//
//   //Constructor
//   TotalSittingTime(List<int?> tempLs) {
//     this.ls = tempLs;
//   }
//   int getTotalSittingTime() {
//     for (int i = startingPoint; i < ls.length; i++) {
//       if (posNum.contains(ls[i])) {
//         totalSittingTime++; // assuming called every minute
//       }
//
//     }
//     startingPoint = startingPoint + ls.length;
//
//     return totalSittingTime;
//   }
//
//   int getTotalSittingTimeText() {
//     return totalSittingTime;
//   }
// }
//
// //TODO update the unit tests to have 19 positions
// class GoodSittingTime{
//   int nullCounter = 0;
//   int sessionCounter = 0; //
//   int goodTimeLength = 0; //Green ring value
//
//   void incrementGoodPostureTime(int thisPosture) {
//     String currentPosCat = checkPostureCategory(thisPosture);
//     if (currentPosCat == "A") {
//       nullCounter++;
//     }
//     else {
//       sessionCounter++;
//       if (nullCounter > 5) {
//         //reset session
//         sessionCounter = 0;
//       }
//       if (sessionCounter <= 20 && currentPosCat == "G") {
//         goodTimeLength++;
//       }
//     }
//   }
// }

//used in main to check if user is taking a break
bool isBreak() {
  int awayCount = 0;
  var box2 = Boxes.getProcessedDataBox();
  for (int i=box2.length-5;i<box2.length;i++){
    getProcessedData(i).then((data) {
      if(data!.category=='B') {return true;}
      else if (data.category=='A') {
        awayCount++;
      }
    });
  }
  if (awayCount==5) {return true;}
  return false;
}

List<dynamic> setCategoryAndRemind(int _modalPos){
  var box2 = Boxes.getProcessedDataBox();
  var lastBreakIndex = 0;
  String newCat;
  bool needReminder = false;
  //ProcessedData? latestProcessedDataEntry = box2.getAt(box2.length-1);
  List<int> sinceLastBreak = [];
  //find last time there was a break
  for (int i = box2.length-1; i>0; i--){
    if (box2.getAt(i)!.category=='B') {lastBreakIndex=i; break;}
    else {sinceLastBreak.add(box2.getAt(i)!.position);}
    //getProcessedData(i).then((data) {if(data!.category=='B'){lastBreakIndex=i;}} );
  }

  List last5Positions = sinceLastBreak.sublist(sinceLastBreak.length-5);
  List last10Positions = sinceLastBreak.sublist(sinceLastBreak.length-10);
  List last20Positions = sinceLastBreak.sublist(sinceLastBreak.length-20);
  //needs standup if last break more than 30mins ago
  if (sinceLastBreak.length>30
    ||(checkPostureCategory(_modalPos)=='BAD' && last5Positions.any((element) => checkPostureCategory(element)=='BAD' && countInList(last5Positions, element)==5)==true)
    ||checkPostureCategory(_modalPos)=='MEH' && (last10Positions.any((element) => checkPostureCategory(element)=='MEH' && countInList(last10Positions, element)==10)==true)){
    newCat = 'R';
    needReminder = true;
  }
  else if(checkPostureCategory(_modalPos)=='GOOD' && last20Positions.any((element) => checkPostureCategory(element)=='GOOD' && countInList(last20Positions, element)==20)==true){
    newCat = 'Y';
    needReminder = true;
  }
  else{newCat = checkPostureCategory(_modalPos);}
  //if none of the above, then don't need reminder
  return [newCat,needReminder];
}

int countInList(List _list, dynamic thing){
  int count = 0;
  _list.forEach((element) {if (element==thing){count++;} });
  return count;
}

String checkPostureCategory(int thisPosture) {
  int away = 0;
  List<int> goodPos = [11];
  List<int> mehPos = [2, 5, 8, 14, 17];
  List<int> badPos = [1, 3, 4, 6, 7, 9, 10, 12, 13, 15, 16, 18];
  // var box2 = Boxes.getProcessedDataBox();
  // var lastBreakIndex = 0;
  // List<int> sinceLastBreak = [];
  // //find last time there was a break
  // for (int i = box2.length-1; i>0; i--){
  //   if (box2.getAt(i)!.category=='B') {lastBreakIndex=i; break;}
  //   else {sinceLastBreak.add(box2.getAt(i)!.position);}
  //   //getProcessedData(i).then((data) {if(data!.category=='B'){lastBreakIndex=i;}} );
  // }
  // if (sinceLastBreak.length>30){
  //   return 'R';
  // }
  // else if (goodPos.contains(thisPosture)) {
  //   int goodPosCount = 0;
  //   sinceLastBreak.forEach((x) {if(x==thisPosture){goodPosCount++;}});
  //   if (goodPosCount<=20) {return 'G';}
  //   //TODO continue from here
  //   else {return "R";}
  // }
  if (goodPos.contains(thisPosture)){
    return "GOOD";
  }
  else if (mehPos.contains(thisPosture)) {
    return "MEH";
  }
  else if (badPos.contains(thisPosture)) {
    return "BAD";
  }
  else if (thisPosture == away)
    return "AWAY"; //3 for when not sitting, can't use null
  else return "INVALID"; //invalid position
}


void setHiveAppleGraph(DateTime dateTime, int position){ //CALL THIS EVERY MINUTE
  //Check isBack isSide isLeg for position
  //for (int i,,i++ );
  // ++ to the entry in Hive Table, access the entry that corresponds to dateTime input
}
void plotAppleGraph(){ //CALL THIS WHEN REFRESH TODAY PAGE
  //set a variable to store the previous entry's hour, int prevIndex
  //create 4 lists with 24 variables each corresponding to the 24 hours in a day.
  // List<double> TotalLs = List<double>.filled(24, 0, growable: false);
  // List<double> isBackLs = List<double>.filled(24, 0, growable: false);
  // List<double> isSideLs = List<double>.filled(24, 0, growable: false);
  // List<double> isLegLs = List<double>.filled(24, 0, growable: false);

  // for row in hive table,
  //    get timestamp    //example: String formattedTime = DateFormat.Hm().format(dateTime); // this format -> 17:08
  //    take the HOUR from formattedTime
  //    if HOUR == prevIndex > add to List[HOUR] for each of the 4 lists //HOUR is ith index
  //    else add to List[HOUR+1], prevIndex = HOUR

  //  pass these variables into syncfusion AppleGraph
}


// Good Sitting Time
// class transferFunction {
//   // 2 puprpose:
//   //  1. Pull/push data from Table 1 to 2
//   //  2. Trigger Math/Logic equations to fill up the rest of the table
//
//   // When new data from table 1 comes in
//   var dateTime = box.getAt(table1.length()).DateTime;
//   var predictedPos = box.get(table1.length()).Position;
//
//   table2.add(datetime).DateTime;
//   table2.add(predictedPor).Position;
//
//   AppleGraphLogic.getData();
//   Graph2Logic.getData();
//
// }



// Good Sitting Time

// class GreenRingData{
//
//   int _goodSittingTime = 0;
//   int counter = 0;
//   int _nullCounter =0;
//   bool isSitting;
//   bool inGoodPosture = false;
//   var inComingData = new List(); // [timestamp, position]

//   GreenRingData(List<int> ls){
//     this.inComingData = ls;
//   }
//
//   double getGreenRingData(){
//
//     // var box = Hive.box('durationPosTable');
//
//     if (inComingData[1][0] == 1){ // check if he's in good posture
//       inGoodPosture = true;
//     } else {
//       inGoodPosture = false;
//     }
//
//     if (isSitting == true && _nullCounter <= 5 && counter <= 20 && inGoodPosture ==true ){
//       _goodSittingTime++;
//
//     } else if ( _nullCounter > 5){
//       counter = 0;
//
//     } else if (isSitting = true){
//       _nullCounter = 0;
//
//     }
//
//     return counter/( new TotalSittingTime.getTotalSittingTime());
//   }
//
// }

//    Position Change Frequency
//
// int numberOfNull = 0;
//
// int getNumberOfSwitchPositions() {
//   int timesUserSwitch = 0;
//   var box = Hive.box('durationPosTable');
//
//   // still sitting (last entry not null)
//   if (isSitting == true) {
//     timesUserSwitch = box.length() - 2 * numberOfNull - 1;
//   } else {
//     // Not sitting (last entry is null)
//     timesUserSwitch = box.length() - 2 * (numberOfNull - 1) - 1;
//   }
//   return timesUserSwitch;
// }
//
// int getPositionChangeFrequency() {
//   var _totalTime = new TotalSittingTime();
//
//   return _totalTime.getTotalSittingTimeMin() / getNumberOfSwitchPositions();
// }
//
//
