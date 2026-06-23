import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cyster/features/cycle/cycle_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('CycleScreen shows prediction card', (WidgetTester tester) async {
    // We need a ProviderScope even if we don't mock the DB yet, 
    // but the actual build might fail if it tries to init the real DB.
    // For a simple UI test, we can override the providers.
    
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: CycleScreen(),
        ),
      ),
    );

    expect(find.text('Cycle Tracker'), findsOneWidget);
    expect(find.byType(Card), findsOneWidget); // Prediction card
  });

  testWidgets('AddCycleEntrySheet renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AddCycleEntrySheet(),
        ),
      ),
    );

    expect(find.text('Log Period'), findsOneWidget);
    expect(find.text('Start Date'), findsOneWidget);
    expect(find.text('Flow Level'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}
