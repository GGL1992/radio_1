import 'dart:math' as math;
import 'package:flutter/material.dart';

class RetroKnob extends StatefulWidget {
  final double value;
  final ValueChanged<double>? onChanged;
  final double min;
  final double max;
  final double size;
  final String? label;
  final Color knobColor;
  final Color indicatorColor;

  const RetroKnob({
    super.key,
    required this.value,
    this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
    this.size = 80,
    this.label,
    this.knobColor = const Color(0xFF555555),
    this.indicatorColor = const Color(0xFFB8860B),
  });

  @override
  State<RetroKnob> createState() => _RetroKnobState();
}

class _RetroKnobState extends State<RetroKnob> {
  double _dragStartY = 0;
  double _dragStartValue = 0;

  double get _normalizedValue {
    return (widget.value - widget.min) / (widget.max - widget.min);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
        ],
        GestureDetector(
          onPanStart: _onPanStart,
          onPanUpdate: _onPanUpdate,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  offset: const Offset(2, 2),
                  blurRadius: 4,
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.1),
                  offset: const Offset(-1, -1),
                  blurRadius: 2,
                ),
              ],
            ),
            child: CustomPaint(
              size: Size(widget.size, widget.size),
              painter: _KnobPainter(
                value: _normalizedValue,
                knobColor: widget.knobColor,
                indicatorColor: widget.indicatorColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _onPanStart(DragStartDetails details) {
    _dragStartY = details.globalPosition.dy;
    _dragStartValue = widget.value;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final deltaY = _dragStartY - details.globalPosition.dy;
    final range = widget.max - widget.min;
    final sensitivity = range / 150;
    var newValue = _dragStartValue + deltaY * sensitivity;
    newValue = newValue.clamp(widget.min, widget.max);
    widget.onChanged?.call(newValue);
  }
}

class _KnobPainter extends CustomPainter {
  final double value;
  final Color knobColor;
  final Color indicatorColor;

  _KnobPainter({
    required this.value,
    required this.knobColor,
    required this.indicatorColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // 绘制外圈金属环
    final ringPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.grey.shade300,
          Colors.grey.shade600,
          Colors.grey.shade400,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, ringPaint);

    // 绘制内部旋钮
    final innerRadius = radius * 0.85;
    final innerPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        colors: [
          knobColor.withOpacity(0.9),
          knobColor,
          knobColor.withOpacity(1.0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: innerRadius));

    canvas.drawCircle(center, innerRadius, innerPaint);

    // 绘制中心点
    final centerDotPaint = Paint()..color = Colors.black26;
    canvas.drawCircle(center, 3, centerDotPaint);

    // 绘制指示器
    final angle = -135 + (value * 270) * math.pi / 180;
    final indicatorLength = innerRadius * 0.7;
    final indicatorPaint = Paint()
      ..color = indicatorColor
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final indicatorEnd = Offset(
      center.dx + indicatorLength * math.cos(angle),
      center.dy + indicatorLength * math.sin(angle),
    );

    canvas.drawLine(center, indicatorEnd, indicatorPaint);

    // 绘制刻度点
    final tickPaint = Paint()..color = Colors.white.withOpacity(0.5);
    for (var i = 0; i <= 10; i++) {
      final tickAngle = (-135 + i * 27) * math.pi / 180;
      final tickStart = radius * 0.9;
      final tickEnd = radius * 0.95;
      final start = Offset(
        center.dx + tickStart * math.cos(tickAngle),
        center.dy + tickStart * math.sin(tickAngle),
      );
      final end = Offset(
        center.dx + tickEnd * math.cos(tickAngle),
        center.dy + tickEnd * math.sin(tickAngle),
      );
      canvas.drawLine(start, end, tickPaint..strokeWidth = i % 5 == 0 ? 2 : 1);
    }
  }

  @override
  bool shouldRepaint(covariant _KnobPainter oldDelegate) {
    return value != oldDelegate.value ||
        knobColor != oldDelegate.knobColor ||
        indicatorColor != oldDelegate.indicatorColor;
  }
}
