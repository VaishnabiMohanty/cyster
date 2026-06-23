import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'symptom_log.dart';
import 'package:intl/intl.dart';

class SymptomTimelineChart extends StatelessWidget {
  final List<SymptomLog> logs;

  const SymptomTimelineChart({super.key, required this.logs});

  @override
  Widget build(BuildContext context) {
    if (logs.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text('No data to display yet')),
      );
    }

    // Sort logs by date to ensure the chart is chronological
    final sortedLogs = List<SymptomLog>.from(logs)..sort((a, b) => a.date.compareTo(b.date));

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text('Symptom Intensity Over Time', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 250,
          child: Padding(
            padding: const EdgeInsets.only(right: 20, top: 10, bottom: 10),
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: true, drawVerticalLine: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(DateFormat('MM/dd').format(date), style: const TextStyle(fontSize: 10)),
                        );
                      },
                      reservedSize: 30,
                      interval: const Duration(days: 3).inMilliseconds.toDouble(),
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 30),
                  ),
                ),
                borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey.withOpacity(0.3))),
                minY: 0,
                maxY: 5,
                lineBarsData: [
                  _createLineData(sortedLogs, (log) => log.acne.toDouble(), Colors.purple, 'Acne'),
                  _createLineData(sortedLogs, (log) => log.bloating.toDouble(), Colors.blue, 'Bloating'),
                  _createLineData(sortedLogs, (log) => log.fatigue.toDouble(), Colors.orange, 'Fatigue'),
                ],
              ),
            ),
          ),
        ),
        _buildLegend(),
      ],
    );
  }

  LineChartBarData _createLineData(
    List<SymptomLog> logs,
    double Function(SymptomLog) getY,
    Color color,
    String label,
  ) {
    return LineChartBarData(
      spots: logs.map((log) => FlSpot(log.date.millisecondsSinceEpoch.toDouble(), getY(log))).toList(),
      isCurved: true,
      color: color,
      barWidth: 3,
      dotData: const FlDotData(show: true),
      belowBarData: BarAreaData(show: false),
    );
  }

  Widget _buildLegend() {
    return Wrap(
      spacing: 16,
      children: [
        _legendItem('Acne', Colors.purple),
        _legendItem('Bloating', Colors.blue),
        _legendItem('Fatigue', Colors.orange),
      ],
    );
  }

  Widget _legendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 12, color: color),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
