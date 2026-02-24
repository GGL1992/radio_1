import 'package:hive/hive.dart';

part 'radio_station.g.dart';

@HiveType(typeId: 0)
class RadioStation extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String frequency;

  @HiveField(3)
  String streamUrl;

  @HiveField(4)
  String? imageUrl;

  @HiveField(5)
  String category;

  @HiveField(6)
  String region;

  @HiveField(7)
  String language;

  @HiveField(8)
  String? description;

  @HiveField(9)
  bool isNational;

  @HiveField(10)
  bool isOnline;

  @HiveField(11)
  List<String> programs;

  RadioStation({
    required this.id,
    required this.name,
    required this.frequency,
    required this.streamUrl,
    this.imageUrl,
    required this.category,
    required this.region,
    required this.language,
    this.description,
    this.isNational = false,
    this.isOnline = true,
    this.programs = const [],
  });

  String get displayName => '$name $frequency';
}
