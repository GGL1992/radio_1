// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'play_history.dart';

class PlayHistoryAdapter extends TypeAdapter<PlayHistory> {
  @override
  final int typeId = 4;

  @override
  PlayHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlayHistory(
      id: fields[0] as String,
      stationId: fields[1] as String,
      programId: fields[2] as String?,
      playedAt: fields[3] as DateTime,
      duration: fields[4] as int,
      position: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, PlayHistory obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.stationId)
      ..writeByte(2)
      ..write(obj.programId)
      ..writeByte(3)
      ..write(obj.playedAt)
      ..writeByte(4)
      ..write(obj.duration)
      ..writeByte(5)
      ..write(obj.position);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
