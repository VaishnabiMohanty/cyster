import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_database.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError('Database not initialized');
});

// We'll initialize this in main()
Future<AppDatabase> initDatabase() async {
  return await $FloorAppDatabase.databaseBuilder('cyster_app.db').build();
}
