// // Things to do:
// // - Total Sitting Time
// // - Good Sitting Time
// // - Position Change Frequency
// // - Horizontal Scroll Charts:
// //    1. With Time
// //    2. Stacked Bar Graph, i.e. No Time
//

import 'dart:core';
<<<<<<< HEAD
import 'package:better_sitt/model/processed_data.dart';
import 'package:hive/hive.dart';
=======
>>>>>>> parent of 821f272 (Merge pull request #6 from beerbellybuffalo/daniel)
import 'package:intl/intl.dart';
import '../utils/positions_processing.dart';
import '../utils/boxes.dart';

<<<<<<< HEAD




// class PostureGraph{
//   // Purpose of PostureGraph:
//   //  1. Draw information from table 2 process it and push to list
//   //  2. Hold the list[18] to plot the graph with
//
//
//   // list[18]: corresponding to time spend in each position
//   var greenPositionTime = new List.filled(19, 0); // [11]
//   var yellowPositionTime = new List.filled(19, 0); // [2,5,8,14,17]
//   var redPositionTime = new List.filled(19, 0); // [1,3,4,6,7,9,10,12,13,15,16,18]
//   var _totalSittingTime = new List.filled(19, 0);
//   var topThreePositions = new List.filled(3, 0);
//
//   Box<ProcessedData> box = Boxes.getProcessedDataBox();
//
//   // To continue where you left off
//   int lastInd = 0;
//
//   void calculateTotalSittingTime(){
//     for (int i = 0; i<greenPositionTime.length; i++){
//       _totalSittingTime[i] += greenPositionTime[i];
//       _totalSittingTime[i] += yellowPositionTime[i];
//       _totalSittingTime[i] += redPositionTime[i];
//     }
//   }
//
//   //Add in amount time spend in each part of the list (se Alternative)
//   void fillInPositionTimeLs(){
//     // read whole list for 'G' an add to [11] of greenPositionTime
//     for (int i = 0; i < box.length ; i++){
//       getProcessedData(i).then((processedData){
//         if( processedData!.category == 'G'){
//           greenPositionTime[processedData.position]++; // only position 11 can be Green
//         }
//         if ( processedData.category == 'Y'){
//           yellowPositionTime[processedData.position]++;
//         }
//         if ( processedData.category == 'R'){
//           redPositionTime[processedData.position]++;
//         }
//       });
//     }
//   }
//   // Alternative:
//   //  everytime a reading is stored in table 2, a fn automatically updates
//   //  the lists
//   void updatePositionTimeLs(){
//     // points to Table2.length
//     getProcessedData(box.length-1).then((processedData){
//       if (processedData!.category == 'G'){
//         greenPositionTime[processedData.position]++;
//       } else if (processedData.category == 'Y'){
//         yellowPositionTime[processedData.position]++;
//       } else if (processedData.category == 'R'){
//         redPositionTime[processedData.position]++;
//       }
//     });
//
//
//   }
//
//   // returns list of Top 3 sitting position, i.e. [top,seconf,third]
//   List<int> getTopThreePositions (){
//     int largestNum = 0;
//     int secondNum = 0;
//     int thirdNum = 0;
//
//     List<int> ls = _totalSittingTime;
//
//     fillInPositionTimeLs();
//     calculateTotalSittingTime();
//
//     for (int i=0; i< ls.length; i++){
//       if (ls[i] > largestNum){
//         largestNum = ls[i];
//       }
//     }
//     for (int i=0; i< ls.length; i++){
//       if (ls[i] > secondNum && ls[i] != largestNum){
//         secondNum = ls[i];
//       }
//     }
//     for (int i=0; i< ls.length; i++){
//       if (ls[i] > thirdNum && ls[i] < secondNum){
//         thirdNum = ls[i];
//       }
//     }
//
//     topThreePositions[0] = ls.indexOf(largestNum);
//     topThreePositions[1] = ls.indexOf(secondNum);
//     topThreePositions[2] = ls.indexOf(thirdNum);
//     return topThreePositions;
//   }
//
// }

=======
class Rings {
  int totalSittingTime = 0;
  int goodSittingTime = 0;
  int postureChangeFrequency = 0;
  //Constructor
  Rings(this.totalSittingTime,this.goodSittingTime,this.postureChangeFrequency);

  //Setters
  set setTotalSitting(int t){
    totalSittingTime = t;
  }
  set setGoodSitting(int t){
    goodSittingTime = t;
  }
  set posChange(int t){
    postureChangeFrequency = t;
  }
  //Methods
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

// int calcPostureChangeFreq(){
//
// }


// For Total Sitting Time:
class TotalSittingTime {
  int _totalSittingTime = 0;
  int startingPoint = 0;
  //var inComingData = new List();
  var ls = []; //cannot initialise variable to List here because null safe?
  var posNum = [1, 2, 3, 4, 5, 6, 7, 8];

  //Constructor
  TotalSittingTime(List<int?> tempLs) {
    this.ls = tempLs;
  }
  int getTotalSittingTime() {
    for (int i = startingPoint; i < ls.length; i++) {
      if (posNum.contains(ls[i])) {
        _totalSittingTime++; // assuming called every minute
      }

    }
    startingPoint = startingPoint + ls.length;

    return _totalSittingTime;
  }

  int getTotalSittingTimeText() {
    return _totalSittingTime;
  }
}

>>>>>>> parent of 821f272 (Merge pull request #6 from beerbellybuffalo/daniel)
//TODO update the unit tests to have 19 positions
class GoodSittingTime{
  int nullCounter = 0;
  int sessionCounter = 0; //
  int goodTimeLength = 0; //Green ring value

  void incrementGoodPostureTime(int thisPosture) {
    String currentPosCat = checkPostureCategory(thisPosture);
    if (currentPosCat == "A") {
      nullCounter++;
    }
    else {
      sessionCounter++;
      if (nullCounter > 5) {
        //reset session
        sessionCounter = 0;
      }
      if (sessionCounter <= 20 && currentPosCat == "G") {
        goodTimeLength++;
      }
    }
  }
}

<<<<<<< HEAD
=======
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

>>>>>>> parent of 821f272 (Merge pull request #6 from beerbellybuffalo/daniel)
String checkPostureCategory(int thisPosture) {
  int away = 0;
  List<int> goodPos = [11];
  List<int> mehPos = [2, 5, 8, 14, 17];
  List<int> badPos = [1, 3, 4, 6, 7, 9, 10, 12, 13, 15, 16, 18];
  if (goodPos.contains(thisPosture)) {
    return "G";
  }
  else if (mehPos.contains(thisPosture)) {
    return "Y";
  }
  else if (badPos.contains(thisPosture)) {
    return "R";
  }
  else if (thisPosture == away)
    return "A"; //3 for when not sitting, can't use null
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

