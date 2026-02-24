// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite.dart';

class FavoriteAdapter extends TypeAdapter<Favorite> {
  @override
  final int typeId = 3;

  @override
  Favorite read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Favorite(
      id: fields[0] as String,
      type: fields[1] as FavoriteType,
      targetId: fields[2] as String,
      createdAt: fields[3] as DateTime,
      note: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Favorite obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.targetId)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.note);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FavoriteTypeAdapter extends TypeAdapter<FavoriteType> {
  @override
  final int typeId = 10;

  @override
  FavoriteType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return FavoriteType.station;
      case 1:
        return FavoriteType.program;
      case 2:
        return FavoriteType.host;
      default:
        return FavoriteType.station;
    }
  }

  @override
  void write(BinaryWriter writer, FavoriteType obj) {
    switch (obj) {
      case FavoriteType.station:
        writer.writeByte(0);
        break;
      case FavoriteType.program:
        writer.writeByte(1);
        break;
      case FavoriteType.host:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
