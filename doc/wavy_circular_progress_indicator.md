# WavyCircularProgressIndicator Detailed Guide

`WavyCircularProgressIndicator` maps sinusoidal wave oscillations onto a circular path using polar coordinates. It supports both fixed progress tracking and continuous indeterminate cycling with active arc expansion/contraction.

---

## API Properties

| Property | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `value` | `double?` | `null` | The progress value from `0.0` to `1.0`. If `null`, it cycles continuously in an **indeterminate** state. |
| `size` | `double` | `48.0` | Outer bounding box dimension (width and height) of the progress indicator. |
| `color` | `Color?` | `ColorScheme.primary` | The color of the active progress wave ring. |
| `backgroundColor` | `Color?` | `ColorScheme.surfaceContainerHighest` | The color of the static background track circle. |
| `strokeWidth` | `double` | `4.0` | Thickness of the active progress wave arc. |
| `trackStrokeWidth` | `double` | `4.0` | Thickness of the underlying circular track. |
| `amplitude` | `double` | `3.0` | The depth of the wave oscillations relative to the radius. |
| `frequency` | `double` | `8.0` | The number of full wave periods (crests) inside a $360^\circ$ circle. |
| `waveSpeed` | `double` | `5.0` | Animation speed factor (controls the rotation/frequency of the waves). |
| `semanticsLabel` | `String?` | `'Circular progress'` | Accessibility description for screen readers. |

---

## Detailed Examples

### 1. Determinate Wave Ring
Displays circular progress up to a certain completion value.
```dart
import 'package:flutter/material.dart';
import 'package:material3_indicators/material3_indicators.dart';

Widget buildDeterminateRing() {
  return const WavyCircularProgressIndicator(
    value: 0.75, // 75% progress
    size: 64.0,
    amplitude: 4.0,
  );
}
```

### 2. Indeterminate Spin Ring
Continuously rotates and morphs without displaying a static value, useful for unbounded load operations.
```dart
Widget buildIndeterminateRing(BuildContext context) {
  return WavyCircularProgressIndicator(
    value: null, // Triggers looping morphing arc
    size: 56.0,
    color: Theme.of(context).colorScheme.primary,
    waveSpeed: 6.0,
  );
}
```

### 3. High Frequency Custom Styling
Create highly stylized spinner wheels (e.g. gear-like crest counts, customized backgrounds).
```dart
Widget buildCustomWavyCircular() {
  return const WavyCircularProgressIndicator(
    value: 0.5,
    size: 80.0,
    strokeWidth: 5.0,
    trackStrokeWidth: 1.5,
    amplitude: 5.0,
    frequency: 12.0, // 12 wave cycles in 360 degrees
    waveSpeed: 4.0,
  );
}
```
