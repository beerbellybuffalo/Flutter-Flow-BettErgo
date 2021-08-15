import 'package:hive/hive.dart';

part 'raw_data.g.dart';

@HiveType(typeId: 0)
class RawData extends HiveObject{
  @HiveField(0)
  late DateTime dateTime;

  @HiveField(1)
  late int position;
}