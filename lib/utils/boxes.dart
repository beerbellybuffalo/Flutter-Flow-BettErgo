import 'package:better_sitt/model/processeddata.dart';
import 'package:better_sitt/model/rawdata.dart';
import 'package:better_sitt/model/visualisationdata.dart';
import 'package:hive/hive.dart';

class Boxes {
  static Box<RawData> getRawDataBox()=>
      Hive.box<RawData>('rawdata');
  static Box<ProcessedData> getProcessedDataBox()=>
      Hive.box<ProcessedData>('processeddata');
  static Box<VisualisationData> getVisualisationDataBox()=>
      Hive.box<VisualisationData>('visualisationdata');
}
