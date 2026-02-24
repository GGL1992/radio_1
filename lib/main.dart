import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'app.dart';
import 'data/models/radio_station.dart';
import 'data/models/program.dart';
import 'data/models/host.dart';
import 'data/models/favorite.dart';
import 'data/models/play_history.dart';
import 'data/models/download_task.dart';
import 'data/models/app_settings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化 Hive
  await Hive.initFlutter();
  
  // 注册 Hive 适配器
  Hive.registerAdapter(RadioStationAdapter());
  Hive.registerAdapter(ProgramAdapter());
  Hive.registerAdapter(HostAdapter());
  Hive.registerAdapter(FavoriteAdapter());
  Hive.registerAdapter(PlayHistoryAdapter());
  Hive.registerAdapter(DownloadTaskAdapter());
  Hive.registerAdapter(AppSettingsAdapter());
  Hive.registerAdapter(FavoriteTypeAdapter());
  Hive.registerAdapter(DownloadStatusAdapter());
  
  // 打开 Hive Box
  await Hive.openBox<RadioStation>('stations');
  await Hive.openBox<Program>('programs');
  await Hive.openBox<Host>('hosts');
  await Hive.openBox<Favorite>('favorites');
  await Hive.openBox<PlayHistory>('history');
  await Hive.openBox<DownloadTask>('downloads');
  await Hive.openBox<AppSettings>('settings');
  
  // 初始化后台音频服务
  await JustAudioBackground.init();
  
  runApp(const RetroRadioApp());
}
