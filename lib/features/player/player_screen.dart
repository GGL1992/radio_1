import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/widgets/retro_widgets.dart';
import '../../shared/widgets/frequency_dial.dart';
import '../../shared/widgets/vu_meter.dart';
import '../../shared/widgets/retro_knob.dart';
import '../../data/models/radio_station.dart';
import '../../services/audio/audio_player_service.dart';

// 播放器服务提供者
final audioPlayerServiceProvider = Provider<AudioPlayerService>((ref) {
  return AudioPlayerService();
});

// 播放状态提供者
final audioStateProvider = StreamProvider<AudioState>((ref) {
  return ref.watch(audioPlayerServiceProvider).stateStream;
});

// 当前电台提供者
final currentStationProvider = StateProvider<RadioStation?>((ref) => null);

class PlayerScreen extends ConsumerStatefulWidget {
  const PlayerScreen({super.key});

  @override
  ConsumerState<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen> {
  double _volume = 0.7;
  double _mockAudioLevel = 0;

  @override
  void initState() {
    super.initState();
    // 模拟音频电平变化
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _updateAudioLevel();
    });
  }

  void _updateAudioLevel() {
    if (!mounted) return;
    final audioState = ref.read(audioStateProvider).valueOrNull;
    if (audioState?.status == PlaybackStatus.playing) {
      setState(() {
        _mockAudioLevel = 0.3 + (DateTime.now().millisecond % 100) / 100 * 0.5;
      });
    }
    Future.delayed(const Duration(milliseconds: 100), _updateAudioLevel);
  }

  @override
  Widget build(BuildContext context) {
    final audioState = ref.watch(audioStateProvider).valueOrNull ?? 
        const AudioState();
    final currentStation = audioState.currentStation;

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
              // 顶部状态栏
              _buildTopBar(audioState),
              
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      
                      // 频率显示
                      FrequencyDisplay(
                        frequency: currentStation?.frequency ?? '---',
                        stationName: currentStation?.name,
                        isPlaying: audioState.status == PlaybackStatus.playing,
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // 刻度盘
                      FrequencyDial(
                        frequency: _parseFrequency(currentStation?.frequency),
                        isPlaying: audioState.status == PlaybackStatus.playing,
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // 音量表
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          VUMeter(
                            level: audioState.status == PlaybackStatus.playing 
                                ? _mockAudioLevel 
                                : 0,
                            isStereo: true,
                          ),
                          const SizedBox(width: 16),
                          const AnalogVUMeter(
                            level: 0.6,
                            size: 80,
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // 播放控制按钮
                      _buildPlaybackControls(audioState),
                      
                      const SizedBox(height: 32),
                      
                      // 音量控制
                      WoodenPanel(
                        child: Column(
                          children: [
                            const Text(
                              '音量',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RetroKnob(
                                  value: _volume,
                                  size: 80,
                                  knobColor: const Color(0xFF444444),
                                  onChanged: (value) {
                                    setState(() => _volume = value);
                                    ref.read(audioPlayerServiceProvider)
                                        .setVolume(value);
                                  },
                                ),
                                const SizedBox(width: 24),
                                // 指示灯
                                Column(
                                  children: [
                                    GlowingIndicator(
                                      isOn: audioState.status == 
                                          PlaybackStatus.playing,
                                      onColor: const Color(0xFF00FF00),
                                      label: 'ON AIR',
                                    ),
                                    const SizedBox(height: 12),
                                    GlowingIndicator(
                                      isOn: audioState.status == 
                                          PlaybackStatus.buffering,
                                      onColor: const Color(0xFFFFFF00),
                                      label: 'BUFFER',
                                    ),
                                    const SizedBox(height: 12),
                                    GlowingIndicator(
                                      isOn: audioState.status == 
                                          PlaybackStatus.error,
                                      onColor: const Color(0xFFFF0000),
                                      label: 'ERROR',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // 当前播放信息
                      if (currentStation != null)
                        _buildStationInfo(currentStation, audioState),
                      
                      const SizedBox(height: 24),
                      
                      // 功能按钮
                      _buildActionButtons(currentStation),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(AudioState audioState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white70),
            onPressed: () {
              // 打开侧边栏
            },
          ),
          const Text(
            '复古收音机',
            style: TextStyle(
              color: Color(0xFFB8860B),
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          IconButton(
            icon: Icon(
              audioState.status == PlaybackStatus.playing
                  ? Icons.graphic_eq
                  : Icons.graphic_eq_outlined,
              color: audioState.status == PlaybackStatus.playing
                  ? const Color(0xFF00FF00)
                  : Colors.white38,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildPlaybackControls(AudioState audioState) {
    final audioService = ref.read(audioPlayerServiceProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RetroButton(
          icon: Icons.skip_previous,
          size: 48,
          onPressed: () {
            // 切换到上一个电台
          },
        ),
        const SizedBox(width: 24),
        RetroButton(
          icon: audioState.status == PlaybackStatus.playing
              ? Icons.pause
              : Icons.play_arrow,
          size: 72,
          isActive: audioState.status == PlaybackStatus.playing,
          onPressed: () {
            if (audioState.status == PlaybackStatus.playing) {
              audioService.pause();
            } else if (audioState.status == PlaybackStatus.paused) {
              audioService.resume();
            }
          },
        ),
        const SizedBox(width: 24),
        RetroButton(
          icon: Icons.skip_next,
          size: 48,
          onPressed: () {
            // 切换到下一个电台
          },
        ),
        const SizedBox(width: 24),
        RetroButton(
          icon: Icons.stop,
          size: 48,
          onPressed: () {
            audioService.stop();
          },
        ),
      ],
    );
  }

  Widget _buildStationInfo(RadioStation station, AudioState audioState) {
    return WoodenPanel(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFF333333),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.radio,
                  size: 32,
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
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${station.category} · ${station.region}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      station.description ?? '',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (audioState.errorMessage != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      audioState.errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtons(RadioStation? station) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(
          icon: Icons.favorite_border,
          label: '收藏',
          onTap: () {
            // 添加收藏
          },
        ),
        _buildActionButton(
          icon: Icons.download_outlined,
          label: '下载',
          onTap: () {
            // 下载节目
          },
        ),
        _buildActionButton(
          icon: Icons.share_outlined,
          label: '分享',
          onTap: () {
            // 分享
          },
        ),
        _buildActionButton(
          icon: Icons.list,
          label: '节目单',
          onTap: () {
            // 查看节目单
          },
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF333333),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF555555),
                width: 1,
              ),
            ),
            child: Icon(icon, color: Colors.white70, size: 24),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white60, fontSize: 12),
          ),
        ],
      ),
    );
  }

  double _parseFrequency(String? frequency) {
    if (frequency == null) return 98.0;
    final match = RegExp(r'(\d+\.?\d*)').firstMatch(frequency);
    if (match != null) {
      return double.tryParse(match.group(1)!) ?? 98.0;
    }
    return 98.0;
  }
}
