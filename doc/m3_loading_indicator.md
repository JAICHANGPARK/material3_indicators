# M3LoadingIndicator Detailed Guide

`M3LoadingIndicator` is a high-fidelity loading spinner implementing the Material 3 shape-morphing motion specification. It transitions smoothly between multiple rounded polygons over a continuous rotation.

---

## API Properties

| Property | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `shapes` | `List<ShapeBorder>?` | `M3Shapes.defaultCycle` | The ordered list of shapes to cycle through. |
| `size` | `double` | `36.0` | The diameter of the active morphing indicator. |
| `color` | `Color?` | `ColorScheme.primary` | The color of the indicator shape. |
| `contained` | `bool` | `false` | If `true`, renders the indicator inside a rounded container card. |
| `containerColor` | `Color?` | `ColorScheme.primaryContainer` | Background color of the container card (only used when `contained` is `true`). |
| `containerSize` | `double` | `48.0` | Dimension (width and height) of the outer container card. |
| `morphDuration` | `Duration` | `800ms` | The transition time to morph from one shape to the next. |
| `rotationDuration` | `Duration` | `2400ms` | The time required for a full 360-degree rotation cycle. |
| `semanticsLabel` | `String?` | `'Loading'` | Accessibility description for screen readers. |

---

## Detailed Examples

### 1. Basic Uncontained Loader
Standard loading indicator that floats freely on the canvas.
```dart
import 'package:flutter/material.dart';
import 'package:material3_indicators/material3_indicators.dart';

Widget buildLoader() {
  return const M3LoadingIndicator(
    size: 40.0,
  );
}
```

### 2. Contained Loader
Enclosed in a structured container card, conforming to the Material 3 design system for card-based integrations.
```dart
Widget buildContainedLoader(BuildContext context) {
  return M3LoadingIndicator(
    contained: true,
    size: 32.0,
    containerSize: 56.0,
    containerColor: Theme.of(context).colorScheme.secondaryContainer,
    color: Theme.of(context).colorScheme.onSecondaryContainer,
  );
}
```

### 3. Custom Morphing Cycle
You can customize the cycle sequence (order, shapes) and transition timings.
```dart
Widget buildCustomMorphLoader() {
  return M3LoadingIndicator(
    shapes: [
      M3Shapes.pentagon(rounding: 0.1), // Shaper edges
      M3Shapes.flower(),
      M3Shapes.pill(rounding: 0.8),
    ],
    morphDuration: const Duration(milliseconds: 1200), // Slower morph
    rotationDuration: const Duration(seconds: 4),     // Slower spin
  );
}
```
