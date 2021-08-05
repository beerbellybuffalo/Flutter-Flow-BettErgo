// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apple_graph.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveAppleGraphAdapter extends TypeAdapter<HiveAppleGraph> {
  @override
  final int typeId = 4;

  @override
  HiveAppleGraph read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveAppleGraph()
      ..backSupp = (fields[0] as List).cast<int>()
      ..backCenter = (fields[1] as List).cast<int>()
      ..legSupp = (fields[2] as List).cast<int>()
      ..totalTime = (fields[3] as List).cast<int>();
  }

  @override
  void write(BinaryWriter writer, HiveAppleGraph obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.backSupp)
      ..writeByte(1)
      ..write(obj.backCenter)
      ..writeByte(2)
      ..write(obj.legSupp)
      ..writeByte(3)
      ..write(obj.totalTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveAppleGraphAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
