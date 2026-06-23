import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cyster/features/symptoms/symptom_screen.dart';
import 'package:cyster/features/symptoms/symptom_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('SymptomScreen shows header and empty state', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: SymptomScreen(),
        ),
      ),
    );

    // Wait for the loading state to finish
    await tester.pump();

    expect(find.text('Symptoms & Health'), findsOneWidget);
    expect(find.text('No data to display yet'), findsOneWidget);
  });

  testWidgets('AddSymptomLogSheet shows input fields', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AddSymptomLogSheet(),
        ),
      ),
    );

    expect(find.text('Log Symptoms'), findsOneWidget);
    expect(find.text('Acne Intensity (0)'), findsOneWidget);
    expect(find.text('Weight (kg)'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}
