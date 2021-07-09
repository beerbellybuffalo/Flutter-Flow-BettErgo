// // Things to do:
// // - Total Sitting Time
// // - Good Sitting Time
// // - Position Change Frequency
// // - Horizontal Scroll Charts:
// //    1. With Time
// //    2. Stacked Bar Graph, i.e. No Time
//


var inComingData = new List();

// For Total Sitting Time:
class TotalSittingTime {
  int _totalSittingTime = 0;
  int startingPoint = 0;
  //var inComingData = new List();
  var ls = new List();
  var posNum = [1, 2, 3, 4, 5, 6, 7, 8];

  //Constructor
  TotalSittingTime(List<int> temp_ls) {
    this.ls = temp_ls;
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
      return null; //null for when not sitting
  }
  
  void incrementGoodPostureTime(int thisPosture) {
    int currentPosture = checkPostureCategory(thisPosture);
    if (currentPosture == null) {
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
//
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
// // Archive
//
// // find the difference between 2 null
// var diffList = new List();
// for (int i = 0; i < ls.length() - 1; i++) {
// int diff = ls[i] - ls[i + 1];
// diffList.add(diff);
// }
// // go through difference list and find <20min intervals
// var goodIndices = new List();
// for (int i=0; i<diffList.length(); i++){
// if ( diffList[i] <= 20){
// goodIndices.add(diffList[i]);
// }
// }
// // Get list of null
// List<int> getNullLs() {
//   var nullList = new list();
//   int startingPoint = 0;
//
//   for (int i = startingPoint; i < box.length(); i++) {
//     if (box.getAt(i)[0] == null) {
//       nullList.add(i);
//     }
//   }
//   startingPoint = startingPoint + box.length();
//
//   return nullList;
// }