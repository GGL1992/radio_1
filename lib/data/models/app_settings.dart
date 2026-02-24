import 'package:hive/hive.dart';

part 'app_settings.g.dart';

@HiveType(typeId: 6)
class AppSettings extends HiveObject {
  @HiveField(0)
  bool isDarkMode;

  @HiveField(1)
  bool autoPlay;

  @HiveField(2)
  double volume;

  @HiveField(3)
  String audioQuality;

  @HiveField(4)
  bool downloadWifiOnly;

  @HiveField(5)
  String lastStationId;

  @HiveField(6)
  int lastPosition;

  AppSettings({
    this.isDarkMode = false,
    this.autoPlay = true,
    this.volume = 0.7,
    this.audioQuality = 'high',
    this.downloadWifiOnly = true,
    this.lastStationId = '',
    this.lastPosition = 0,
  });

  AppSettings copyWith({
    bool? isDarkMode,
    bool? autoPlay,
    double? volume,
    String? audioQuality,
    bool? downloadWifiOnly,
    String? lastStationId,
    int? lastPosition,
  }) {
    return AppSettings(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      autoPlay: autoPlay ?? this.autoPlay,
      volume: volume ?? this.volume,
      audioQuality: audioQuality ?? this.audioQuality,
      downloadWifiOnly: downloadWifiOnly ?? this.downloadWifiOnly,
      lastStationId: lastStationId ?? this.lastStationId,
      lastPosition: lastPosition ?? this.lastPosition,
    );
  }
}
