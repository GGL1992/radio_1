// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

class AppSettingsAdapter extends TypeAdapter<AppSettings> {
  @override
  final int typeId = 6;

  @override
  AppSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppSettings(
      isDarkMode: fields[0] as bool,
      autoPlay: fields[1] as bool,
      volume: fields[2] as double,
      audioQuality: fields[3] as String,
      downloadWifiOnly: fields[4] as bool,
      lastStationId: fields[5] as String,
      lastPosition: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, AppSettings obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.isDarkMode)
      ..writeByte(1)
      ..write(obj.autoPlay)
      ..writeByte(2)
      ..write(obj.volume)
      ..writeByte(3)
      ..write(obj.audioQuality)
      ..writeByte(4)
      ..write(obj.downloadWifiOnly)
      ..writeByte(5)
      ..write(obj.lastStationId)
      ..writeByte(6)
      ..write(obj.lastPosition);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
