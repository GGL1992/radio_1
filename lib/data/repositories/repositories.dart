import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/radio_station.dart';
import '../models/favorite.dart';
import '../models/play_history.dart';
import '../models/download_task.dart';
import '../models/app_settings.dart';
import 'hive_service.dart';

// Hive 服务提供者
final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});

// 电台仓库
final stationRepositoryProvider = Provider<StationRepository>((ref) {
  return StationRepository(ref.watch(hiveServiceProvider));
});

class StationRepository {
  final HiveService _hiveService;

  StationRepository(this._hiveService);

  List<RadioStation> getAllStations() {
    return _hiveService.stations.values.toList();
  }

  RadioStation? getStationById(String id) {
    return _hiveService.stations.get(id);
  }

  List<RadioStation> getStationsByCategory(String category) {
    return _hiveService.stations.values
        .where((s) => s.category == category)
        .toList();
  }

  List<RadioStation> getStationsByRegion(String region) {
    return _hiveService.stations.values
        .where((s) => s.region == region)
        .toList();
  }

  List<RadioStation> searchStations(String query) {
    final lowerQuery = query.toLowerCase();
    return _hiveService.stations.values.where((s) {
      return s.name.toLowerCase().contains(lowerQuery) ||
          s.frequency.toLowerCase().contains(lowerQuery) ||
          s.category.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  Future<void> addStation(RadioStation station) async {
    await _hiveService.stations.put(station.id, station);
  }

  Future<void> addStations(List<RadioStation> stations) async {
    for (final station in stations) {
      await _hiveService.stations.put(station.id, station);
    }
  }
}

// 收藏仓库
final favoriteRepositoryProvider = Provider<FavoriteRepository>((ref) {
  return FavoriteRepository(ref.watch(hiveServiceProvider));
});

class FavoriteRepository {
  final HiveService _hiveService;

  FavoriteRepository(this._hiveService);

  List<Favorite> getAllFavorites() {
    return _hiveService.favorites.values.toList();
  }

  List<Favorite> getFavoritesByType(FavoriteType type) {
    return _hiveService.favorites.values
        .where((f) => f.type == type)
        .toList();
  }

  bool isFavorite(String targetId) {
    return _hiveService.favorites.values
        .any((f) => f.targetId == targetId);
  }

  Favorite? getFavoriteByTargetId(String targetId) {
    try {
      return _hiveService.favorites.values
          .firstWhere((f) => f.targetId == targetId);
    } catch (_) {
      return null;
    }
  }

  Future<void> addFavorite(Favorite favorite) async {
    await _hiveService.favorites.put(favorite.id, favorite);
  }

  Future<void> removeFavorite(String id) async {
    await _hiveService.favorites.delete(id);
  }

  Future<void> toggleFavorite(Favorite favorite) async {
    final existing = getFavoriteByTargetId(favorite.targetId);
    if (existing != null) {
      await removeFavorite(existing.id);
    } else {
      await addFavorite(favorite);
    }
  }
}

// 播放历史仓库
final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  return HistoryRepository(ref.watch(hiveServiceProvider));
});

class HistoryRepository {
  final HiveService _hiveService;

  HistoryRepository(this._hiveService);

  List<PlayHistory> getAllHistory() {
    final list = _hiveService.history.values.toList();
    list.sort((a, b) => b.playedAt.compareTo(a.playedAt));
    return list;
  }

  List<PlayHistory> getRecentHistory({int limit = 20}) {
    final all = getAllHistory();
    return all.take(limit).toList();
  }

  Future<void> addHistory(PlayHistory history) async {
    await _hiveService.history.put(history.id, history);
  }

  Future<void> clearHistory() async {
    await _hiveService.history.clear();
  }
}

// 下载仓库
final downloadRepositoryProvider = Provider<DownloadRepository>((ref) {
  return DownloadRepository(ref.watch(hiveServiceProvider));
});

class DownloadRepository {
  final HiveService _hiveService;

  DownloadRepository(this._hiveService);

  List<DownloadTask> getAllDownloads() {
    return _hiveService.downloads.values.toList();
  }

  List<DownloadTask> getPendingDownloads() {
    return _hiveService.downloads.values
        .where((d) => d.status == DownloadStatus.pending ||
                      d.status == DownloadStatus.downloading)
        .toList();
  }

  DownloadTask? getDownloadByProgramId(String programId) {
    try {
      return _hiveService.downloads.values
          .firstWhere((d) => d.programId == programId);
    } catch (_) {
      return null;
    }
  }

  Future<void> addDownload(DownloadTask task) async {
    await _hiveService.downloads.put(task.id, task);
  }

  Future<void> updateDownload(DownloadTask task) async {
    await _hiveService.downloads.put(task.id, task);
  }

  Future<void> removeDownload(String id) async {
    await _hiveService.downloads.delete(id);
  }
}

// 设置仓库
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository(ref.watch(hiveServiceProvider));
});

class SettingsRepository {
  final HiveService _hiveService;

  SettingsRepository(this._hiveService);

  AppSettings getSettings() {
    return _hiveService.settings.get('settings') ?? AppSettings();
  }

  Future<void> saveSettings(AppSettings settings) async {
    await _hiveService.settings.put('settings', settings);
  }
}
