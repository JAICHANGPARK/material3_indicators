# WavyLinearProgressIndicator Detailed Guide

`WavyLinearProgressIndicator` displays progress along a linear track, featuring a sinusoidal wavy animation. To maintain visual harmony, a mathematical scale envelope (boundary dampening) is applied at both ends of the active track so the waves flatten out cleanly where they join the flat ends.

---

## API Properties

| Property | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `value` | `double?` | `null` | The progress value from `0.0` to `1.0`. If `null`, it renders in an **indeterminate** (continuous) state. |
| `color` | `Color?` | `ColorScheme.primary` | The color of the active progress wave track. |
| `backgroundColor` | `Color?` | `ColorScheme.surfaceContainerHighest` | The color of the underlying flat background track. |
| `strokeWidth` | `double` | `4.0` | Thickness of the active wavy progress track. |
| `trackStrokeWidth` | `double` | `4.0` | Thickness of the static background track. |
| `amplitude` | `double` | `4.0` | The height of the waves (crest to trough). |
| `wavelength` | `double` | `20.0` | The horizontal distance between two consecutive wave peaks. |
| `waveSpeed` | `double` | `5.0` | Animation speed factor (controls motion frequency). |
| `semanticsLabel` | `String?` | `'Linear progress'` | Accessibility description for screen readers. |

---

## Detailed Examples

### 1. Determinate State (Fixed Progress)
Used to display task progression (e.g. downloads, file uploads).
```dart
import 'package:flutter/material.dart';
import 'package:material3_indicators/material3_indicators.dart';

Widget buildDeterminateProgress() {
  return const WavyLinearProgressIndicator(
    value: 0.65, // 65% complete
    strokeWidth: 5.0,
    amplitude: 5.0,
  );
}
```

### 2. Indeterminate State (Continuous Animation)
Used when the progress or time required is unknown.
```dart
Widget buildIndeterminateProgress(BuildContext context) {
  return WavyLinearProgressIndicator(
    value: null, // Triggers indeterminate wave motion
    color: Theme.of(context).colorScheme.tertiary,
    waveSpeed: 6.0, // Slightly faster movement
  );
}
```

### 3. Highly Custom Styled Wave
Adjust wave size, frequency, speed, and track stroke widths to fit a custom theme.
```dart
Widget buildCustomWavyProgress() {
  return const WavyLinearProgressIndicator(
    value: 0.4,
    strokeWidth: 6.0,      // Thick active wave
    trackStrokeWidth: 2.0, // Thin background track
    amplitude: 8.0,        // High wave peaks
    wavelength: 32.0,      // Stretched waves
    waveSpeed: 3.5,        // Relaxed, slow motion
  );
}
```
