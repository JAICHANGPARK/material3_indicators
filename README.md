# material3_indicators

A Flutter package implementing the latest **Material 3 Expressive** loading and progress indicators. Currently, these expressive animations (wavy progress tracks and shape-morphing loaders) are absent from the core Flutter SDK. This package provides high-fidelity, high-performance implementations of those specs.

## Features

| Component | Style | Key Characteristics |
| :--- | :--- | :--- |
| **`ExpressiveLoadingIndicator`** | Shape-Morphing Spinner | Continuous spring-driven morphing between rounded polygons (Pentagon, Sunny, Soft Burst, Cookie, Pill). Outlined/Filled, Contained/Uncontained. |
| **`WavyLinearProgressIndicator`** | Sinusoidal Progress Bar | Sinusoidal active bar. Edge envelopes apply smooth transitions so wave ends join flat tracks seamlessly. |
| **`WavyCircularProgressIndicator`** | Polar Wave Progress Ring | Polar coordinate waves revolving and morphing dynamically. Features adaptive boundary dampening. |

---

## Getting started

Add `material3_indicators` to your `pubspec.yaml`:

```yaml
dependencies:
  material3_indicators:
    path: path/to/local/material3_indicators # Or standard pub version once published
```

Import the package in your Dart code:

```dart
import 'package:material3_indicators/material3_indicators.dart';
```

---

## Usage

### 1. Expressive Loading Indicator (Shape Morphing)

```dart
// Basic Uncontained Loader
const ExpressiveLoadingIndicator(
  size: 36.0,
);

// Contained Loader (inside a card background)
const ExpressiveLoadingIndicator(
  contained: true,
  size: 40.0,
  containerSize: 72.0,
  morphDuration: Duration(milliseconds: 800),
);

// Customizing Shapes list
ExpressiveLoadingIndicator(
  shapes: [
    ExpressiveShapes.pentagon(),
    ExpressiveShapes.cookie(),
  ],
);
```

### 2. Wavy Linear Progress Indicator

```dart
// Determinate state
WavyLinearProgressIndicator(
  value: 0.6,
  amplitude: 4.0,
  wavelength: 24.0,
  waveSpeed: 5.0,
  strokeWidth: 4.0,
);

// Indeterminate state
const WavyLinearProgressIndicator(
  value: null, // Triggers looping M3 sweep motion
);
```

### 3. Wavy Circular Progress Indicator

```dart
// Determinate state
WavyCircularProgressIndicator(
  value: 0.75,
  size: 64.0,
  amplitude: 3.0,
  frequency: 8.0, // 8 wave cycles in 360 degrees
);

// Indeterminate state
const WavyCircularProgressIndicator(
  value: null,
);
```

---

## Additional information

### Custom Shapes
You can design custom polygon sequences using the [StarBorder] helpers provided by `ExpressiveShapes`, or feed any list of custom `ShapeBorder` geometries directly into `ExpressiveLoadingIndicator(shapes: [...])`. 

### Boundary Dampening (Edge Envelope)
To prevent waves from making sharp jumps at progress boundaries, both wavy indicators employ a mathematical envelope. This automatically flattens the wave amplitude near the ends of the active track to blend smoothly with standard flat rounded tracks.
