import 'dart:math' as math;
import 'package:flutter/material.dart';

class VUMeter extends StatefulWidget {
  final double level;
  final double width;
  final double height;
  final bool isStereo;

  const VUMeter({
    super.key,
    required this.level,
    this.width = 200,
    this.height = 30,
    this.isStereo = false,
  });

  @override
  State<VUMeter> createState() => _VUMeterState();
}

class _VUMeterState extends State<VUMeter> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _displayLevel = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    )..addListener(() {
        setState(() {
          _displayLevel = _displayLevel + (widget.level - _displayLevel) * 0.3;
        });
      });
    _controller.repeat();
  }

  @override
  void didUpdateWidget(VUMeter oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isStereo) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildMeter('L', _displayLevel),
          const SizedBox(height: 4),
          _buildMeter('R', _displayLevel * 0.95),
        ],
      );
    }
    return _buildMeter('', _displayLevel);
  }

  Widget _buildMeter(String label, double level) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label.isNotEmpty)
          SizedBox(
            width: 16,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: const Color(0xFFB8860B),
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: CustomPaint(
              size: Size(widget.width, widget.height),
              painter: _VUMeterPainter(level: level.clamp(0.0, 1.0)),
            ),
          ),
        ),
      ],
    );
  }
}

class _VUMeterPainter extends CustomPainter {
  final double level;

  _VUMeterPainter({required this.level});

  @override
  void paint(Canvas canvas, Size size) {
    final segmentWidth = (size.width - 20) / 20;
    final segmentHeight = size.height - 8;
    final activeSegments = (level * 20).floor();

    for (var i = 0; i < 20; i++) {
      final x = 4 + i * segmentWidth;
      final y = 4.0;

      Color color;
      if (i < 12) {
        color = const Color(0xFF00FF00); // 绿色
      } else if (i < 16) {
        color = const Color(0xFFFFFF00); // 黄色
      } else {
        color = const Color(0xFFFF0000); // 红色
      }

      final paint = Paint()
        ..color = i < activeSegments
            ? color
            : color.withOpacity(0.2);

      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x + 1, y, segmentWidth - 2, segmentHeight),
        const Radius.circular(1),
      );
      canvas.drawRRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _VUMeterPainter oldDelegate) {
    return level != oldDelegate.level;
  }
}

class AnalogVUMeter extends StatelessWidget {
  final double level;
  final double size;

  const AnalogVUMeter({
    super.key,
    required this.level,
    this.size = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size * 0.6,
      decoration: BoxDecoration(
        color: const Color(0xFF1a1a1a),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFB8860B),
          width: 2,
        ),
      ),
      child: CustomPaint(
        size: Size(size, size * 0.6),
        painter: _AnalogVUPainter(level: level.clamp(0.0, 1.0)),
      ),
    );
  }
}

class _AnalogVUPainter extends CustomPainter {
  final double level;

  _AnalogVUPainter({required this.level});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.8);
    final radius = size.width * 0.4;

    // 绘制刻度弧
    final arcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final colors = <Color>[
      const Color(0xFF00FF00),
      const Color(0xFFFFFF00),
      const Color(0xFFFF0000),
    ];

    for (var i = 0; i < 3; i++) {
      final startAngle = -math.pi * 0.75 + i * math.pi * 0.25;
      final sweepAngle = math.pi * 0.25;
      arcPaint.color = colors[i];
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        arcPaint,
      );
    }

    // 绘制刻度数字
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    final labels = ['-20', '-10', '0', '+3'];
    for (var i = 0; i < 4; i++) {
      final angle = -math.pi * 0.75 + i * math.pi * 0.25;
      final x = center.dx + radius * 0.7 * math.cos(angle);
      final y = center.dy + radius * 0.7 * math.sin(angle);

      textPainter.text = TextSpan(
        text: labels[i],
        style: const TextStyle(
          color: Colors.white60,
          fontSize: 8,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, y - textPainter.height / 2),
      );
    }

    // 绘制指针
    final needleAngle = -math.pi * 0.75 + level * math.pi * 0.75;
    final needlePaint = Paint()
      ..color = const Color(0xFFFF4444)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final needleEnd = Offset(
      center.dx + radius * 0.9 * math.cos(needleAngle),
      center.dy + radius * 0.9 * math.sin(needleAngle),
    );

    canvas.drawLine(center, needleEnd, needlePaint);

    // 中心点
    canvas.drawCircle(center, 4, Paint()..color = Colors.grey);
  }

  @override
  bool shouldRepaint(covariant _AnalogVUPainter oldDelegate) {
    return level != oldDelegate.level;
  }
}
