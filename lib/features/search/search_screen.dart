import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/radio_station.dart';
import '../../data/datasources/remote/built_in_stations.dart';
import '../../data/repositories/repositories.dart';
import '../../services/audio/audio_player_service.dart';
import '../../router/app_router.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<RadioStation> _results = [];
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    if (query.isEmpty) {
      setState(() => _results = []);
      return;
    }

    setState(() => _isSearching = true);

    final repository = ref.read(stationRepositoryProvider);
    final results = repository.searchStations(query);

    setState(() {
      _results = results;
      _isSearching = false;
    });
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
              // 搜索栏
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white70),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2A4A),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: const Color(0xFFB8860B).withOpacity(0.3),
                          ),
                        ),
                        child: TextField(
                          controller: _searchController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: '搜索电台、节目、主持人...',
                            hintStyle: TextStyle(color: Colors.white38),
                            border: InputBorder.none,
                            icon: Icon(Icons.search, color: Colors.white38),
                          ),
                          onChanged: _onSearch,
                          autofocus: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 热门搜索
              if (_results.isEmpty && !_isSearching) _buildHotSearches(),

              // 搜索结果
              if (_results.isNotEmpty || _isSearching)
                Expanded(
                  child: _isSearching
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFB8860B),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _results.length,
                          itemBuilder: (context, index) {
                            final station = _results[index];
                            return _buildResultItem(station);
                          },
                        ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHotSearches() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '热门搜索',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              '中国之声',
              '交通广播',
              '音乐之声',
              '北京广播',
              '上海广播',
              '新闻广播',
            ].map((tag) {
              return GestureDetector(
                onTap: () {
                  _searchController.text = tag;
                  _onSearch(tag);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A4A),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildResultItem(RadioStation station) {
    return GestureDetector(
      onTap: () {
        final audioService = ref.read(audioPlayerServiceProvider);
        audioService.playStation(station);
        Navigator.pushNamed(context, AppRouter.player);
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
              child: const Icon(
                Icons.radio,
                color: Color(0xFFB8860B),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    station.name,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Text(
                    station.frequency,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.play_circle_outline,
              color: Color(0xFFB8860B),
            ),
          ],
        ),
      ),
    );
  }
}
