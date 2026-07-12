import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material3_indicators/material3_indicators.dart';

void main() {
  group('M3Shapes Tests', () {
    test('Default cycle contains shapes', () {
      final shapes = M3Shapes.defaultCycle;
      expect(shapes, isNotEmpty);
      expect(shapes.length, equals(5));
    });

    test('Helper shapes return valid ShapeBorder objects', () {
      expect(M3Shapes.pentagon(), isA<ShapeBorder>());
      expect(M3Shapes.sunny(), isA<ShapeBorder>());
      expect(M3Shapes.softBurst(), isA<ShapeBorder>());
      expect(M3Shapes.cookie(), isA<ShapeBorder>());
      expect(M3Shapes.pill(), isA<ShapeBorder>());
    });
  });

  group('M3LoadingIndicator Widget Tests', () {
    testWidgets('Renders correctly with default parameters', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: M3LoadingIndicator(),
          ),
        ),
      );

      // Verify widget exists
      expect(find.byType(M3LoadingIndicator), findsOneWidget);
      // Verify semantics label
      expect(find.bySemanticsLabel('Loading'), findsOneWidget);
    });

    testWidgets('Renders in contained mode with correct sizing', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: M3LoadingIndicator(
              contained: true,
              containerSize: 100.0,
              size: 50.0,
            ),
          ),
        ),
      );

      expect(find.byType(M3LoadingIndicator), findsOneWidget);
    });
  });

  group('WavyLinearProgressIndicator Widget Tests', () {
    testWidgets('Renders determinate progress', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WavyLinearProgressIndicator(value: 0.5),
          ),
        ),
      );

      expect(find.byType(WavyLinearProgressIndicator), findsOneWidget);
      expect(find.bySemanticsLabel('Linear progress'), findsOneWidget);
    });

    testWidgets('Renders indeterminate progress', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WavyLinearProgressIndicator(value: null),
          ),
        ),
      );

      expect(find.byType(WavyLinearProgressIndicator), findsOneWidget);
    });
  });

  group('WavyCircularProgressIndicator Widget Tests', () {
    testWidgets('Renders determinate progress', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WavyCircularProgressIndicator(value: 0.7),
          ),
        ),
      );

      expect(find.byType(WavyCircularProgressIndicator), findsOneWidget);
      expect(find.bySemanticsLabel('Circular progress'), findsOneWidget);
    });

    testWidgets('Renders indeterminate progress', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WavyCircularProgressIndicator(value: null),
          ),
        ),
      );

      expect(find.byType(WavyCircularProgressIndicator), findsOneWidget);
    });
  });
}
