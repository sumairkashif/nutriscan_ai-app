import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutriscan_ai/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: NutriScanApp()));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsNothing);

    // This is just a smoke test, since we changed the app structure significantly
    // the default counter test is no longer valid.
    // We just verify the app launches.
    expect(find.byType(NutriScanApp), findsOneWidget);
  });
}
