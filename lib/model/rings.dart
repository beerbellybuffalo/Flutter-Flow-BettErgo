import 'package:better_sitt/today/today_classes.dart';
import 'package:hive/hive.dart';

part 'rings.g.dart';

@HiveType(typeId: 3)
class HiveRings extends HiveObject{
  @HiveField(0)
  int totalSittingTime = 0;

  @HiveField(1)
  int goodSittingTime = 0;

  @HiveField(2)
  int postureChangeFrequency = 0;

  @HiveField(3)
  double innerRing = 0;

  @HiveField(4)
  double outerRing = 0;
}