// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveRingsAdapter extends TypeAdapter<HiveRings> {
  @override
  final int typeId = 3;

  @override
  HiveRings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveRings()
      ..totalSittingTime = fields[0] as int
      ..goodSittingTime = fields[1] as int
      ..postureChangeFrequency = fields[2] as int
      ..innerRing = fields[3] as double
      ..outerRing = fields[4] as double;
  }

  @override
  void write(BinaryWriter writer, HiveRings obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.totalSittingTime)
      ..writeByte(1)
      ..write(obj.goodSittingTime)
      ..writeByte(2)
      ..write(obj.postureChangeFrequency)
      ..writeByte(3)
      ..write(obj.innerRing)
      ..writeByte(4)
      ..write(obj.outerRing);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveRingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
