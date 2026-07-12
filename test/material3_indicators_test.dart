import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material3_indicators/material3_indicators.dart';

void main() {
  group('ExpressiveShapes Tests', () {
    test('Default cycle contains shapes', () {
      final shapes = ExpressiveShapes.defaultCycle;
      expect(shapes, isNotEmpty);
      expect(shapes.length, equals(5));
    });

    test('Helper shapes return valid ShapeBorder objects', () {
      expect(ExpressiveShapes.pentagon(), isA<ShapeBorder>());
      expect(ExpressiveShapes.sunny(), isA<ShapeBorder>());
      expect(ExpressiveShapes.softBurst(), isA<ShapeBorder>());
      expect(ExpressiveShapes.cookie(), isA<ShapeBorder>());
      expect(ExpressiveShapes.pill(), isA<ShapeBorder>());
    });
  });

  group('ExpressiveLoadingIndicator Widget Tests', () {
    testWidgets('Renders correctly with default parameters', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ExpressiveLoadingIndicator(),
          ),
        ),
      );

      // Verify widget exists
      expect(find.byType(ExpressiveLoadingIndicator), findsOneWidget);
      // Verify semantics label
      expect(find.bySemanticsLabel('Loading'), findsOneWidget);
    });

    testWidgets('Renders in contained mode with correct sizing', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ExpressiveLoadingIndicator(
              contained: true,
              containerSize: 100.0,
              size: 50.0,
            ),
          ),
        ),
      );

      expect(find.byType(ExpressiveLoadingIndicator), findsOneWidget);
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
