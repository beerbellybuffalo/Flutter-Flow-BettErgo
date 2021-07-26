import 'package:better_sitt/model/positions.dart';
import 'package:hive/hive.dart';

class Boxes {
  static Box<Positions> getPositions()=>
      Hive.box<Positions>('Table 2');
}
