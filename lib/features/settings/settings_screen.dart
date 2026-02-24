import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/app_settings.dart';
import '../../data/repositories/repositories.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late AppSettings _settings;

  @override
  void initState() {
    super.initState();
    _settings = ref.read(settingsRepositoryProvider).getSettings();
  }

  Future<void> _saveSettings(AppSettings newSettings) async {
    setState(() => _settings = newSettings);
    await ref.read(settingsRepositoryProvider).saveSettings(newSettings);
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
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                '设置',
                style: TextStyle(
                  color: Color(0xFFB8860B),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // 外观设置
              _buildSection('外观设置', [
                _buildSwitchTile(
                  icon: Icons.dark_mode,
                  title: '夜间模式',
                  subtitle: '深色主题保护眼睛',
                  value: _settings.isDarkMode,
                  onChanged: (value) {
                    _saveSettings(_settings.copyWith(isDarkMode: value));
                    ref.read(themeModeProvider.notifier).setTheme(
                      value ? ThemeMode.dark : ThemeMode.light,
                    );
                  },
                ),
              ]),

              const SizedBox(height: 24),

              // 播放设置
              _buildSection('播放设置', [
                _buildSwitchTile(
                  icon: Icons.play_circle_outline,
                  title: '自动播放',
                  subtitle: '启动应用时自动继续上次播放',
                  value: _settings.autoPlay,
                  onChanged: (value) {
                    _saveSettings(_settings.copyWith(autoPlay: value));
                  },
                ),
                _buildListTile(
                  icon: Icons.high_quality,
                  title: '音质选择',
                  subtitle: _getAudioQualityText(_settings.audioQuality),
                  onTap: () => _showAudioQualityDialog(),
                ),
              ]),

              const SizedBox(height: 24),

              // 下载设置
              _buildSection('下载设置', [
                _buildSwitchTile(
                  icon: Icons.wifi,
                  title: '仅WiFi下载',
                  subtitle: '移动网络下不自动下载',
                  value: _settings.downloadWifiOnly,
                  onChanged: (value) {
                    _saveSettings(_settings.copyWith(downloadWifiOnly: value));
                  },
                ),
              ]),

              const SizedBox(height: 24),

              // 数据管理
              _buildSection('数据管理', [
                _buildListTile(
                  icon: Icons.delete_outline,
                  title: '清除缓存',
                  subtitle: '清除临时文件和缓存',
                  onTap: () => _showClearCacheDialog(),
                ),
                _buildListTile(
                  icon: Icons.restore,
                  title: '重置应用',
                  subtitle: '恢复默认设置',
                  onTap: () => _showResetDialog(),
                ),
              ]),

              const SizedBox(height: 24),

              // 关于
              _buildSection('关于', [
                _buildListTile(
                  icon: Icons.info_outline,
                  title: '版本信息',
                  subtitle: 'v1.0.0',
                  onTap: null,
                ),
                _buildListTile(
                  icon: Icons.feedback_outlined,
                  title: '意见反馈',
                  subtitle: '帮助我们改进应用',
                  onTap: () {
                    // 打开反馈页面
                  },
                ),
                _buildListTile(
                  icon: Icons.star_outline,
                  title: '给个好评',
                  subtitle: '在应用商店为我们评分',
                  onTap: () {
                    // 打开应用商店
                  },
                ),
              ]),

              const SizedBox(height: 32),

              // 版权信息
              Center(
                child: Text(
                  '复古收音机 © 2024',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.3),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A4A),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFB8860B)),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFFB8860B),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFB8860B)),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
      ),
      trailing: onTap != null
          ? const Icon(Icons.chevron_right, color: Colors.white38)
          : null,
      onTap: onTap,
    );
  }

  String _getAudioQualityText(String quality) {
    switch (quality) {
      case 'high':
        return '高音质';
      case 'medium':
        return '标准音质';
      case 'low':
        return '省流音质';
      default:
        return '高音质';
    }
  }

  void _showAudioQualityDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A4A),
        title: const Text('音质选择', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildQualityOption('high', '高音质', '最佳听感，流量消耗较大'),
            _buildQualityOption('medium', '标准音质', '平衡音质与流量'),
            _buildQualityOption('low', '省流音质', '节省流量，音质一般'),
          ],
        ),
      ),
    );
  }

  Widget _buildQualityOption(String quality, String title, String desc) {
    return RadioListTile<String>(
      value: quality,
      groupValue: _settings.audioQuality,
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: Text(
        desc,
        style: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
      ),
      activeColor: const Color(0xFFB8860B),
      onChanged: (value) {
        if (value != null) {
          _saveSettings(_settings.copyWith(audioQuality: value));
          Navigator.pop(context);
        }
      },
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A4A),
        title: const Text('清除缓存', style: TextStyle(color: Colors.white)),
        content: const Text(
          '确定要清除所有缓存吗？这不会影响您的收藏和播放历史。',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('缓存已清除')),
              );
            },
            child: const Text('确定', style: TextStyle(color: Color(0xFFB8860B))),
          ),
        ],
      ),
    );
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A4A),
        title: const Text('重置应用', style: TextStyle(color: Colors.white)),
        content: const Text(
          '确定要重置所有设置吗？这将恢复默认设置。',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              _saveSettings(AppSettings());
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('设置已重置')),
              );
            },
            child: const Text('确定', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
