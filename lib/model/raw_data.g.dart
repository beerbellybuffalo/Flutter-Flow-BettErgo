// GENERATED CODE - DO NOT MODIFY BY HAND


part of 'raw_data.dart';


// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RawDataAdapter extends TypeAdapter<RawData> {
  @override
  final int typeId = 0;

  @override
  RawData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RawData()
      ..dateTime = fields[0] as DateTime
      ..position = fields[1] as int;
  }

  @override
  void write(BinaryWriter writer, RawData obj) {
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
      other is RawDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
