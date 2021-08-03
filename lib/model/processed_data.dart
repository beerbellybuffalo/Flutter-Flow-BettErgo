import 'package:hive/hive.dart';

part 'processed_data.g.dart';

@HiveType(typeId: 1)
class ProcessedData extends HiveObject{

  @HiveField(0)
  late DateTime dateTime;

  @HiveField(1)
  late int position;

  @HiveField(2)
  late String category;
}
