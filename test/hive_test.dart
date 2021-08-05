
import 'package:better_sitt/model/processed_data.dart';
import 'package:better_sitt/model/raw_data.dart';
import 'package:better_sitt/utils/boxes.dart';
import 'package:better_sitt/utils/positions_processing.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(RawDataAdapter());
  await Hive.openBox<RawData>('rawdata');
  Hive.registerAdapter(ProcessedDataAdapter());
  await Hive.openBox<ProcessedData>('processeddata');


  test('Check Hive Tables', () async {
    var table1 = Boxes.getRawDataBox();
    var table2 = Boxes.getProcessedDataBox();
    print(table1.values);
    print(table2.values);
    //LOG TABLE 1 DATA
    String table1Data = "table1Data: ";
    for (int i = 0; i < table1.length; i++) {
      getRawData(i).then((rawData) =>
      table1Data +=
      (rawData!.dateTime.toString() + rawData.position.toString() + "\n"));
    }
    print(table1Data);
    //LOG TABLE 2 DATA
    String table2Data = "table2Data: ";
    for (int i = 0; i < table2.length; i++) {
      getProcessedData(i).then((processedData) {
        table2Data += (processedData!.dateTime.toString() +
            processedData.position.toString() +
            processedData.category.toString() + "\n");
      });
    }
    print(table2Data);
    expect(table2Data, null);
  });
}