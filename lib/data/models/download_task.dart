import 'package:hive/hive.dart';

part 'download_task.g.dart';

@HiveType(typeId: 5)
class DownloadTask extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String programId;

  @HiveField(2)
  String url;

  @HiveField(3)
  String localPath;

  @HiveField(4)
  DownloadStatus status;

  @HiveField(5)
  double progress;

  @HiveField(6)
  int totalBytes;

  @HiveField(7)
  DateTime createdAt;

  @HiveField(8)
  DateTime? completedAt;

  DownloadTask({
    required this.id,
    required this.programId,
    required this.url,
    required this.localPath,
    this.status = DownloadStatus.pending,
    this.progress = 0.0,
    this.totalBytes = 0,
    required this.createdAt,
    this.completedAt,
  });
}

@HiveType(typeId: 11)
enum DownloadStatus {
  @HiveField(0)
  pending,
  @HiveField(1)
  downloading,
  @HiveField(2)
  completed,
  @HiveField(3)
  failed,
  @HiveField(4)
  paused,
}
