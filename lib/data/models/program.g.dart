// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'program.dart';

class ProgramAdapter extends TypeAdapter<Program> {
  @override
  final int typeId = 1;

  @override
  Program read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Program(
      id: fields[0] as String,
      name: fields[1] as String,
      stationId: fields[2] as String,
      hostId: fields[3] as String?,
      audioUrl: fields[4] as String?,
      localPath: fields[5] as String?,
      description: fields[6] as String?,
      duration: fields[7] as int,
      broadcastTime: fields[8] as String,
      isDownloadable: fields[9] as bool,
      coverImage: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Program obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.stationId)
      ..writeByte(3)
      ..write(obj.hostId)
      ..writeByte(4)
      ..write(obj.audioUrl)
      ..writeByte(5)
      ..write(obj.localPath)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.duration)
      ..writeByte(8)
      ..write(obj.broadcastTime)
      ..writeByte(9)
      ..write(obj.isDownloadable)
      ..writeByte(10)
      ..write(obj.coverImage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProgramAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
