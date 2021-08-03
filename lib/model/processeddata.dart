import 'package:hive/hive.dart';

part 'processeddata.g.dart';

@HiveType(typeId: 1)
class ProcessedData extends HiveObject{

  @HiveField(0)
  late DateTime dateTime;

  @HiveField(1)
  late int position;

  @HiveField(2)
  late int category;
}
