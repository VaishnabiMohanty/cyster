import 'package:floor/floor.dart';

enum MoodTag { anxious, low, okay, good, irritable, foggy }

@entity
class JournalEntry {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final DateTime date;
  final String content;
  final String moodTags; // Comma-separated enum names
  final String prompt;

  JournalEntry({
    this.id,
    required this.date,
    required this.content,
    required this.moodTags,
    required this.prompt,
  });

  List<MoodTag> get moods {
    if (moodTags.isEmpty) return [];
    return moodTags.split(',').map((e) => MoodTag.values.firstWhere((m) => m.name == e)).toList();
  }
}

@dao
abstract class JournalDao {
  @Query('SELECT * FROM JournalEntry ORDER BY date DESC')
  Future<List<JournalEntry>> findAllEntries();

  @Query('SELECT * FROM JournalEntry WHERE date = :date LIMIT 1')
  Future<JournalEntry?> findEntryByDate(DateTime date);

  @Query('SELECT * FROM JournalEntry WHERE date BETWEEN :start AND :end ORDER BY date ASC')
  Future<List<JournalEntry>> findEntriesInRange(DateTime start, DateTime end);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> upsertEntry(JournalEntry entry);

  @delete
  Future<void> deleteEntry(JournalEntry entry);
}
