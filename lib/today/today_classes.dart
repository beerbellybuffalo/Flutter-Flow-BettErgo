// // Things to do:
// // - Total Sitting Time
// // - Good Sitting Time
// // - Position Change Frequency
// // - Horizontal Scroll Charts:
// //    1. With Time
// //    2. Stacked Bar Graph, i.e. No Time
//


import 'dart:core';
import 'package:intl/intl.dart';

//var inComingData = new List();

// For Total Sitting Time:
class TotalSittingTime {
  int _totalSittingTime = 0;
  int startingPoint = 0;
  //var inComingData = new List();
  var ls= []; //cannot initialise variable to List here because null safe?
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

    };
    startingPoint = startingPoint + ls.length;

    return _totalSittingTime;
  }

  int getTotalSittingTimeText() {
    return _totalSittingTime;
  }
}

class GoodSittingTime{
  int nullCounter = 0;
  int sessionCounter = 0;
  int goodTimeLength = 0;

  int checkPostureCategory(int thisPosture) {
    //only 8 is postures_2
    List postures_1 = [1, 3, 5, 7];
    List postures_0 = [2, 4, 6];
    if (thisPosture == 8) {
      return 2;
    }
    else if (postures_1.contains(thisPosture)) {
      return 1;
    }
    else if (postures_0.contains(thisPosture)) {
      return 0;
    }
    else
      return -1; //-1 for when not sitting, can't use null
  }
  
  void incrementGoodPostureTime(int thisPosture) {
    int currentPosture = checkPostureCategory(thisPosture);
    if (currentPosture == -1) {
      nullCounter++;
    }
    else {
      sessionCounter++;
      if (nullCounter > 5) { //reset session
        sessionCounter = 0;
      }
      if (sessionCounter <= 20 && currentPosture == 2) {
        goodTimeLength++;
      }
    }
  }
}

void setHiveAppleGraph(DateTime dateTime, int position){ //CALL THIS EVERY MINUTE
  //Check isBack isSide isLeg for position
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

//
// // Position Change Frequency
//
// int numberOfNull = 0;
//
// int getNumberOfSwitchPositions() {
//   int timesUserSwitch;
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
