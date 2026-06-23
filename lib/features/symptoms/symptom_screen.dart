import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'symptom_log.dart';
import 'symptom_provider.dart';
import 'symptom_chart.dart';
import 'package:intl/intl.dart';

class SymptomScreen extends ConsumerWidget {
  const SymptomScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final symptomListAsync = ref.watch(symptomListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Symptoms & Health')),
      body: symptomListAsync.when(
        data: (logs) => SingleChildScrollView(
          child: Column(
            children: [
              if (logs.isNotEmpty) SymptomTimelineChart(logs: logs),
              const Divider(),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Past Logs', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: logs.length,
                itemBuilder: (context, index) {
                  final log = logs[index];
                  return ListTile(
                    title: Text(DateFormat('MMM dd, yyyy').format(log.date)),
                    subtitle: Text('Acne: ${log.acne}, Bloating: ${log.bloating}, Sleep: ${log.sleepHours}h'),
                    trailing: log.weight != null ? Text('${log.weight} kg') : null,
                  );
                },
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddLogSheet(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddLogSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const AddSymptomLogSheet(),
    );
  }
}

class AddSymptomLogSheet extends StatefulWidget {
  const AddSymptomLogSheet({super.key});

  @override
  State<AddSymptomLogSheet> createState() => _AddSymptomLogSheetState();
}

class _AddSymptomLogSheetState extends State<AddSymptomLogSheet> {
  DateTime _selectedDate = DateTime.now();
  int _acne = 0;
  int _bloating = 0;
  int _fatigue = 0;
  int _cravings = 0;
  int _sleepHours = 8;
  final _weightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Log Symptoms', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Date'),
              trailing: Text(DateFormat('yyyy-MM-dd').format(_selectedDate)),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (picked != null) setState(() => _selectedDate = picked);
              },
            ),
            _buildIntensitySlider('Acne', _acne, (v) => setState(() => _acne = v.round())),
            _buildIntensitySlider('Bloating', _bloating, (v) => setState(() => _bloating = v.round())),
            _buildIntensitySlider('Fatigue', _fatigue, (v) => setState(() => _fatigue = v.round())),
            _buildIntensitySlider('Cravings', _cravings, (v) => setState(() => _cravings = v.round())),
            
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _weightController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Weight (kg)', border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Sleep: $_sleepHours h'),
                      Slider(
                        value: _sleepHours.toDouble(),
                        min: 0,
                        max: 24,
                        divisions: 24,
                        onChanged: (v) => setState(() => _sleepHours = v.round()),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Consumer(builder: (context, ref, child) {
              return ElevatedButton(
                onPressed: () {
                  final log = SymptomLog(
                    date: _selectedDate,
                    acne: _acne,
                    bloating: _bloating,
                    fatigue: _fatigue,
                    cravings: _cravings,
                    sleepHours: _sleepHours,
                    weight: double.tryParse(_weightController.text),
                  );
                  ref.read(symptomListProvider.notifier).addLog(log);
                  Navigator.pop(context);
                },
                child: const Text('Save Symptoms'),
              );
            }),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildIntensitySlider(String label, int value, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label Intensity ($value)'),
        Slider(
          value: value.toDouble(),
          min: 0,
          max: 5,
          divisions: 5,
          label: value.toString(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
