# Project Rules & Style Guidelines - material3_indicators

This file outlines instructions, constraints, and guidelines for AI coding agents and human developers maintaining the `material3_indicators` package.

---

## 1. Component Design Guidelines

### Shape Morphing Spinner (`ExpressiveLoadingIndicator`)
- **StarBorder Usage**: Always favor using Flutter's native `StarBorder` (or `StarBorder.polygon`) for creating morphing shapes. `StarBorder` implements built-in mathematical interpolation (morphing) inside `ShapeBorder.lerp`, ensuring highly optimized, dependency-free rendering.
- **Rotation Constraints**: Ensure the morphing shapes rotate continuously. The morphing animation (switching shape states) and the rotation animation should remain decoupled via distinct `AnimationController`s to allow flexible speed configuration.

### Wavy Progress Indicators (Linear / Circular)
- **Edge Envelope (Dampening)**: Any modifications to the custom painters (`_WavyLinearProgressPainter` or `_WavyCircularProgressPainter`) must maintain the mathematical edge dampening (envelope scale). The wave amplitude must smoothly taper down to `0.0` at the very start and end of the active segment, preventing sharp visual jumps.
- **Polar Coordinates for Circles**: Circular wave calculations must use Polar-to-Cartesian mappings:
  $$r = R_{base} + A \cdot \text{scale} \cdot \sin(f \cdot \theta - \phi)$$
  $$x = x_c + r \cdot \cos(\theta),\quad y = y_c + r \cdot \sin(\theta)$$
  Ensure the frequency ($f$) represents the number of wave peaks around a complete 360-degree cycle.

---

## 2. Code Quality & Integration Standards

- **Static Analysis**: All code changes must pass `flutter analyze` without any warnings, infos, or errors.
- **Unit & Widget Tests**:
  - Always write accompanying widget/unit tests when creating a new feature or modifying painter geometry.
  - Since progress indicators run infinite looping animations, do not use `tester.pumpAndSettle()` in widget tests, as it will timeout. Instead, use bounded pumps like `tester.pump(Duration(milliseconds: X))`.
- **Imports**: Ensure all code uses `import 'package:material3_indicators/...';` rather than relative package imports where applicable.
