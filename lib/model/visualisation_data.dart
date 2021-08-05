import 'package:hive/hive.dart';
import 'rings.dart';
import 'apple_graph.dart';
import 'posture_graph.dart';
part 'visualisation_data.g.dart';

@HiveType(typeId: 2)
class VisualisationData extends HiveObject{
  @HiveField(0)
  late HiveRings rings;

  @HiveField(1)
  late HiveAppleGraph appleGraph;

  @HiveField(2)
  late HivePostureGraph postureGraph;
}
