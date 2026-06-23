import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'report_models.dart';
import '../cycle/cycle_entry.dart';

class PdfGenerator {
  static Future<pw.Document> generateReport(ReportDataSummary data) async {
    final pdf = pw.Document();
    final dateFormat = DateFormat('MMM dd, yyyy');

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          _buildHeader(data, dateFormat),
          pw.SizedBox(height: 20),
          _buildCycleHistory(data.cycles, dateFormat),
          pw.SizedBox(height: 20),
          _buildSymptomSummary(data.symptomStats),
          pw.SizedBox(height: 20),
          _buildMoodSummary(data.moodCounts),
          pw.SizedBox(height: 20),
          _buildMedicationPlaceholder(),
          pw.Spacer(),
          _buildFooter(),
        ],
      ),
    );

    return pdf;
  }

  static pw.Widget _buildHeader(ReportDataSummary data, DateFormat df) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('PCOS Health Report', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
        pw.Text('Cyster Companion App', style: const pw.TextStyle(color: PdfColors.grey)),
        pw.SizedBox(height: 10),
        pw.Text('Period: ${df.format(data.startDate)} - ${df.format(data.endDate)}'),
      ],
    );
  }

  static pw.Widget _buildCycleHistory(List<CycleEntry> cycles, DateFormat df) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Cycle History', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
        pw.Divider(),
        if (cycles.isEmpty)
          pw.Text('No cycle data logged for this period.')
        else
          pw.TableHelper.fromTextArray(
            headers: ['Date', 'Duration', 'Flow', 'Color', 'Clots'],
            data: cycles.map((c) => [
              df.format(c.date),
              '${c.duration} days',
              c.flow.name,
              c.color.name,
              c.clots.name,
            ]).toList(),
          ),
      ],
    );
  }

  static pw.Widget _buildSymptomSummary(Map<String, SymptomStats> stats) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Symptom Frequency & Severity', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
        pw.Divider(),
        if (stats.isEmpty)
          pw.Text('No symptoms logged for this period.')
        else
          pw.TableHelper.fromTextArray(
            headers: ['Symptom', 'Days Logged', 'Avg. Intensity (1-5)'],
            data: stats.entries.map((e) => [
              e.key,
              e.value.count.toString(),
              e.value.averageIntensity.toStringAsFixed(1),
            ]).toList(),
          ),
      ],
    );
  }

  static pw.Widget _buildMoodSummary(Map<dynamic, int> moodCounts) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Mood Summary', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
        pw.Divider(),
        if (moodCounts.isEmpty)
          pw.Text('No mood data logged for this period.')
        else
          pw.Wrap(
            spacing: 20,
            runSpacing: 10,
            children: moodCounts.entries.map((e) => 
              pw.Text('${e.key.toString().split('.').last}: ${e.value} days')
            ).toList(),
          ),
      ],
    );
  }

  static pw.Widget _buildMedicationPlaceholder() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Medications & Supplements', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 5),
          pw.Text('[Medication adherence tracking coming in Phase 2, Week 6]', style: const pw.TextStyle(fontStyle: pw.FontStyle.italic, color: PdfColors.grey700)),
        ],
      ),
    );
  }

  static pw.Widget _buildFooter() {
    return pw.Column(
      children: [
        pw.Divider(),
        pw.Text(
          'DISCLAIMER: This report is generated from self-reported data by the patient. It is intended for informational purposes and to aid clinical discussion. It does not constitute a medical diagnosis or treatment plan.',
          style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
          textAlign: pw.TextAlign.center,
        ),
      ],
    );
  }
}
