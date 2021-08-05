// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visualisation_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VisualisationDataAdapter extends TypeAdapter<VisualisationData> {
  @override
  final int typeId = 2;

  @override
  VisualisationData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VisualisationData()
      ..rings = fields[0] as Rings
      ..appleGraph = fields[1] as AppleGraph
      ..postureGraph = fields[2] as PostureGraph;
  }

  @override
  void write(BinaryWriter writer, VisualisationData obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.rings)
      ..writeByte(1)
      ..write(obj.appleGraph)
      ..writeByte(2)
      ..write(obj.postureGraph);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VisualisationDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
