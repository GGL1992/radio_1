import 'package:flutter/material.dart';

class GlowingIndicator extends StatefulWidget {
  final bool isOn;
  final Color onColor;
  final Color offColor;
  final double size;
  final String? label;

  const GlowingIndicator({
    super.key,
    required this.isOn,
    this.onColor = const Color(0xFF00FF00),
    this.offColor = const Color(0xFF333333),
    this.size = 12,
    this.label,
  });

  @override
  State<GlowingIndicator> createState() => _GlowingIndicatorState();
}

class _GlowingIndicatorState extends State<GlowingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.isOn) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(GlowingIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isOn && !oldWidget.isOn) {
      _controller.repeat(reverse: true);
    } else if (!widget.isOn && oldWidget.isOn) {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.isOn
                    ? widget.onColor.withOpacity(_animation.value)
                    : widget.offColor,
                boxShadow: widget.isOn
                    ? [
                        BoxShadow(
                          color: widget.onColor.withOpacity(0.8),
                          blurRadius: widget.size * 0.5,
                          spreadRadius: widget.size * 0.2,
                        ),
                      ]
                    : null,
              ),
            );
          },
        ),
        if (widget.label != null) ...[
          const SizedBox(height: 4),
          Text(
            widget.label!,
            style: TextStyle(
              fontSize: 10,
              color: widget.isOn ? widget.onColor : Colors.white38,
            ),
          ),
        ],
      ],
    );
  }
}

class FrequencyDisplay extends StatelessWidget {
  final String frequency;
  final String? stationName;
  final bool isPlaying;

  const FrequencyDisplay({
    super.key,
    required this.frequency,
    this.stationName,
    this.isPlaying = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0a0a0a),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFB8860B),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // LED 风格频率显示
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'FM',
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF001100),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  frequency,
                  style: TextStyle(
                    fontFamily: 'Courier',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: isPlaying
                        ? const Color(0xFF00FF00)
                        : const Color(0xFF004400),
                    letterSpacing: 2,
                    shadows: isPlaying
                        ? [
                            Shadow(
                              color: const Color(0xFF00FF00).withOpacity(0.5),
                              blurRadius: 10,
                            ),
                          ]
                        : null,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                'MHz',
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
          if (stationName != null) ...[
            const SizedBox(height: 8),
            Text(
              stationName!,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                              fontSize: 14,              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}

class RetroButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final String? label;
  final bool isActive;

  const RetroButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = 48,
    this.label,
    this.isActive = false,
  });

  @override
  State<RetroButton> createState() => _RetroButtonState();
}

class _RetroButtonState extends State<RetroButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: _isPressed
                  ? const Color(0xFF333333)
                  : const Color(0xFF444444),
              shape: BoxShape.circle,
              border: Border.all(
                color: widget.isActive
                    ? const Color(0xFFB8860B)
                    : const Color(0xFF666666),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: Offset(0, _isPressed ? 1 : 3),
                  blurRadius: _isPressed ? 2 : 4,
                ),
              ],
            ),
            child: Icon(
              widget.icon,
              color: widget.isActive
                  ? const Color(0xFFB8860B)
                  : Colors.white.withOpacity(0.8),
              size: widget.size * 0.5,
            ),
          ),
          if (widget.label != null) ...[
            const SizedBox(height: 4),
            Text(
              widget.label!,
              style: TextStyle(
                fontSize: 10,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class WoodenPanel extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;

  const WoodenPanel({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF5D4037),
            Color(0xFF4E342E),
            Color(0xFF3E2723),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF8B4513),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
                      blurRadius: 10,            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
