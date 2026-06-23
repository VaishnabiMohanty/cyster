import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import '../../core/database/database_provider.dart';
import 'report_service.dart';
import 'pdf_generator.dart';

class ReportScreen extends ConsumerStatefulWidget {
  const ReportScreen({super.key});

  @override
  ConsumerState<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends ConsumerState<ReportScreen> {
  DateTimeRange _dateRange = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 90)),
    end: DateTime.now(),
  );
  bool _isGenerating = false;

  Future<void> _generateAndShareReport() async {
    setState(() => _isGenerating = true);
    
    try {
      final db = ref.read(databaseProvider);
      final service = ReportService(db);
      final data = await service.aggregateData(_dateRange.start, _dateRange.end);
      
      final pdf = await PdfGenerator.generateReport(data);
      final bytes = await pdf.save();
      
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/cyster_health_report.pdf');
      await file.writeAsBytes(bytes);
      
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'My PCOS Health Report from Cyster',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Doctor-Ready Report')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(Icons.description, size: 48, color: Colors.deepPurple),
                    SizedBox(height: 16),
                    Text(
                      'Export your data for your next doctor\'s visit.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Includes cycle history, symptom trends, and mood summaries. Personal journal text is excluded for privacy.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ListTile(
              title: const Text('Date Range'),
              subtitle: Text(
                '${DateFormat('MMM dd').format(_dateRange.start)} - ${DateFormat('MMM dd, yyyy').format(_dateRange.end)}',
              ),
              trailing: const Icon(Icons.date_range),
              onTap: () async {
                final picked = await showDateRangePicker(
                  context: context,
                  initialDateRange: _dateRange,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (picked != null) setState(() => _dateRange = picked);
              },
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: _isGenerating ? null : _generateAndShareReport,
              icon: _isGenerating 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.share),
              label: Text(_isGenerating ? 'Generating...' : 'Generate & Share PDF'),
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your report will be generated locally and can be shared via email or other apps.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
