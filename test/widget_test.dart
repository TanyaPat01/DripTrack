import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drip_irr/main.dart';

void main() {
  testWidgets('MyApp has a title', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that the app title is present.
    expect(find.text('DRIPTRACK'), findsOneWidget);
  });
}