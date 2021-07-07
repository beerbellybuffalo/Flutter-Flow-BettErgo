// // This is a basic Flutter widget test.
// //
// // To perform an interaction with a widget in your test, use the WidgetTester
// // utility that Flutter provides. For example, you can send tap and scroll
// // gestures. You can also use WidgetTester to find child widgets in the widget
// // tree, read text, and verify that the values of widget properties are correct.
//
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
//
// import 'package:better_sitt/main.dart';
//
// void main() {
//   testWidgets('Counter increments smoke test', (WidgetTester tester) async {
//     // Build our app and trigger a frame.
//     await tester.pumpWidget(MyApp());
//   });
// }
//
// int checkPostureCategory (int thisPosture) {
//   List postures_1 = [1,2,3,4,6];
//   List postures_0 = [7,8,9,10,11,12];
//   if (thisPosture == 5) {
//     return 2;
//   }
//   else if (postures_1.contains(thisPosture)) {
//     return 1;
//   }
//   else if (postures_0.contains(thisPosture)) {
//     return 0;
//   }
//   else return null; //null for when not sitting
// }
//
// class testGreenRing {
//
//   int getGreenRingData(int thisPosture){
//     checkPostureCategory(thisPosture);
//     //var box = Hive.box('durationPosTable');
//
//     if (box.getAt(i)[0] == 1){ // check if he's in good posture
//       inGoodPosture = true;
//     } else {
//       inGoodPosture = false;
//     }
//
//     if (isSitting == true && _nullCounter <= 5 && counter <= 20 && inGoodPosture ==true ){
//       _goodSittingTime++;
//     } else if ( _nullCounter > 5){
//       _counter = 0;
//     } else if (isSitting = true){
//       _nullCounter = 0;
//     }
//
//     return counter/( new TotalSittingTime.getTotalSittingTime());
//   }
//
// }
