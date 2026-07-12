import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A Material 3 Wavy Circular Progress Indicator.
///
/// It displays progress along a circular track, where the active track
/// oscillates in a wavy pattern based on polar coordinates. It supports
/// both determinate (specific progress value) and indeterminate (ongoing task) states.
class WavyCircularProgressIndicator extends StatefulWidget {
  /// Creates a Material 3 Wavy Circular Progress Indicator.
  const WavyCircularProgressIndicator({
    super.key,
    this.value,
    this.color,
    this.backgroundColor,
    this.strokeWidth = 4.0,
    this.trackStrokeWidth = 2.0,
    this.amplitude = 3.0,
    this.frequency = 8.0,
    this.waveSpeed = 4.0,
    this.size = 48.0,
    this.semanticsLabel,
    this.semanticsValue,
  });

  /// The progress value between 0.0 and 1.0.
  /// If null, this indicator is indeterminate.
  final double? value;

  /// The color of the active wavy progress track.
  /// Defaults to [ColorScheme.primary].
  final Color? color;

  /// The color of the inactive background track.
  /// Defaults to [ColorScheme.surfaceContainerHighest] or similar fallback.
  final Color? backgroundColor;

  /// The stroke width of the active wavy path.
  final double strokeWidth;

  /// The stroke width of the inactive circular track.
  final double trackStrokeWidth;

  /// The radial amplitude of the wave (distance from the base radius).
  final double amplitude;

  /// The number of full wave periods around a complete 360-degree circle.
  final double frequency;

  /// The speed of the wave propagation.
  final double waveSpeed;

  /// The diameter of the circular indicator.
  final double size;

  /// Semantic label for accessibility.
  final String? semanticsLabel;

  /// Semantic value for accessibility.
  final String? semanticsValue;

  @override
  State<WavyCircularProgressIndicator> createState() =>
      _WavyCircularProgressIndicatorState();
}

class _WavyCircularProgressIndicatorState
    extends State<WavyCircularProgressIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = widget.color ?? theme.colorScheme.primary;
    final inactiveColor = widget.backgroundColor ??
        theme.colorScheme.surfaceContainerHighest;

    final isIndeterminate = widget.value == null;

    return Semantics(
      label: widget.semanticsLabel ?? 'Circular progress',
      value: widget.semanticsValue ?? (isIndeterminate ? 'Indeterminate' : '${(widget.value! * 100).toInt()}%'),
      child: Center(
        child: SizedBox(
          width: widget.size,
          height: widget.size,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: _WavyCircularProgressPainter(
                  progress: widget.value,
                  animationValue: _controller.value,
                  color: activeColor,
                  backgroundColor: inactiveColor,
                  strokeWidth: widget.strokeWidth,
                  trackStrokeWidth: widget.trackStrokeWidth,
                  amplitude: widget.amplitude,
                  frequency: widget.frequency,
                  waveSpeed: widget.waveSpeed,
                  isIndeterminate: isIndeterminate,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _WavyCircularProgressPainter extends CustomPainter {
  _WavyCircularProgressPainter({
    required this.progress,
    required this.animationValue,
    required this.color,
    required this.backgroundColor,
    required this.strokeWidth,
    required this.trackStrokeWidth,
    required this.amplitude,
    required this.frequency,
    required this.waveSpeed,
    required this.isIndeterminate,
  });

  final double? progress;
  final double animationValue;
  final Color color;
  final Color backgroundColor;
  final double strokeWidth;
  final double trackStrokeWidth;
  final double amplitude;
  final double frequency;
  final double waveSpeed;
  final bool isIndeterminate;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    // Base radius must be slightly smaller than half-size to accommodate amplitude and stroke width
    final double maxPadding = amplitude + (math.max(strokeWidth, trackStrokeWidth) / 2);
    final double baseRadius = (size.width / 2) - maxPadding;

    if (baseRadius <= 0) return;

    // 1. Draw flat circular background track
    final Paint trackPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = trackStrokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, baseRadius, trackPaint);

    // 2. Prepare paint for active track
    final Paint activePaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final double phase = animationValue * waveSpeed * 2 * math.pi;

    if (!isIndeterminate) {
      // DETERMINATE MODE
      final double progressVal = (progress ?? 0.0).clamp(0.0, 1.0);
      if (progressVal == 0.0) return;

      final double startAngle = -math.pi / 2; // 12 o'clock
      final double sweepAngle = progressVal * 2 * math.pi;

      final Path wavyArc = _buildWavyArcPath(
        center: center,
        baseRadius: baseRadius,
        startAngle: startAngle,
        endAngle: startAngle + sweepAngle,
        phase: phase,
      );

      canvas.drawPath(wavyArc, activePaint);
    } else {
      // INDETERMINATE MODE
      // Circular spin combined with head-and-tail sweeping.
      final double spinAngle = animationValue * 2 * math.pi;

      // Map [0.0, 1.0] animation value into head/tail fractions
      final double headVal = Curves.easeInOut.transform(
        (animationValue * 2.0).clamp(0.0, 1.0),
      );
      final double tailVal = Curves.easeInOut.transform(
        ((animationValue - 0.5) * 2.0).clamp(0.0, 1.0),
      );

      // Map fractions to angles
      final double startAngle = -math.pi / 2 + (tailVal * 2 * math.pi) + spinAngle;
      final double endAngle = -math.pi / 2 + (headVal * 2 * math.pi) + spinAngle;

      final Path wavyArc = _buildWavyArcPath(
        center: center,
        baseRadius: baseRadius,
        startAngle: startAngle,
        endAngle: endAngle,
        phase: phase,
      );

      canvas.drawPath(wavyArc, activePaint);
    }
  }

  Path _buildWavyArcPath({
    required Offset center,
    required double baseRadius,
    required double startAngle,
    required double endAngle,
    required double phase,
  }) {
    final Path path = Path();
    if (endAngle <= startAngle) return path;

    // Angle step size. Small step size provides higher fidelity curves.
    final double step = math.pi / 90; // 2 degrees per step

    // First point
    final double firstR = _calculateRadius(startAngle, startAngle, endAngle, baseRadius, phase);
    path.moveTo(
      center.dx + firstR * math.cos(startAngle),
      center.dy + firstR * math.sin(startAngle),
    );

    for (double theta = startAngle + step; theta <= endAngle; theta += step) {
      final double r = _calculateRadius(theta, startAngle, endAngle, baseRadius, phase);
      path.lineTo(
        center.dx + r * math.cos(theta),
        center.dy + r * math.sin(theta),
      );
    }

    // Ensure path goes exactly to the final endpoint
    final double finalR = _calculateRadius(endAngle, startAngle, endAngle, baseRadius, phase);
    path.lineTo(
      center.dx + finalR * math.cos(endAngle),
      center.dy + finalR * math.sin(endAngle),
    );

    return path;
  }

  /// Calculates the radius at a specific angle [theta].
  /// Incorporates an edge envelope (fade) so that the wavy arc transitions
  /// smoothly back to the base circle radius at its start and end caps.
  double _calculateRadius(
    double theta,
    double startAngle,
    double endAngle,
    double baseRadius,
    double phase,
  ) {
    final double totalArc = endAngle - startAngle;
    if (totalArc <= 0) return baseRadius;

    // Fade zone is set to ~45 degrees or 1/3 of the total arc (whichever is smaller)
    final double fadeZone = math.min(math.pi / 4, totalArc / 3.0);

    double scale = 1.0;
    final double distToStart = theta - startAngle;
    final double distToEnd = endAngle - theta;

    if (distToStart < fadeZone) {
      scale = distToStart / fadeZone;
    } else if (distToEnd < fadeZone) {
      scale = distToEnd / fadeZone;
    }

    // Polar coordinate wave function: r = baseRadius + amplitude * scale * sin(frequency * theta - phase)
    final double sinVal = math.sin((frequency * theta) - phase);
    return baseRadius + (amplitude * scale * sinVal);
  }

  @override
  bool shouldRepaint(covariant _WavyCircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.animationValue != animationValue ||
        oldDelegate.color != color ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.trackStrokeWidth != trackStrokeWidth ||
        oldDelegate.amplitude != amplitude ||
        oldDelegate.frequency != frequency ||
        oldDelegate.waveSpeed != waveSpeed ||
        oldDelegate.isIndeterminate != isIndeterminate;
  }
}
