import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/radio_station.dart';
import '../../data/datasources/remote/built_in_stations.dart';
import '../../data/repositories/repositories.dart';
import '../../services/audio/audio_player_service.dart';
import '../../router/app_router.dart';

class CategoryScreen extends ConsumerStatefulWidget {
  const CategoryScreen({super.key});

  @override
  ConsumerState<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends ConsumerState<CategoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _selectedFilter;

  final List<String> _tabs = ['分类', '地区', '语言'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                      '分类浏览',
                      style: TextStyle(
                        color: Color(0xFFB8860B),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.search, color: Colors.white70),
                      onPressed: () {
                        Navigator.pushNamed(context, AppRouter.search);
                      },
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
                  tabs: _tabs.map((t) => Tab(text: t)).toList(),
                ),
              ),

              const SizedBox(height: 16),

              // Tab内容
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildCategoryGrid(BuiltInStations.getCategories(), 'category'),
                    _buildCategoryGrid(BuiltInStations.getRegions(), 'region'),
                    _buildCategoryGrid(BuiltInStations.getLanguages(), 'language'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryGrid(List<String> items, String type) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.5,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return GestureDetector(
          onTap: () => _showStationsByFilter(item, type),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A4A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFB8860B).withOpacity(0.2),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getIconForType(type),
                  color: const Color(0xFFB8860B),
                  size: 24,
                ),
                const SizedBox(height: 8),
                Text(
                  item,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'category':
        return Icons.category;
      case 'region':
        return Icons.location_on;
      case 'language':
        return Icons.language;
      default:
        return Icons.radio;
    }
  }

  void _showStationsByFilter(String filter, String type) {
    final repository = ref.read(stationRepositoryProvider);
    List<RadioStation> stations;

    switch (type) {
      case 'category':
        stations = repository.getStationsByCategory(filter);
        break;
      case 'region':
        stations = repository.getStationsByRegion(filter);
        break;
      default:
        stations = repository.getAllStations();
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A2E),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(
                    filter,
                    style: const TextStyle(
                      color: Color(0xFFB8860B),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${stations.length} 个电台',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white12),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: stations.length,
                itemBuilder: (context, index) {
                  final station = stations[index];
                  return ListTile(
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF333355),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.radio,
                        color: Color(0xFFB8860B),
                      ),
                    ),
                    title: Text(
                      station.name,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      station.frequency,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                    trailing: const Icon(
                      Icons.play_circle_outline,
                      color: Color(0xFFB8860B),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      final audioService = ref.read(audioPlayerServiceProvider);
                      audioService.playStation(station);
                      Navigator.pushNamed(context, AppRouter.player);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
