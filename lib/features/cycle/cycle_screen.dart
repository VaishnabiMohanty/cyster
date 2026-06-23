import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'cycle_entry.dart';
import 'cycle_provider.dart';
import 'cycle_predictor.dart';
import 'package:intl/intl.dart';

class CycleScreen extends ConsumerWidget {
  const CycleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cycleListAsync = ref.watch(cycleListProvider);
    final prediction = ref.watch(cyclePredictionProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Cycle Tracker')),
      body: Column(
        children: [
          _PredictionCard(prediction: prediction),
          Expanded(
            child: cycleListAsync.when(
              data: (cycles) => ListView.builder(
                itemCount: cycles.length,
                itemBuilder: (context, index) {
                  final cycle = cycles[index];
                  return ListTile(
                    title: Text(DateFormat('MMM dd, yyyy').format(cycle.date)),
                    subtitle: Text('${cycle.duration} days - ${cycle.flow.name} flow'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => ref.read(cycleListProvider.notifier).deleteEntry(cycle),
                    ),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEntrySheet(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddEntrySheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const AddCycleEntrySheet(),
    );
  }
}

class _PredictionCard extends StatelessWidget {
  final PredictionResult prediction;

  const _PredictionCard({required this.prediction});

  @override
  Widget build(BuildContext context) {
    String title;
    String subtitle;
    Color color;

    switch (prediction) {
      case NotEnoughData(cyclesNeeded: var needed):
        title = "Not enough data yet";
        subtitle = "Log $needed more cycle${needed > 1 ? 's' : ''} to see predictions.";
        color = Colors.grey;
      case PredictableCycle(message: var msg, isIrregular: var irregular):
        title = "Next Cycle Prediction";
        subtitle = msg;
        color = irregular ? Colors.orange : Colors.green;
    }

    return Card(
      margin: const EdgeInsets.all(16),
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(subtitle, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}

class AddCycleEntrySheet extends StatefulWidget {
  const AddCycleEntrySheet({super.key});

  @override
  State<AddCycleEntrySheet> createState() => _AddCycleEntrySheetState();
}

class _AddCycleEntrySheetState extends State<AddCycleEntrySheet> {
  DateTime _selectedDate = DateTime.now();
  int _duration = 5;
  FlowLevel _flow = FlowLevel.medium;
  CycleColor _color = CycleColor.brightRed;
  ClotPresence _clots = ClotPresence.none;

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
            Text('Log Period', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Start Date'),
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
            const SizedBox(height: 8),
            const Text('Duration (days)'),
            Slider(
              value: _duration.toDouble(),
              min: 1,
              max: 14,
              divisions: 13,
              label: _duration.toString(),
              onChanged: (v) => setState(() => _duration = v.round()),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<FlowLevel>(
              value: _flow,
              decoration: const InputDecoration(labelText: 'Flow Level'),
              items: FlowLevel.values.map((f) => DropdownMenuItem(value: f, child: Text(f.name))).toList(),
              onChanged: (v) => setState(() => _flow = v!),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<CycleColor>(
              value: _color,
              decoration: const InputDecoration(labelText: 'Color'),
              items: CycleColor.values.map((c) => DropdownMenuItem(value: c, child: Text(c.name))).toList(),
              onChanged: (v) => setState(() => _color = v!),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<ClotPresence>(
              value: _clots,
              decoration: const InputDecoration(labelText: 'Clots'),
              items: ClotPresence.values.map((c) => DropdownMenuItem(value: c, child: Text(c.name))).toList(),
              onChanged: (v) => setState(() => _clots = v!),
            ),
            const SizedBox(height: 24),
            Consumer(builder: (context, ref, child) {
              return ElevatedButton(
                onPressed: () {
                  final entry = CycleEntry(
                    date: _selectedDate,
                    duration: _duration,
                    flow: _flow,
                    color: _color,
                    clots: _clots,
                  );
                  ref.read(cycleListProvider.notifier).addEntry(entry);
                  Navigator.pop(context);
                },
                child: const Text('Save Entry'),
              );
            }),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
