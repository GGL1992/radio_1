import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/download_task.dart';
import '../../data/repositories/repositories.dart';

class DownloadsScreen extends ConsumerWidget {
  const DownloadsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final downloads = ref.watch(downloadRepositoryProvider).getAllDownloads();

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
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white70),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      '下载管理',
                      style: TextStyle(
                        color: Color(0xFFB8860B),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    if (downloads.isNotEmpty)
                      TextButton(
                        onPressed: () {
                          // 清空已完成的下载
                        },
                        child: const Text('清空已完成'),
                      ),
                  ],
                ),
              ),

              if (downloads.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.download_outlined,
                          size: 64,
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '暂无下载',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '您可以下载节目离线收听',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.3),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: downloads.length,
                    itemBuilder: (context, index) {
                      final task = downloads[index];
                      return _DownloadItem(task: task);
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DownloadItem extends StatelessWidget {
  final DownloadTask task;

  const _DownloadItem({required this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A4A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _getStatusColor().withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getStatusIcon(),
                  color: _getStatusColor(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.programId,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getStatusText(),
                      style: TextStyle(
                        color: _getStatusColor(),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (task.status == DownloadStatus.downloading)
                Text(
                  '${(task.progress * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(color: Colors.white70),
                ),
            ],
          ),
          if (task.status == DownloadStatus.downloading) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: task.progress,
                backgroundColor: const Color(0xFF333355),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFFB8860B),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getStatusColor() {
    switch (task.status) {
      case DownloadStatus.pending:
        return Colors.grey;
      case DownloadStatus.downloading:
        return const Color(0xFFB8860B);
      case DownloadStatus.completed:
        return Colors.green;
      case DownloadStatus.failed:
        return Colors.red;
      case DownloadStatus.paused:
        return Colors.orange;
    }
  }

  IconData _getStatusIcon() {
    switch (task.status) {
      case DownloadStatus.pending:
        return Icons.schedule;
      case DownloadStatus.downloading:
        return Icons.downloading;
      case DownloadStatus.completed:
        return Icons.check_circle;
      case DownloadStatus.failed:
        return Icons.error;
      case DownloadStatus.paused:
        return Icons.pause_circle;
    }
  }

  String _getStatusText() {
    switch (task.status) {
      case DownloadStatus.pending:
        return '等待下载';
      case DownloadStatus.downloading:
        return '下载中...';
      case DownloadStatus.completed:
        return '下载完成';
      case DownloadStatus.failed:
        return '下载失败';
      case DownloadStatus.paused:
        return '已暂停';
    }
  }
}
