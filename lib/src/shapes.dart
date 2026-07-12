import 'package:flutter/material.dart';

/// Predefined shape generators aligned with the Material 3 Expressive spec.
/// These shapes leverage [StarBorder] which provides native interpolation (morphing)
/// via `ShapeBorder.lerp`.
class ExpressiveShapes {
  /// A standard M3 Pentagon shape with slightly rounded corners.
  static ShapeBorder pentagon({double rounding = 0.3}) {
    return StarBorder.polygon(
      sides: 5,
      pointRounding: rounding,
    );
  }

  /// A 8-point "Sunny" shape (star-like with round valleys and points).
  static ShapeBorder sunny({
    double innerRadiusRatio = 0.7,
    double pointRounding = 0.25,
    double valleyRounding = 0.25,
  }) {
    return StarBorder(
      points: 8,
      innerRadiusRatio: innerRadiusRatio,
      pointRounding: pointRounding,
      valleyRounding: valleyRounding,
    );
  }

  /// A 10-point "Soft Burst" shape with smooth rounded points and valleys.
  static ShapeBorder softBurst({
    double innerRadiusRatio = 0.8,
    double pointRounding = 0.4,
    double valleyRounding = 0.4,
  }) {
    return StarBorder(
      points: 10,
      innerRadiusRatio: innerRadiusRatio,
      pointRounding: pointRounding,
      valleyRounding: valleyRounding,
    );
  }

  /// A 12-point "Cookie" shape resembling a flower or gear with very soft edges.
  static ShapeBorder cookie({
    double innerRadiusRatio = 0.85,
    double pointRounding = 0.5,
    double valleyRounding = 0.5,
  }) {
    return StarBorder(
      points: 12,
      innerRadiusRatio: innerRadiusRatio,
      pointRounding: pointRounding,
      valleyRounding: valleyRounding,
    );
  }

  /// A rounded rectangular shape resembling a "Pill" or "Oval".
  /// Note: To morph smoothly with StarBorder-based shapes, we can approximate
  /// an oval using a 4-sided polygon with high point rounding, or a 2-point StarBorder.
  /// A 4-sided polygon with pointRounding=0.9 behaves exactly like a pill/oval.
  static ShapeBorder pill({double rounding = 0.9}) {
    return StarBorder.polygon(
      sides: 4,
      pointRounding: rounding,
    );
  }

  /// An 8-point flower-like shape.
  static ShapeBorder flower({
    double innerRadiusRatio = 0.75,
    double pointRounding = 0.45,
    double valleyRounding = 0.45,
  }) {
    return StarBorder(
      points: 8,
      innerRadiusRatio: innerRadiusRatio,
      pointRounding: pointRounding,
      valleyRounding: valleyRounding,
    );
  }

  /// A list of the default 5 shapes in the cycle of the M3 Expressive loading indicator.
  static List<ShapeBorder> get defaultCycle => [
        pentagon(),
        sunny(),
        softBurst(),
        cookie(),
        pill(),
      ];
}
