import 'package:better_sitt/today/today_classes.dart';
import 'package:hive/hive.dart';

part 'posture_graph.g.dart';

@HiveType(typeId: 5)
class HivePostureGraph extends HiveObject{
  @HiveField(0)
  var greenPositionTime = new List.filled(19, 0); // [11]

  @HiveField(1)
  var yellowPositionTime = new List.filled(19, 0); // [2,5,8,14,17]

  @HiveField(2)
  var redPositionTime = new List.filled(19, 0); // [1,3,4,6,7,9,10,12,13,15,16,18]

  @HiveField(3)
  var totalSittingPerHour = new List.filled(19, 0);

  @HiveField(4)
  var topThreePositions = new List.filled(3, 0);
}

// var greenPositionTime = new List.filled(19, 0); // [11]
// var yellowPositionTime = new List.filled(19, 0); // [2,5,8,14,17]
// var redPositionTime = new List.filled(19, 0); // [1,3,4,6,7,9,10,12,13,15,16,18]
// var totalSittingPerHour = new List.filled(19, 0);
// var topThreePositions = new List.filled(3, 0);
