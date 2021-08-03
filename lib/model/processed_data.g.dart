// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'processed_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProcessedDataAdapter extends TypeAdapter<ProcessedData> {
  @override
  final int typeId = 1;

  @override
  ProcessedData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProcessedData()
      ..dateTime = fields[0] as DateTime
      ..position = fields[1] as int
      ..category = fields[2] as String;
  }

  @override
  void write(BinaryWriter writer, ProcessedData obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.dateTime)
      ..writeByte(1)
      ..write(obj.position)
      ..writeByte(2)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProcessedDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
