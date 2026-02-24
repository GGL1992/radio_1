// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'radio_station.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RadioStationAdapter extends TypeAdapter<RadioStation> {
  @override
  final int typeId = 0;

  @override
  RadioStation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RadioStation(
      id: fields[0] as String,
      name: fields[1] as String,
      frequency: fields[2] as String,
      streamUrl: fields[3] as String,
      imageUrl: fields[4] as String?,
      category: fields[5] as String,
      region: fields[6] as String,
      language: fields[7] as String,
      description: fields[8] as String?,
      isNational: fields[9] as bool,
      isOnline: fields[10] as bool,
      programs: (fields[11] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, RadioStation obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.frequency)
      ..writeByte(3)
      ..write(obj.streamUrl)
      ..writeByte(4)
      ..write(obj.imageUrl)
      ..writeByte(5)
      ..write(obj.category)
      ..writeByte(6)
      ..write(obj.region)
      ..writeByte(7)
      ..write(obj.language)
      ..writeByte(8)
      ..write(obj.description)
      ..writeByte(9)
      ..write(obj.isNational)
      ..writeByte(10)
      ..write(obj.isOnline)
      ..writeByte(11)
      ..write(obj.programs);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RadioStationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
