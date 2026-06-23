// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'symptom_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$symptomHistoryHash() => r'72e69e9195bcf4b341e869d5caee7c41b0247368';

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

/// See also [symptomHistory].
@ProviderFor(symptomHistory)
const symptomHistoryProvider = SymptomHistoryFamily();

/// See also [symptomHistory].
class SymptomHistoryFamily extends Family<AsyncValue<List<SymptomLog>>> {
  /// See also [symptomHistory].
  const SymptomHistoryFamily();

  /// See also [symptomHistory].
  SymptomHistoryProvider call({
    required DateTime start,
    required DateTime end,
  }) {
    return SymptomHistoryProvider(
      start: start,
      end: end,
    );
  }

  @override
  SymptomHistoryProvider getProviderOverride(
    covariant SymptomHistoryProvider provider,
  ) {
    return call(
      start: provider.start,
      end: provider.end,
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
  String? get name => r'symptomHistoryProvider';
}

/// See also [symptomHistory].
class SymptomHistoryProvider
    extends AutoDisposeFutureProvider<List<SymptomLog>> {
  /// See also [symptomHistory].
  SymptomHistoryProvider({
    required DateTime start,
    required DateTime end,
  }) : this._internal(
          (ref) => symptomHistory(
            ref as SymptomHistoryRef,
            start: start,
            end: end,
          ),
          from: symptomHistoryProvider,
          name: r'symptomHistoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$symptomHistoryHash,
          dependencies: SymptomHistoryFamily._dependencies,
          allTransitiveDependencies:
              SymptomHistoryFamily._allTransitiveDependencies,
          start: start,
          end: end,
        );

  SymptomHistoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.start,
    required this.end,
  }) : super.internal();

  final DateTime start;
  final DateTime end;

  @override
  Override overrideWith(
    FutureOr<List<SymptomLog>> Function(SymptomHistoryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SymptomHistoryProvider._internal(
        (ref) => create(ref as SymptomHistoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        start: start,
        end: end,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<SymptomLog>> createElement() {
    return _SymptomHistoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SymptomHistoryProvider &&
        other.start == start &&
        other.end == end;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, start.hashCode);
    hash = _SystemHash.combine(hash, end.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SymptomHistoryRef on AutoDisposeFutureProviderRef<List<SymptomLog>> {
  /// The parameter `start` of this provider.
  DateTime get start;

  /// The parameter `end` of this provider.
  DateTime get end;
}

class _SymptomHistoryProviderElement
    extends AutoDisposeFutureProviderElement<List<SymptomLog>>
    with SymptomHistoryRef {
  _SymptomHistoryProviderElement(super.provider);

  @override
  DateTime get start => (origin as SymptomHistoryProvider).start;
  @override
  DateTime get end => (origin as SymptomHistoryProvider).end;
}

String _$symptomListHash() => r'42414861af14533dfeaa5cf2363015c8c0542162';

/// See also [SymptomList].
@ProviderFor(SymptomList)
final symptomListProvider =
    AutoDisposeAsyncNotifierProvider<SymptomList, List<SymptomLog>>.internal(
  SymptomList.new,
  name: r'symptomListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$symptomListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SymptomList = AutoDisposeAsyncNotifier<List<SymptomLog>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
