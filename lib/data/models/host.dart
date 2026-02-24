import 'package:hive/hive.dart';

part 'host.g.dart';

@HiveType(typeId: 2)
class Host extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String? avatar;

  @HiveField(3)
  String? description;

  @HiveField(4)
  List<String> programIds;

  @HiveField(5)
  String stationId;

  Host({
    required this.id,
    required this.name,
    this.avatar,
    this.description,
    this.programIds = const [],
    required this.stationId,
  });
}
