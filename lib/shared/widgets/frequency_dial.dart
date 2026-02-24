import 'package:flutter/material.dart';

class FrequencyDial extends StatelessWidget {
  final double frequency;
  final double minFrequency;
  final double maxFrequency;
  final double height;
  final bool isPlaying;

  const FrequencyDial({
    super.key,
    required this.frequency,
    this.minFrequency = 87.5,
    this.maxFrequency = 108.0,
    this.height = 120,
    this.isPlaying = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1a1a1a),
            Color(0xFF2d2d2d),
            Color(0xFF1a1a1a),
          ],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFB8860B),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
                      blurRadius: 10,            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: CustomPaint(
          size: Size.infinite,
          painter: _DialPainter(
            frequency: frequency,
            minFrequency: minFrequency,
            maxFrequency: maxFrequency,
            isPlaying: isPlaying,
          ),
        ),
      ),
    );
  }
}

class _DialPainter extends CustomPainter {
  final double frequency;
  final double minFrequency;
  final double maxFrequency;
  final bool isPlaying;

  _DialPainter({
    required this.frequency,
    required this.minFrequency,
    required this.maxFrequency,
    required this.isPlaying,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // 绘制刻度背景线
    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 1;

    // 绘制频率刻度
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    final frequencyRange = maxFrequency - minFrequency;
    final step = frequencyRange / 10;

    for (var i = 0; i <= 10; i++) {
      final freq = minFrequency + i * step;
      final x = (i / 10) * size.width;

      // 刻度线
      final isMain = i % 2 == 0;
      final lineLength = isMain ? 20.0 : 10.0;
      canvas.drawLine(
        Offset(x, size.height - lineLength),
        Offset(x, size.height),
        linePaint..strokeWidth = isMain ? 2 : 1,
      );

      // 频率数字
      if (isMain) {
        textPainter.text = TextSpan(
          text: freq.toStringAsFixed(0),
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(x - textPainter.width / 2, 10),
        );
      }
    }

    // 绘制中间的频率指针
    final normalizedPosition = (frequency - minFrequency) / frequencyRange;
    final pointerX = normalizedPosition * size.width;

    // 指针发光效果
    if (isPlaying) {
      final glowPaint = Paint()
        ..color = const Color(0xFF00FF00).withOpacity(0.3)
              ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);      canvas.drawRect(
        Rect.fromLTWH(pointerX - 15, 0, 30, size.height),
        glowPaint,
      );
    }

    // 绘制指针线
    final pointerPaint = Paint()
      ..color = isPlaying ? const Color(0xFF00FF00) : const Color(0xFFFF4444)
      ..strokeWidth = 2;
    canvas.drawLine(
      Offset(pointerX, 30),
      Offset(pointerX, size.height - 5),
      pointerPaint,
    );

    // 绘制指针三角形
    final path = Path();
    path.moveTo(pointerX, size.height - 5);
    path.lineTo(pointerX - 6, size.height - 15);
    path.lineTo(pointerX + 6, size.height - 15);
    path.close();
    canvas.drawPath(path, pointerPaint..style = PaintingStyle.fill);

    // 绘制FM标签
    textPainter.text = const TextSpan(
      text: 'FM MHz',
      style: TextStyle(
        color: Colors.white38,
        fontSize: 10,
        letterSpacing: 2,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(size.width - textPainter.width - 10, size.height - 25),
    );
  }

  @override
  bool shouldRepaint(covariant _DialPainter oldDelegate) {
    return frequency != oldDelegate.frequency ||
        isPlaying != oldDelegate.isPlaying;
  }
}
