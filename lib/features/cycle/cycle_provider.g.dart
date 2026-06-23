// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cycle_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$cyclePredictionHash() => r'a423f0bca33fe8b3726dacc4514f40faae88443b';

/// See also [cyclePrediction].
@ProviderFor(cyclePrediction)
final cyclePredictionProvider = AutoDisposeProvider<PredictionResult>.internal(
  cyclePrediction,
  name: r'cyclePredictionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$cyclePredictionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CyclePredictionRef = AutoDisposeProviderRef<PredictionResult>;
String _$cycleListHash() => r'fee4e4c1bc740836cb7d6bf4b91e3c5e7ce80b82';

/// See also [CycleList].
@ProviderFor(CycleList)
final cycleListProvider =
    AutoDisposeAsyncNotifierProvider<CycleList, List<CycleEntry>>.internal(
  CycleList.new,
  name: r'cycleListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$cycleListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CycleList = AutoDisposeAsyncNotifier<List<CycleEntry>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
