// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$journalEntryByDateHash() =>
    r'203fc4033e6cd3fac9223ed83041f3a398677a20';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [journalEntryByDate].
@ProviderFor(journalEntryByDate)
const journalEntryByDateProvider = JournalEntryByDateFamily();

/// See also [journalEntryByDate].
class JournalEntryByDateFamily extends Family<AsyncValue<JournalEntry?>> {
  /// See also [journalEntryByDate].
  const JournalEntryByDateFamily();

  /// See also [journalEntryByDate].
  JournalEntryByDateProvider call(
    DateTime date,
  ) {
    return JournalEntryByDateProvider(
      date,
    );
  }

  @override
  JournalEntryByDateProvider getProviderOverride(
    covariant JournalEntryByDateProvider provider,
  ) {
    return call(
      provider.date,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'journalEntryByDateProvider';
}

/// See also [journalEntryByDate].
class JournalEntryByDateProvider
    extends AutoDisposeFutureProvider<JournalEntry?> {
  /// See also [journalEntryByDate].
  JournalEntryByDateProvider(
    DateTime date,
  ) : this._internal(
          (ref) => journalEntryByDate(
            ref as JournalEntryByDateRef,
            date,
          ),
          from: journalEntryByDateProvider,
          name: r'journalEntryByDateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$journalEntryByDateHash,
          dependencies: JournalEntryByDateFamily._dependencies,
          allTransitiveDependencies:
              JournalEntryByDateFamily._allTransitiveDependencies,
          date: date,
        );

  JournalEntryByDateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.date,
  }) : super.internal();

  final DateTime date;

  @override
  Override overrideWith(
    FutureOr<JournalEntry?> Function(JournalEntryByDateRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: JournalEntryByDateProvider._internal(
        (ref) => create(ref as JournalEntryByDateRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        date: date,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<JournalEntry?> createElement() {
    return _JournalEntryByDateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is JournalEntryByDateProvider && other.date == date;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, date.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin JournalEntryByDateRef on AutoDisposeFutureProviderRef<JournalEntry?> {
  /// The parameter `date` of this provider.
  DateTime get date;
}

class _JournalEntryByDateProviderElement
    extends AutoDisposeFutureProviderElement<JournalEntry?>
    with JournalEntryByDateRef {
  _JournalEntryByDateProviderElement(super.provider);

  @override
  DateTime get date => (origin as JournalEntryByDateProvider).date;
}

String _$journalListHash() => r'2ff82226195f86146683a34b9c7837e5cdcd735e';

/// See also [JournalList].
@ProviderFor(JournalList)
final journalListProvider =
    AutoDisposeAsyncNotifierProvider<JournalList, List<JournalEntry>>.internal(
  JournalList.new,
  name: r'journalListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$journalListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$JournalList = AutoDisposeAsyncNotifier<List<JournalEntry>>;
String _$currentPromptHash() => r'45e9ad4f2783c930f8aa67680f1b4e4359b02920';

/// See also [CurrentPrompt].
@ProviderFor(CurrentPrompt)
final currentPromptProvider =
    AutoDisposeNotifierProvider<CurrentPrompt, String>.internal(
  CurrentPrompt.new,
  name: r'currentPromptProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentPromptHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentPrompt = AutoDisposeNotifier<String>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
