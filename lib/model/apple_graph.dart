import 'package:better_sitt/today/today_classes.dart';
import 'package:hive/hive.dart';
import 'dart:core';
part 'apple_graph.g.dart';

@HiveType(typeId: 4)
class HiveAppleGraph extends HiveObject{
  @HiveField(0)
  List<int> backSupp = List<int>.filled(24, 0, growable: false);

  @HiveField(1)
  List<int> backCenter = List<int>.filled(24, 0, growable: false);

  @HiveField(2)
  List<int> legSupp = List<int>.filled(24, 0, growable: false);

  @HiveField(3)
  List<int> totalTime = List<int>.filled(24, 0, growable: false);
}
// var backSupp = List<int>.filled(24, 0, growable: false);
// var backCenter = List<int>.filled(24, 0, growable: false);
// var legSupp = List<int>.filled(24, 0, growable: false);
// var totalTime = List<int>.filled(24, 0, growable: false);
