import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'shapes.dart';

/// A Material 3 Loading Indicator.
///
/// It features a shape-morphing indeterminate loading animation,
/// transitioning smoothly between a series of rounded polygon shapes.
/// It can be displayed as either uncontained (standalone shape) or
/// contained (inside a background card).
class M3LoadingIndicator extends StatefulWidget {
  /// Creates a Material 3 Loading Indicator.
  const M3LoadingIndicator({
    super.key,
    this.shapes,
    this.size = 36.0,
    this.color,
    this.contained = false,
    this.containerColor,
    this.containerSize = 48.0,
    this.morphDuration = const Duration(milliseconds: 800),
    this.rotationDuration = const Duration(milliseconds: 2400),
    this.semanticsLabel,
  });

  /// The list of shapes to cycle through.
  /// If null, [M3Shapes.defaultCycle] will be used.
  final List<ShapeBorder>? shapes;

  /// The size of the active morphing indicator shape.
  final double size;

  /// The color of the indicator shape.
  /// Defaults to [ColorScheme.primary].
  final Color? color;

  /// Whether this indicator is contained within a background container.
  final bool contained;

  /// The background color of the container when [contained] is true.
  /// Defaults to [ColorScheme.primaryContainer].
  final Color? containerColor;

  /// The size of the outer container when [contained] is true.
  final double containerSize;

  /// The duration of a single morph transition between two shapes.
  final Duration morphDuration;

  /// The duration for a full 360-degree rotation.
  final Duration rotationDuration;

  /// Semantic label for accessibility.
  final String? semanticsLabel;

  @override
  State<M3LoadingIndicator> createState() =>
      _M3LoadingIndicatorState();
}

class _M3LoadingIndicatorState extends State<M3LoadingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _morphController;
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    // Morph controller runs continuously, cycling through shape indices.
    _morphController = AnimationController(
      vsync: this,
      duration: widget.morphDuration * _getShapeList().length,
    )..repeat();

    // Rotation controller provides continuous spin.
    _rotationController = AnimationController(
      vsync: this,
      duration: widget.rotationDuration,
    )..repeat();
  }

  @override
  void didUpdateWidget(covariant M3LoadingIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update morph duration if changed
    final shapesCount = _getShapeList().length;
    _morphController.duration = widget.morphDuration * shapesCount;
    if (!_morphController.isAnimating) {
      _morphController.repeat();
    }
    // Update rotation duration if changed
    _rotationController.duration = widget.rotationDuration;
    if (!_rotationController.isAnimating) {
      _rotationController.repeat();
    }
  }

  @override
  void dispose() {
    _morphController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  List<ShapeBorder> _getShapeList() {
    return widget.shapes ?? M3Shapes.defaultCycle;
  }

  /// Calculates the current interpolated shape based on [animationValue].
  ShapeBorder _getCurrentShape(double animationValue, List<ShapeBorder> shapes) {
    if (shapes.isEmpty) {
      return const CircleBorder();
    }
    if (shapes.length == 1) {
      return shapes.first;
    }

    final double totalProgress = animationValue * shapes.length;
    final int currentIndex = totalProgress.floor() % shapes.length;
    final int nextIndex = (currentIndex + 1) % shapes.length;
    final double localProgress = totalProgress - totalProgress.floor();

    // Use a smooth easeInOut curve for the local morph transition.
    final double curvedProgress = Curves.easeInOut.transform(localProgress);

    final ShapeBorder? lerped = ShapeBorder.lerp(
      shapes[currentIndex],
      shapes[nextIndex],
      curvedProgress,
    );

    return lerped ?? shapes[currentIndex];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final indicatorColor = widget.color ?? theme.colorScheme.primary;
    final shapes = _getShapeList();

    Widget indicator = AnimatedBuilder(
      animation: Listenable.merge([_morphController, _rotationController]),
      builder: (context, child) {
        final currentShape = _getCurrentShape(_morphController.value, shapes);
        final rotationAngle = _rotationController.value * 2 * math.pi;

        return Transform.rotate(
          angle: rotationAngle,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: ShapeDecoration(
              shape: currentShape,
              color: indicatorColor,
            ),
          ),
        );
      },
    );

    if (widget.contained) {
      final bgColor = widget.containerColor ?? theme.colorScheme.primaryContainer;
      indicator = Container(
        width: widget.containerSize,
        height: widget.containerSize,
        alignment: Alignment.center,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          color: bgColor,
        ),
        child: indicator,
      );
    }

    return Semantics(
      label: widget.semanticsLabel ?? 'Loading',
      value: 'Indeterminate',
      child: Center(
        child: indicator,
      ),
    );
  }
}
