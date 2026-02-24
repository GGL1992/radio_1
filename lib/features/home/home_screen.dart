import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/radio_station.dart';
import '../../data/repositories/repositories.dart';
import '../../data/datasources/remote/built_in_stations.dart';
import '../../router/app_router.dart';
import '../../services/audio/audio_player_service.dart';

// 电台列表提供者
final stationListProvider = FutureProvider<List<RadioStation>>((ref) async {
  final repository = ref.watch(stationRepositoryProvider);
  var stations = repository.getAllStations();
  
  // 如果本地没有数据，加载内置数据
  if (stations.isEmpty) {
    final builtInStations = BuiltInStations.getStations();
    await repository.addStations(builtInStations);
    stations = builtInStations;
  }
  
  return stations;
});

// 分类提供者
final categoriesProvider = Provider<List<String>>((ref) {
  return BuiltInStations.getCategories();
});

// 地区提供者
final regionsProvider = Provider<List<String>>((ref) {
  return BuiltInStations.getRegions();
});

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // 初始化加载内置电台 - 使用 invalidate 触发重新加载
    Future.microtask(() {
      ref.invalidate(stationListProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          _HomePage(),
          CategoryScreen(),
          FavoritesScreen(),
          SettingsScreen(),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1A1A2E),
        selectedItemColor: const Color(0xFFB8860B),
        unselectedItemColor: Colors.white38,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: '首页',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category_outlined),
            activeIcon: Icon(Icons.category),
            label: '分类',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            activeIcon: Icon(Icons.favorite),
            label: '收藏',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: '设置',
          ),
        ],
      ),
    );
  }
}

class _HomePage extends ConsumerWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stationsAsync = ref.watch(stationListProvider);

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
              // 顶部搜索栏
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        '复古收音机',
                        style: TextStyle(
                          color: Color(0xFFB8860B),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search, color: Colors.white70),
                      onPressed: () {
                        Navigator.pushNamed(context, AppRouter.search);
                      },
                    ),
                  ],
                ),
              ),

              // 快捷入口
              _buildQuickActions(context),

              const SizedBox(height: 16),

              // 电台列表
              Expanded(
                child: stationsAsync.when(
                  data: (stations) => _buildStationList(stations, ref),
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFB8860B),
                    ),
                  ),
                  error: (error, stack) => Center(
                    child: Text('加载失败: $error'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFB8860B),
        child: const Icon(Icons.radio, color: Colors.white),
        onPressed: () {
          Navigator.pushNamed(context, AppRouter.player);
        },
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildQuickAction(
            icon: Icons.public,
            label: '全国电台',
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRouter.category,
                arguments: {'filter': '全国'},
              );
            },
          ),
          const SizedBox(width: 12),
          _buildQuickAction(
            icon: Icons.history,
            label: '最近收听',
            onTap: () {
              Navigator.pushNamed(context, AppRouter.history);
            },
          ),
          const SizedBox(width: 12),
          _buildQuickAction(
            icon: Icons.download,
            label: '已下载',
            onTap: () {
              Navigator.pushNamed(context, AppRouter.downloads);
            },
          ),
          const SizedBox(width: 12),
          _buildQuickAction(
            icon: Icons.trending_up,
            label: '热门推荐',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A4A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFB8860B).withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFB8860B), size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStationList(List<RadioStation> stations, WidgetRef ref) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: stations.length,
      itemBuilder: (context, index) {
        final station = stations[index];
        return _StationCard(
          station: station,
          onTap: () {
            // 播放电台
            final audioService = ref.read(audioPlayerServiceProvider);
            audioService.playStation(station);
            Navigator.pushNamed(context, AppRouter.player);
          },
        );
      },
    );
  }
}

class _StationCard extends StatelessWidget {
  final RadioStation station;
  final VoidCallback? onTap;

  const _StationCard({
    required this.station,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A4A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFB8860B).withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFF333355),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.radio,
                color: Color(0xFFB8860B),
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    station.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    station.frequency,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${station.category} · ${station.region}',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.4),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFFB8860B),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
