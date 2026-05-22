// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ikawa_mobile_app/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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

    await tester.tap(find.byTooltip('More actions'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Load Machine Info'));
    await tester.pumpAndSettle(const Duration(milliseconds: 500));

    await tester.tap(find.byTooltip('More actions'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Refresh Live Status'));
    await tester.pumpAndSettle(const Duration(milliseconds: 500));

    expect(find.textContaining('Unsupported operation'), findsNothing);
  });

  testWidgets('profile detail supports advanced chart and profile activation', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          transportProvider.overrideWithValue(SimulatedRoasterTransport()),
        ],
        child: IkawaMobileApp(),
      ),
    );

    expect(find.text('Yirgacheffe Washed Light'), findsOneWidget);
    await tester.tap(find.text('Yirgacheffe Washed Light'));
    await tester.pumpAndSettle();

    expect(find.text('Use for roaster'), findsOneWidget);
    expect(find.text('Temperature'), findsOneWidget);
    await tester.tap(find.text('Advanced'));
    await tester.pumpAndSettle();

    expect(find.text('RoR'), findsOneWidget);
    await tester.tap(find.text('Use for roaster'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Active profile:'), findsOneWidget);
  });

  testWidgets('wide layout shows navigation rail', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          transportProvider.overrideWithValue(SimulatedRoasterTransport()),
        ],
        child: IkawaMobileApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(NavigationRail), findsOneWidget);
  });
}
