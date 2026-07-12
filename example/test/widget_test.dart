import 'package:flutter_test/flutter_test.dart';
import 'package:example_app/main.dart';
import 'package:material3_indicators/material3_indicators.dart';

void main() {
  testWidgets('Dashboard app smokes test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ExampleApp());
    await tester.pump(); // trigger initial frame

    // Verify that the dashboard screen and tabs are rendered
    expect(find.text('M3 Indicators Showcase'), findsOneWidget);
    
    // In the Overview tab (Tab 0), both M3LoadingIndicator (x2),
    // WavyLinearProgressIndicator (x2), and WavyCircularProgressIndicator (x2) are rendered.
    expect(find.byType(M3LoadingIndicator), findsNWidgets(2));
    expect(find.byType(WavyLinearProgressIndicator), findsNWidgets(2));
    expect(find.byType(WavyCircularProgressIndicator), findsNWidgets(2));

    // Tap on the detailed "Loading" tab
    await tester.tap(find.text('Loading'));
    await tester.pump(); // dispatch tap event
    await tester.pump(const Duration(milliseconds: 500)); // allow TabBar transition animation

    // In the detailed Loading tab, only 1 M3LoadingIndicator is rendered
    expect(find.byType(M3LoadingIndicator), findsOneWidget);

    // Tap on the detailed "Wavy Linear" tab
    await tester.tap(find.text('Wavy Linear'));
    await tester.pump(); // dispatch tap event
    await tester.pump(const Duration(milliseconds: 500)); // allow TabBar transition animation

    // In the detailed Wavy Linear tab, only 1 WavyLinearProgressIndicator is rendered
    expect(find.byType(WavyLinearProgressIndicator), findsOneWidget);

    // Tap on the detailed "Wavy Circular" tab
    await tester.tap(find.text('Wavy Circular'));
    await tester.pump(); // dispatch tap event
    await tester.pump(const Duration(milliseconds: 500)); // allow TabBar transition animation

    // In the detailed Wavy Circular tab, only 1 WavyCircularProgressIndicator is rendered
    expect(find.byType(WavyCircularProgressIndicator), findsOneWidget);
  });
}
