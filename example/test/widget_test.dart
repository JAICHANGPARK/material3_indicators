import 'package:flutter_test/flutter_test.dart';
import 'package:example_app/main.dart';
import 'package:material3_indicators/material3_indicators.dart';

void main() {
  testWidgets('Dashboard app smokes test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ExampleApp());
    await tester.pump(); // trigger initial frame

    // Verify that the dashboard screen and tabs are rendered
    expect(find.text('M3 Expressive Indicators'), findsOneWidget);
    expect(find.byType(ExpressiveLoadingIndicator), findsOneWidget);

    // Tap on the Wavy Linear tab (it is in the TabBar)
    await tester.tap(find.text('Wavy Linear'));
    await tester.pump(); // dispatch tap event
    await tester.pump(const Duration(milliseconds: 500)); // allow TabBar transition animation

    // Verify WavyLinearProgressIndicator is now displayed
    expect(find.byType(WavyLinearProgressIndicator), findsOneWidget);

    // Tap on the Wavy Circular tab
    await tester.tap(find.text('Wavy Circular'));
    await tester.pump(); // dispatch tap event
    await tester.pump(const Duration(milliseconds: 500)); // allow TabBar transition animation

    // Verify WavyCircularProgressIndicator is now displayed
    expect(find.byType(WavyCircularProgressIndicator), findsOneWidget);
  });
}
