import 'package:hive/hive.dart';

<<<<<<< HEAD:lib/model/raw_data.dart
part 'raw_data.g.dart';
=======
part 'rawdata.g.dart';
>>>>>>> visualisation_functions:lib/model/rawdata.dart

@HiveType(typeId: 0)
class RawData extends HiveObject{
  @HiveField(0)
  late DateTime dateTime;

  @HiveField(1)
  late int position;
}