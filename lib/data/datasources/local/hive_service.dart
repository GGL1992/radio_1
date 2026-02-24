import 'package:hive/hive.dart';
import '../models/radio_station.dart';
import '../models/program.dart';
import '../models/host.dart';
import '../models/favorite.dart';
import '../models/play_history.dart';
import '../models/download_task.dart';
import '../models/app_settings.dart';

class HiveService {
  static const String stationsBox = 'stations';
  static const String programsBox = 'programs';
  static const String hostsBox = 'hosts';
  static const String favoritesBox = 'favorites';
  static const String historyBox = 'history';
  static const String downloadsBox = 'downloads';
  static const String settingsBox = 'settings';

  Box<RadioStation> get stations => Hive.box<RadioStation>(stationsBox);
  Box<Program> get programs => Hive.box<Program>(programsBox);
  Box<Host> get hosts => Hive.box<Host>(hostsBox);
  Box<Favorite> get favorites => Hive.box<Favorite>(favoritesBox);
  Box<PlayHistory> get history => Hive.box<PlayHistory>(historyBox);
  Box<DownloadTask> get downloads => Hive.box<DownloadTask>(downloadsBox);
  Box<AppSettings> get settings => Hive.box<AppSettings>(settingsBox);

  Future<void> clearAll() async {
    await stations.clear();
    await programs.clear();
    await hosts.clear();
    await favorites.clear();
    await history.clear();
    await downloads.clear();
    await settings.clear();
  }
}