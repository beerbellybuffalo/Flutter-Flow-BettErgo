// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'positions.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PositionsAdapter extends TypeAdapter<Positions> {
  @override
  final int typeId = 0;

  @override
  Positions read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Positions()
      ..dateTime = fields[0] as DateTime
      ..position = fields[1] as int;
  }

  @override
  void write(BinaryWriter writer, Positions obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.dateTime)
      ..writeByte(1)
      ..write(obj.position);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PositionsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}