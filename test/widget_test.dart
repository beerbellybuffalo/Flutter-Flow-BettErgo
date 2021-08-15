// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:better_sitt/today/today_classes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:better_sitt/main.dart';

void main() {
<<<<<<< HEAD
  // testWidgets("TEST0. Counter increments smoke test", (WidgetTester tester) async {
  //   var ls = [5,-2,0,2,2,3,0,null,4,1,-4,4,1,3,5,0,5,null,3,-5,1];
  //   // 20 entries, 2 nulls, 3 negatives, 2 zeros
  //
  //   TotalSittingTime tt = new TotalSittingTime(ls);
  //
  //   print("TEST0. Counter increments smoke test");
  //   print("Result: " + tt.getTotalSittingTime().toString());
  //   expect(tt.getTotalSittingTime(), 13);
  //   // Build our app and trigger a frame.
  //   await tester.pumpWidget(MyApp());
  // });
  // test("TEST1. Don't add if break less than 5 mins", () {
  //   final goodSittingTime = GoodSittingTime();
  //   List<dynamic> testData = [8, 8, 8, 8, 8, 8, 8, 8, 8, 8,
  //     8, 8, 8, 8, 8, 8, 8, 8, 8, 8, null, null, null, null, 8];
  //   for (int thisPosture in testData) {
  //     goodSittingTime.incrementGoodPostureTime(thisPosture);
  //   }
  //   print("Length of dataset: " + testData.length.toString());
  //   print("TEST1. Don't add if break less than 5 mins");
  //   print("Result: " + goodSittingTime.goodTimeLength.toString());
  //   expect(goodSittingTime.goodTimeLength, 20);
  // });
  //
  // test("TEST2. Session resets after >5 min break", () {
  //   final goodSittingTime = GoodSittingTime();
  //   goodSittingTime.goodTimeLength = 20;
  //   List<dynamic> testData = [null, null, null, null, null, null, 8];
  //   for (int thisPosture in testData) {
  //     goodSittingTime.incrementGoodPostureTime(thisPosture);
  //   }
  //   print("Length of dataset: " + testData.length.toString());
  //   print("TEST2. Don't add if break less than 5 mins");
  //   print("Result: " + goodSittingTime.goodTimeLength.toString());
  //   expect(goodSittingTime.goodTimeLength, 21);
  // });
  //
  // test("TEST3. Cut off if session >20mins NO BREAK", () {
  //   final goodSittingTime = GoodSittingTime();
  //   //initialise session with 10 "bad" entries
  //   goodSittingTime.sessionCounter = 10;
  //   goodSittingTime.goodTimeLength = 0;
  //   print("Inserting 11 good data..."
  //       +"\nExpect 10 good added");
  //   List<dynamic> testData = [8,8,8,8,8,8,8,8,8,8,8];
  //   for (int thisPosture in testData) {
  //     goodSittingTime.incrementGoodPostureTime(thisPosture);
  //   }
  //   //print(testData.length);
  //   print("TEST3. Cut off if session >20mins NO BREAK");
  //   print("Result: " + goodSittingTime.goodTimeLength.toString());
  //   expect(goodSittingTime.goodTimeLength, 10);
  // });
  // test("TEST4. Cut off if good posture for >20mins NO BREAK", () {
  //   final goodSittingTime = GoodSittingTime();
  //   //initialise session with 10 "bad" entries
  //   goodSittingTime.sessionCounter = 20;
  //   goodSittingTime.goodTimeLength = 20;
  //   List<dynamic> testData = [8];
  //   for (int thisPosture in testData) {
  //     goodSittingTime.incrementGoodPostureTime(thisPosture);
  //   }
  //   //print(testData.length);
  //   print("TEST4. Cut off if good posture for >20mins NO BREAK");
  //   print("Result: " + goodSittingTime.goodTimeLength.toString());
  //   expect(goodSittingTime.goodTimeLength, 20);
  // });
=======
  testWidgets("TEST0. Counter increments smoke test", (WidgetTester tester) async {
    var ls = [5,-2,0,2,2,3,0,null,4,1,-4,4,1,3,5,0,5,null,3,-5,1];
    // 20 entries, 2 nulls, 3 negatives, 2 zeros

    TotalSittingTime tt = new TotalSittingTime(ls);

    print("TEST0. Counter increments smoke test");
    print("Result: " + tt.getTotalSittingTime().toString());
    expect(tt.getTotalSittingTime(), 13);
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());
  });
  test("TEST1. Don't add if break less than 5 mins", () {
    final goodSittingTime = GoodSittingTime();
    List<dynamic> testData = [8, 8, 8, 8, 8, 8, 8, 8, 8, 8,
      8, 8, 8, 8, 8, 8, 8, 8, 8, 8, null, null, null, null, 8];
    for (int thisPosture in testData) {
      goodSittingTime.incrementGoodPostureTime(thisPosture);
    }
    print("Length of dataset: " + testData.length.toString());
    print("TEST1. Don't add if break less than 5 mins");
    print("Result: " + goodSittingTime.goodTimeLength.toString());
    expect(goodSittingTime.goodTimeLength, 20);
  });

  test("TEST2. Session resets after >5 min break", () {
    final goodSittingTime = GoodSittingTime();
    goodSittingTime.goodTimeLength = 20;
    List<dynamic> testData = [null, null, null, null, null, null, 8];
    for (int thisPosture in testData) {
      goodSittingTime.incrementGoodPostureTime(thisPosture);
    }
    print("Length of dataset: " + testData.length.toString());
    print("TEST2. Don't add if break less than 5 mins");
    print("Result: " + goodSittingTime.goodTimeLength.toString());
    expect(goodSittingTime.goodTimeLength, 21);
  });

  test("TEST3. Cut off if session >20mins NO BREAK", () {
    final goodSittingTime = GoodSittingTime();
    //initialise session with 10 "bad" entries
    goodSittingTime.sessionCounter = 10;
    goodSittingTime.goodTimeLength = 0;
    print("Inserting 11 good data..."
        +"\nExpect 10 good added");
    List<dynamic> testData = [8,8,8,8,8,8,8,8,8,8,8];
    for (int thisPosture in testData) {
      goodSittingTime.incrementGoodPostureTime(thisPosture);
    }
    //print(testData.length);
    print("TEST3. Cut off if session >20mins NO BREAK");
    print("Result: " + goodSittingTime.goodTimeLength.toString());
    expect(goodSittingTime.goodTimeLength, 10);
  });
  test("TEST4. Cut off if good posture for >20mins NO BREAK", () {
    final goodSittingTime = GoodSittingTime();
    //initialise session with 10 "bad" entries
    goodSittingTime.sessionCounter = 20;
    goodSittingTime.goodTimeLength = 20;
    List<dynamic> testData = [8];
    for (int thisPosture in testData) {
      goodSittingTime.incrementGoodPostureTime(thisPosture);
    }
    //print(testData.length);
    print("TEST4. Cut off if good posture for >20mins NO BREAK");
    print("Result: " + goodSittingTime.goodTimeLength.toString());
    expect(goodSittingTime.goodTimeLength, 20);
  });
>>>>>>> parent of 821f272 (Merge pull request #6 from beerbellybuffalo/daniel)

}