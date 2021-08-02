import 'package:better_sitt/model/processed_data.dart';
import 'package:better_sitt/model/raw_data.dart';
import 'package:better_sitt/model/visualisation_data.dart';
import 'package:hive/hive.dart';

class Boxes {
  static Box<RawData> getRawDataBox()=>
      Hive.box<RawData>('rawdata');
  static Box<ProcessedData> getProcessedDataBox()=>
      Hive.box<ProcessedData>('processeddata');
  // static Box<VisualisationData> getVisualisationDataBox()=>
  //     Hive.box<VisualisationData>('visualisationdata');
}
