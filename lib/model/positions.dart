import 'package:hive/hive.dart';

part 'positions.g.dart';

@HiveType(typeId: 0)
class Positions extends HiveObject{
  @HiveField(0)
  late DateTime dateTime;

  @HiveField(1)
  late int position;
}