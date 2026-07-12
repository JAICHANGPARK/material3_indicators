import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A Material 3 Wavy Linear Progress Indicator.
///
/// It displays progress along a linear track, where the active track
/// curves in a sinusoidal wave pattern. It supports both determinate
/// (specific progress value) and indeterminate (ongoing task) states.
class WavyLinearProgressIndicator extends StatefulWidget {
  /// Creates a Material 3 Wavy Linear Progress Indicator.
  const WavyLinearProgressIndicator({
    super.key,
    this.value,
    this.color,
    this.backgroundColor,
    this.strokeWidth = 4.0,
    this.trackStrokeWidth = 2.0,
    this.amplitude = 4.0,
    this.wavelength = 20.0,
    this.waveSpeed = 4.0,
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

  /// The stroke width of the inactive flat track.
  final double trackStrokeWidth;

  /// The peak height of the sinusoidal wave.
  final double amplitude;

  /// The horizontal length of a full wave cycle.
  final double wavelength;

  /// The speed at which the wave phase propagates horizontally.
  final double waveSpeed;

  /// Semantic label for accessibility.
  final String? semanticsLabel;

  /// Semantic value for accessibility.
  final String? semanticsValue;

  @override
  State<WavyLinearProgressIndicator> createState() =>
      _WavyLinearProgressIndicatorState();
}

class _WavyLinearProgressIndicatorState
    extends State<WavyLinearProgressIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Continuous animation driving the wave phase and indeterminate positions.
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
      label: widget.semanticsLabel ?? 'Linear progress',
      value: widget.semanticsValue ?? (isIndeterminate ? 'Indeterminate' : '${(widget.value! * 100).toInt()}%'),
      child: Center(
        child: Container(
          constraints: BoxConstraints(
            minWidth: 80.0,
            // Height must accommodate the total height of the wave (amplitude * 2) plus stroke width
            minHeight: (widget.amplitude * 2) + widget.strokeWidth + 4.0,
          ),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: _WavyLinearProgressPainter(
                  progress: widget.value,
                  animationValue: _controller.value,
                  color: activeColor,
                  backgroundColor: inactiveColor,
                  strokeWidth: widget.strokeWidth,
                  trackStrokeWidth: widget.trackStrokeWidth,
                  amplitude: widget.amplitude,
                  wavelength: widget.wavelength,
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

class _WavyLinearProgressPainter extends CustomPainter {
  _WavyLinearProgressPainter({
    required this.progress,
    required this.animationValue,
    required this.color,
    required this.backgroundColor,
    required this.strokeWidth,
    required this.trackStrokeWidth,
    required this.amplitude,
    required this.wavelength,
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
  final double wavelength;
  final double waveSpeed;
  final bool isIndeterminate;

  @override
  void paint(Canvas canvas, Size size) {
    final centerY = size.height / 2;
    final width = size.width;

    // 1. Draw flat inactive background track
    final Paint trackPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = trackStrokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(0, centerY),
      Offset(width, centerY),
      trackPaint,
    );

    // 2. Prepare paint for the active wavy track
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

      final double endX = width * progressVal;
      final Path wavePath = _buildWavyPath(
        startX: 0.0,
        endX: endX,
        centerY: centerY,
        phase: phase,
      );
      canvas.drawPath(wavePath, activePaint);
    } else {
      // INDETERMINATE MODE
      // In indeterminate mode, we sweep an active segment along the track.
      // We define a window [startX, endX] using curves to match M3 motion.
      final double sweepProgress = animationValue;
      
      // M3 indeterminate typical sweeps:
      // A segment starting at 0, expanding, then shrinking to the right.
      final double startCurve = Curves.easeInOutSine.transform(
        (sweepProgress * 1.5 - 0.5).clamp(0.0, 1.0),
      );
      final double endCurve = Curves.easeInOutSine.transform(
        (sweepProgress * 1.5).clamp(0.0, 1.0),
      );

      final double startX = startCurve * width;
      final double endX = endCurve * width;

      if (endX > startX) {
        final Path wavePath = _buildWavyPath(
          startX: startX,
          endX: endX,
          centerY: centerY,
          phase: phase,
        );
        canvas.drawPath(wavePath, activePaint);
      }
    }
  }

  Path _buildWavyPath({
    required double startX,
    required double endX,
    required double centerY,
    required double phase,
  }) {
    final Path path = Path();
    if (endX <= startX) return path;

    // Calculate step size. High density ensures smooth curves.
    const double step = 1.0;
    
    // First point
    final double firstY = _calculateWaveY(startX, startX, endX, centerY, phase);
    path.moveTo(startX, firstY);

    for (double x = startX + step; x <= endX; x += step) {
      final double y = _calculateWaveY(x, startX, endX, centerY, phase);
      path.lineTo(x, y);
    }
    
    // Ensure it goes exactly to the end point
    final double lastY = _calculateWaveY(endX, startX, endX, centerY, phase);
    path.lineTo(endX, lastY);

    return path;
  }

  /// Calculates the Y coordinate at [x] with an envelope/fade applied at the edges
  /// so that the wave transitions smoothly to/from the flat track center line.
  double _calculateWaveY(
    double x,
    double startX,
    double endX,
    double centerY,
    double phase,
  ) {
    final double segmentLength = endX - startX;
    if (segmentLength <= 0) return centerY;

    // Envelope zone is set to half the wavelength (or shorter if the segment itself is short)
    final double fadeZone = math.min(wavelength / 2.0, segmentLength / 2.0);

    double scale = 1.0;
    final double distToStart = x - startX;
    final double distToEnd = endX - x;

    if (distToStart < fadeZone) {
      scale = distToStart / fadeZone;
    } else if (distToEnd < fadeZone) {
      scale = distToEnd / fadeZone;
    }

    // Sinusoidal wave function: y = centerY + amplitude * scale * sin(2 * pi * x / wavelength - phase)
    final double sinVal = math.sin((2 * math.pi * x / wavelength) - phase);
    return centerY + (amplitude * scale * sinVal);
  }

  @override
  bool shouldRepaint(covariant _WavyLinearProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.animationValue != animationValue ||
        oldDelegate.color != color ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.trackStrokeWidth != trackStrokeWidth ||
        oldDelegate.amplitude != amplitude ||
        oldDelegate.wavelength != wavelength ||
        oldDelegate.waveSpeed != waveSpeed ||
        oldDelegate.isIndeterminate != isIndeterminate;
  }
}
