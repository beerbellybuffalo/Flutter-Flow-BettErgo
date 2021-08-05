
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

  test('Check Hive Table 1', () async {
    var table1 = Boxes.getRawDataBox();
    table1.clear();

    //LOG TABLE 1 DATA
    DateTime date = DateTime(2021,8,5);
    predictAndStore(date, [0,0,0,0,0,0,0,0,0,0,0,170,66]);
    var rawData = await getRawData(0);

    expect(rawData!.dateTime, DateTime(2021,8,5));
    expect(rawData.position, 0);
  });
}