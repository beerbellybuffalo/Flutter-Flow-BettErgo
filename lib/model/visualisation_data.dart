import 'package:better_sitt/today/today_classes.dart';
import 'package:hive/hive.dart';

part 'visualisation_data.g.dart';

@HiveType(typeId: 2)
class VisualisationData extends HiveObject{
  @HiveField(0)
  late Rings rings;

  @HiveField(1)
  late AppleGraph appleGraph;

  @HiveField(2)
  late PostureGraph postureGraph;
}
