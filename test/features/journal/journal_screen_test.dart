import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cyster/features/journal/journal_screen.dart';
import 'package:cyster/features/journal/journal_entry.dart';
import 'package:cyster/features/journal/journal_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  testWidgets('JournalScreen renders chips and prompt', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          journalEntryByDateProvider(today).overrideWith((ref) => Future.value(null)),
        ],
        child: const MaterialApp(
          home: JournalScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('How are you feeling?'), findsOneWidget);
    expect(find.byType(FilterChip), findsNWidgets(MoodTag.values.length));
    expect(find.text('Daily Prompt'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('Mood chip selection works', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          journalEntryByDateProvider(today).overrideWith((ref) => Future.value(null)),
        ],
        child: const MaterialApp(
          home: JournalScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final anxiousChip = find.widgetWithText(FilterChip, 'anxious');
    expect(anxiousChip, findsOneWidget);

    FilterChip chipWidget = tester.widget(anxiousChip);
    expect(chipWidget.selected, isFalse);

    await tester.tap(anxiousChip);
    await tester.pump();

    chipWidget = tester.widget(anxiousChip);
    expect(chipWidget.selected, isTrue);
  });
}
