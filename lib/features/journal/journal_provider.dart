import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/database/database_provider.dart';
import 'journal_entry.dart';
import 'journal_prompt_service.dart';

part 'journal_provider.g.dart';

@riverpod
class JournalList extends _$JournalList {
  @override
  Future<List<JournalEntry>> build() async {
    final db = ref.watch(databaseProvider);
    return db.journalDao.findAllEntries();
  }

  Future<void> saveEntry(JournalEntry entry) async {
    final db = ref.read(databaseProvider);
    await db.journalDao.upsertEntry(entry);
    ref.invalidateSelf();
    ref.invalidate(journalEntryByDateProvider);
  }
}

@riverpod
Future<JournalEntry?> journalEntryByDate(JournalEntryByDateRef ref, DateTime date) async {
  final db = ref.watch(databaseProvider);
  // Floor requires date comparison. Since we store DateTime as int, we need to be careful with time.
  // We'll normalize to midnight for daily entries.
  final normalizedDate = DateTime(date.year, date.month, date.day);
  return db.journalDao.findEntryByDate(normalizedDate);
}

@riverpod
class CurrentPrompt extends _$CurrentPrompt {
  @override
  String build() {
    return JournalPromptService().getRandomPrompt();
  }

  void shuffle() {
    state = JournalPromptService().getRandomPrompt(lastPrompt: state);
  }

  void setPrompt(String prompt) {
    state = prompt;
  }
}
