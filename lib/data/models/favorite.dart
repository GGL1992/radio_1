import 'package:hive/hive.dart';

part 'favorite.g.dart';

@HiveType(typeId: 3)
class Favorite extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  FavoriteType type;

  @HiveField(2)
  String targetId;

  @HiveField(3)
  DateTime createdAt;

  @HiveField(4)
  String? note;

  Favorite({
    required this.id,
    required this.type,
    required this.targetId,
    required this.createdAt,
    this.note,
  });
}

@HiveType(typeId: 10)
enum FavoriteType {
  @HiveField(0)
  station,
  @HiveField(1)
  program,
  @HiveField(2)
  host,
}
