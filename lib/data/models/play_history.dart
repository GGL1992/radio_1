import 'package:hive/hive.dart';

part 'play_history.g.dart';

@HiveType(typeId: 4)
class PlayHistory extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String stationId;

  @HiveField(2)
  String? programId;

  @HiveField(3)
  DateTime playedAt;

  @HiveField(4)
  int duration;

  @HiveField(5)
  int position;

  PlayHistory({
    required this.id,
    required this.stationId,
    this.programId,
    required this.playedAt,
    this.duration = 0,
    this.position = 0,
  });
}
