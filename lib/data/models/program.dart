import 'package:hive/hive.dart';

part 'program.g.dart';

@HiveType(typeId: 1)
class Program extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String stationId;

  @HiveField(3)
  String? hostId;

  @HiveField(4)
  String? audioUrl;

  @HiveField(5)
  String? localPath;

  @HiveField(6)
  String? description;

  @HiveField(7)
  int duration;

  @HiveField(8)
  String broadcastTime;

  @HiveField(9)
  bool isDownloadable;

  @HiveField(10)
  String? coverImage;

  Program({
    required this.id,
    required this.name,
    required this.stationId,
    this.hostId,
    this.audioUrl,
    this.localPath,
    this.description,
    this.duration = 0,
    this.broadcastTime = '',
    this.isDownloadable = false,
    this.coverImage,
  });

  String get durationFormatted {
    final hours = duration ~/ 3600;
    final minutes = (duration % 3600) ~/ 60;
    if (hours > 0) {
      return '$hours小时$minutes分钟';
    }
    return '$minutes分钟';
  }
}
