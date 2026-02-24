import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/radio_station.dart';
import '../../data/models/favorite.dart';
import '../../data/repositories/repositories.dart';
import '../../services/audio/audio_player_service.dart';
import '../../router/app_router.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final favorites = ref.watch(favoriteRepositoryProvider).getAllFavorites();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
              Color(0xFF0F0F1A),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 顶部标题
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Text(
                      '我的收藏',
                      style: TextStyle(
                        color: Color(0xFFB8860B),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '共 ${favorites.length} 项',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              // Tab栏
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A4A),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: const Color(0xFFB8860B),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  indicatorPadding: const EdgeInsets.all(4),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white60,
                  tabs: const [
                    Tab(text: '电台'),
                    Tab(text: '节目'),
                    Tab(text: '主持人'),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 收藏列表
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildFavoritesList(favorites, FavoriteType.station),
                    _buildFavoritesList(favorites, FavoriteType.program),
                    _buildFavoritesList(favorites, FavoriteType.host),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFavoritesList(List<Favorite> favorites, FavoriteType type) {
    final filteredFavorites = favorites.where((f) => f.type == type).toList();

    if (filteredFavorites.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 64,
              color: Colors.white.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              '暂无收藏',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: filteredFavorites.length,
      itemBuilder: (context, index) {
        final favorite = filteredFavorites[index];
        return _buildFavoriteItem(favorite, type);
      },
    );
  }

  Widget _buildFavoriteItem(Favorite favorite, FavoriteType type) {
    final stationRepository = ref.read(stationRepositoryProvider);
    final station = stationRepository.getStationById(favorite.targetId);

    return Dismissible(
      key: Key(favorite.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        ref.read(favoriteRepositoryProvider).removeFavorite(favorite.id);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A4A),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF333355),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getIconForType(type),
                color: const Color(0xFFB8860B),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    station?.name ?? '未知',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Text(
                    '收藏于 ${_formatDate(favorite.createdAt)}',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (type == FavoriteType.station && station != null)
              IconButton(
                icon: const Icon(Icons.play_circle_outline),
                color: const Color(0xFFB8860B),
                onPressed: () {
                  final audioService = ref.read(audioPlayerServiceProvider);
                  audioService.playStation(station);
                  Navigator.pushNamed(context, AppRouter.player);
                },
              ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForType(FavoriteType type) {
    switch (type) {
      case FavoriteType.station:
        return Icons.radio;
      case FavoriteType.program:
        return Icons.podcasts;
      case FavoriteType.host:
        return Icons.person;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
