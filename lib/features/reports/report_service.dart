import '../../core/database/app_database.dart';
import 'report_models.dart';

class ReportService {
  final AppDatabase database;

  ReportService(this.database);

  Future<ReportDataSummary> aggregateData(DateTime start, DateTime end) async {
    final cycles = await database.cycleDao.findCyclesInRange(start, end);
    final symptoms = await database.symptomDao.findSymptomsInRange(start, end);
    final journalEntries = await database.journalDao.findEntriesInRange(start, end);

    return ReportDataSummary(
      startDate: start,
      endDate: end,
      cycles: cycles,
      symptoms: symptoms,
      journalEntries: journalEntries,
    );
  }
}
