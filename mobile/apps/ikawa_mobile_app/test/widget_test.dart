// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ikawa_mobile_app/main.dart';

void main() {
  testWidgets('renders profile catalog as first tab', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          transportProvider.overrideWithValue(SimulatedRoasterTransport()),
        ],
        child: IkawaMobileApp(),
      ),
    );

    expect(find.text('Roast profiles'), findsOneWidget);
    expect(find.text('Search by profile name'), findsOneWidget);
  });

  testWidgets('simulator actions complete without unsupported errors', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          transportProvider.overrideWithValue(SimulatedRoasterTransport()),
        ],
        child: IkawaMobileApp(),
      ),
    );

    await tester.tap(find.text('Roaster'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Scan for Devices'));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Connect'), findsOneWidget);
    await tester.tap(find.text('Connect'));
    await tester.pumpAndSettle(const Duration(milliseconds: 500));

    await tester.tap(find.text('Load Machine Info'));
    await tester.pumpAndSettle(const Duration(milliseconds: 500));

    await tester.tap(find.text('Refresh Live Status'));
    await tester.pumpAndSettle(const Duration(milliseconds: 500));

    expect(find.textContaining('Unsupported operation'), findsNothing);
  });
}
