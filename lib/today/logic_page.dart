// // convert raw data into visualization tools
//
// // Things to do:
// // - Total Sitting Time
// // - Good Sitting Time
// // - Position Change Frequency
// // - Horizontal Scroll Charts:
// //    1. With Time
// //    2. Stacked Bar Graph, i.e. No Time
//
// // For Total Sitting Time:
// class TotalSittingTime {
//   int _totalSittingTime = 0;
//   int startingPoint = 0;
//   var box = Hive.box('durationPosTable');
//
//   String getTotalSittingTime() {
//     for (int i = startingPoint; i < box.length(); i++) {
//       if (box.getAt(i)[0] != null) {
//         _totalSittingTime = _totalSittingTime + box.getAt(i)[1];
//       }
//     }
//     startingPoint = startingPoint + box.length();
//
//     int _totalSittingTimeHrs = _totalSittingTime ~/ 60;
//     int _totalSittingTimeMins = _totalSittingTime % 60;
//
//     return '_totalSittingTimeHrs.toString()' +
//         "Hrs " +
//         '_totalSittingTimeMins.toString' +
//         "mins";
//   }
//
//   int getTotalSittingTimeMin() {
//     return _totalSittingTime;
//   }
// }
//
// // Good Sitting Time
//
//
// int _goodSittingTime = 0;
// int _counter = 0;
// int _nullCounter =0;
// bool isSitting;
// bool inGoodPosture = false;
//
//
// double getGreenRingData(){
//
//   var box = Hive.box('durationPosTable');
//
//   if (box.getAt(i)[0] == 1){ // check if he's in good posture
//     inGoodPosture = true;
//   } else {
//     inGoodPosture = false;
//   }
//
//   if (isSitting == true && _nullCounter <= 5 && counter <= 20 && inGoodPosture ==true ){
//     _goodSittingTime++;
//   } else if ( _nullCounter > 5){
//     _counter = 0;
//   } else if (isSitting = true){
//     _nullCounter = 0;
//   }
//
//   return counter/( new TotalSittingTime.getTotalSittingTime());
// }
//
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
// //Archive
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