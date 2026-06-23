// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  CycleDao? _cycleDaoInstance;

  SymptomDao? _symptomDaoInstance;

  JournalDao? _journalDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `CycleEntry` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `date` INTEGER NOT NULL, `duration` INTEGER NOT NULL, `flow` TEXT NOT NULL, `color` TEXT NOT NULL, `clots` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `SymptomLog` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `date` INTEGER NOT NULL, `acne` INTEGER NOT NULL, `hairLoss` INTEGER NOT NULL, `bloating` INTEGER NOT NULL, `fatigue` INTEGER NOT NULL, `cravings` INTEGER NOT NULL, `weight` REAL, `sleepHours` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `JournalEntry` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `date` INTEGER NOT NULL, `content` TEXT NOT NULL, `moodTags` TEXT NOT NULL, `prompt` TEXT NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  CycleDao get cycleDao {
    return _cycleDaoInstance ??= _$CycleDao(database, changeListener);
  }

  @override
  SymptomDao get symptomDao {
    return _symptomDaoInstance ??= _$SymptomDao(database, changeListener);
  }

  @override
  JournalDao get journalDao {
    return _journalDaoInstance ??= _$JournalDao(database, changeListener);
  }
}

class _$CycleDao extends CycleDao {
  _$CycleDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _cycleEntryInsertionAdapter = InsertionAdapter(
            database,
            'CycleEntry',
            (CycleEntry item) => <String, Object?>{
                  'id': item.id,
                  'date': _dateTimeConverter.encode(item.date),
                  'duration': item.duration,
                  'flow': _flowLevelConverter.encode(item.flow),
                  'color': _cycleColorConverter.encode(item.color),
                  'clots': _clotPresenceConverter.encode(item.clots)
                }),
        _cycleEntryDeletionAdapter = DeletionAdapter(
            database,
            'CycleEntry',
            ['id'],
            (CycleEntry item) => <String, Object?>{
                  'id': item.id,
                  'date': _dateTimeConverter.encode(item.date),
                  'duration': item.duration,
                  'flow': _flowLevelConverter.encode(item.flow),
                  'color': _cycleColorConverter.encode(item.color),
                  'clots': _clotPresenceConverter.encode(item.clots)
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<CycleEntry> _cycleEntryInsertionAdapter;

  final DeletionAdapter<CycleEntry> _cycleEntryDeletionAdapter;

  @override
  Future<List<CycleEntry>> findAllCycles() async {
    return _queryAdapter.queryList(
        'SELECT * FROM CycleEntry ORDER BY date DESC',
        mapper: (Map<String, Object?> row) => CycleEntry(
            id: row['id'] as int?,
            date: _dateTimeConverter.decode(row['date'] as int),
            duration: row['duration'] as int,
            flow: _flowLevelConverter.decode(row['flow'] as String),
            color: _cycleColorConverter.decode(row['color'] as String),
            clots: _clotPresenceConverter.decode(row['clots'] as String)));
  }

  @override
  Future<List<CycleEntry>> findCyclesInRange(
    DateTime start,
    DateTime end,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM CycleEntry WHERE date BETWEEN ?1 AND ?2 ORDER BY date ASC',
        mapper: (Map<String, Object?> row) => CycleEntry(id: row['id'] as int?, date: _dateTimeConverter.decode(row['date'] as int), duration: row['duration'] as int, flow: _flowLevelConverter.decode(row['flow'] as String), color: _cycleColorConverter.decode(row['color'] as String), clots: _clotPresenceConverter.decode(row['clots'] as String)),
        arguments: [
          _dateTimeConverter.encode(start),
          _dateTimeConverter.encode(end)
        ]);
  }

  @override
  Future<void> insertCycle(CycleEntry cycle) async {
    await _cycleEntryInsertionAdapter.insert(cycle, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteCycle(CycleEntry cycle) async {
    await _cycleEntryDeletionAdapter.delete(cycle);
  }
}

class _$SymptomDao extends SymptomDao {
  _$SymptomDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _symptomLogInsertionAdapter = InsertionAdapter(
            database,
            'SymptomLog',
            (SymptomLog item) => <String, Object?>{
                  'id': item.id,
                  'date': _dateTimeConverter.encode(item.date),
                  'acne': item.acne,
                  'hairLoss': item.hairLoss,
                  'bloating': item.bloating,
                  'fatigue': item.fatigue,
                  'cravings': item.cravings,
                  'weight': item.weight,
                  'sleepHours': item.sleepHours
                }),
        _symptomLogDeletionAdapter = DeletionAdapter(
            database,
            'SymptomLog',
            ['id'],
            (SymptomLog item) => <String, Object?>{
                  'id': item.id,
                  'date': _dateTimeConverter.encode(item.date),
                  'acne': item.acne,
                  'hairLoss': item.hairLoss,
                  'bloating': item.bloating,
                  'fatigue': item.fatigue,
                  'cravings': item.cravings,
                  'weight': item.weight,
                  'sleepHours': item.sleepHours
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<SymptomLog> _symptomLogInsertionAdapter;

  final DeletionAdapter<SymptomLog> _symptomLogDeletionAdapter;

  @override
  Future<List<SymptomLog>> findAllSymptoms() async {
    return _queryAdapter.queryList(
        'SELECT * FROM SymptomLog ORDER BY date DESC',
        mapper: (Map<String, Object?> row) => SymptomLog(
            id: row['id'] as int?,
            date: _dateTimeConverter.decode(row['date'] as int),
            acne: row['acne'] as int,
            hairLoss: row['hairLoss'] as int,
            bloating: row['bloating'] as int,
            fatigue: row['fatigue'] as int,
            cravings: row['cravings'] as int,
            weight: row['weight'] as double?,
            sleepHours: row['sleepHours'] as int));
  }

  @override
  Future<List<SymptomLog>> findSymptomsInRange(
    DateTime start,
    DateTime end,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM SymptomLog WHERE date BETWEEN ?1 AND ?2 ORDER BY date ASC',
        mapper: (Map<String, Object?> row) => SymptomLog(id: row['id'] as int?, date: _dateTimeConverter.decode(row['date'] as int), acne: row['acne'] as int, hairLoss: row['hairLoss'] as int, bloating: row['bloating'] as int, fatigue: row['fatigue'] as int, cravings: row['cravings'] as int, weight: row['weight'] as double?, sleepHours: row['sleepHours'] as int),
        arguments: [
          _dateTimeConverter.encode(start),
          _dateTimeConverter.encode(end)
        ]);
  }

  @override
  Future<void> insertSymptom(SymptomLog symptom) async {
    await _symptomLogInsertionAdapter.insert(symptom, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteSymptom(SymptomLog symptom) async {
    await _symptomLogDeletionAdapter.delete(symptom);
  }
}

class _$JournalDao extends JournalDao {
  _$JournalDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _journalEntryInsertionAdapter = InsertionAdapter(
            database,
            'JournalEntry',
            (JournalEntry item) => <String, Object?>{
                  'id': item.id,
                  'date': _dateTimeConverter.encode(item.date),
                  'content': item.content,
                  'moodTags': item.moodTags,
                  'prompt': item.prompt
                }),
        _journalEntryDeletionAdapter = DeletionAdapter(
            database,
            'JournalEntry',
            ['id'],
            (JournalEntry item) => <String, Object?>{
                  'id': item.id,
                  'date': _dateTimeConverter.encode(item.date),
                  'content': item.content,
                  'moodTags': item.moodTags,
                  'prompt': item.prompt
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<JournalEntry> _journalEntryInsertionAdapter;

  final DeletionAdapter<JournalEntry> _journalEntryDeletionAdapter;

  @override
  Future<List<JournalEntry>> findAllEntries() async {
    return _queryAdapter.queryList(
        'SELECT * FROM JournalEntry ORDER BY date DESC',
        mapper: (Map<String, Object?> row) => JournalEntry(
            id: row['id'] as int?,
            date: _dateTimeConverter.decode(row['date'] as int),
            content: row['content'] as String,
            moodTags: row['moodTags'] as String,
            prompt: row['prompt'] as String));
  }

  @override
  Future<JournalEntry?> findEntryByDate(DateTime date) async {
    return _queryAdapter.query(
        'SELECT * FROM JournalEntry WHERE date = ?1 LIMIT 1',
        mapper: (Map<String, Object?> row) => JournalEntry(
            id: row['id'] as int?,
            date: _dateTimeConverter.decode(row['date'] as int),
            content: row['content'] as String,
            moodTags: row['moodTags'] as String,
            prompt: row['prompt'] as String),
        arguments: [_dateTimeConverter.encode(date)]);
  }

  @override
  Future<List<JournalEntry>> findEntriesInRange(
    DateTime start,
    DateTime end,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM JournalEntry WHERE date BETWEEN ?1 AND ?2 ORDER BY date ASC',
        mapper: (Map<String, Object?> row) => JournalEntry(id: row['id'] as int?, date: _dateTimeConverter.decode(row['date'] as int), content: row['content'] as String, moodTags: row['moodTags'] as String, prompt: row['prompt'] as String),
        arguments: [
          _dateTimeConverter.encode(start),
          _dateTimeConverter.encode(end)
        ]);
  }

  @override
  Future<void> upsertEntry(JournalEntry entry) async {
    await _journalEntryInsertionAdapter.insert(
        entry, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteEntry(JournalEntry entry) async {
    await _journalEntryDeletionAdapter.delete(entry);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
final _flowLevelConverter = FlowLevelConverter();
final _cycleColorConverter = CycleColorConverter();
final _clotPresenceConverter = ClotPresenceConverter();
