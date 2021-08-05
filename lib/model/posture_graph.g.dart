// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'posture_graph.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HivePostureGraphAdapter extends TypeAdapter<HivePostureGraph> {
  @override
  final int typeId = 5;

  @override
  HivePostureGraph read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HivePostureGraph()
      ..greenPositionTime = (fields[0] as List).cast<int>()
      ..yellowPositionTime = (fields[1] as List).cast<int>()
      ..redPositionTime = (fields[2] as List).cast<int>()
      ..totalSittingPerHour = (fields[3] as List).cast<int>()
      ..topThreePositions = (fields[4] as List).cast<int>();
  }

  @override
  void write(BinaryWriter writer, HivePostureGraph obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.greenPositionTime)
      ..writeByte(1)
      ..write(obj.yellowPositionTime)
      ..writeByte(2)
      ..write(obj.redPositionTime)
      ..writeByte(3)
      ..write(obj.totalSittingPerHour)
      ..writeByte(4)
      ..write(obj.topThreePositions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HivePostureGraphAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
