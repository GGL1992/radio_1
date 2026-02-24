// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'host.dart';

class HostAdapter extends TypeAdapter<Host> {
  @override
  final int typeId = 2;

  @override
  Host read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Host(
      id: fields[0] as String,
      name: fields[1] as String,
      avatar: fields[2] as String?,
      description: fields[3] as String?,
      programIds: (fields[4] as List).cast<String>(),
      stationId: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Host obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.avatar)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.programIds)
      ..writeByte(5)
      ..write(obj.stationId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HostAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
