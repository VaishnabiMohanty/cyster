import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cyster/features/symptoms/symptom_chart.dart';
import 'package:cyster/features/symptoms/symptom_log.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  testWidgets('SymptomTimelineChart renders with data', (WidgetTester tester) async {
    final logs = [
      SymptomLog(date: DateTime(2023, 1, 1), acne: 1, bloating: 2, fatigue: 3),
      SymptomLog(date: DateTime(2023, 1, 5), acne: 3, bloating: 1, fatigue: 5),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SymptomTimelineChart(logs: logs),
        ),
      ),
    );

    expect(find.byType(LineChart), findsOneWidget);
    expect(find.text('Acne'), findsOneWidget);
    expect(find.text('Symptom Intensity Over Time'), findsOneWidget);
  });
}
