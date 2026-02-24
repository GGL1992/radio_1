import 'package:flutter/material.dart';
import '../features/home/home_screen.dart';
import '../features/player/player_screen.dart';
import '../features/search/search_screen.dart';
import '../features/category/category_screen.dart';
import '../features/favorites/favorites_screen.dart';
import '../features/downloads/downloads_screen.dart';
import '../features/history/history_screen.dart';
import '../features/settings/settings_screen.dart';

class AppRouter {
  static const String home = '/';
  static const String player = '/player';
  static const String search = '/search';
  static const String category = '/category';
  static const String favorites = '/favorites';
  static const String downloads = '/downloads';
  static const String history = '/history';
  static const String settings = '/settings';
  static const String stationDetail = '/station';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );
      case player:
        return MaterialPageRoute(
          builder: (_) => const PlayerScreen(),
          settings: settings,
        );
      case search:
        return MaterialPageRoute(
          builder: (_) => const SearchScreen(),
          settings: settings,
        );
      case category:
        return MaterialPageRoute(
          builder: (_) => const CategoryScreen(),
          settings: settings,
        );
      case favorites:
        return MaterialPageRoute(
          builder: (_) => const FavoritesScreen(),
          settings: settings,
        );
      case downloads:
        return MaterialPageRoute(
          builder: (_) => const DownloadsScreen(),
          settings: settings,
        );
      case history:
        return MaterialPageRoute(
          builder: (_) => const HistoryScreen(),
          settings: settings,
        );
      case settings:
        return MaterialPageRoute(
          builder: (_) => const SettingsScreen(),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('页面未找到')),
          ),
        );
    }
  }
}