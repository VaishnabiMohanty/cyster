import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'journal_entry.dart';
import 'journal_provider.dart';
import 'package:intl/intl.dart';

class JournalScreen extends ConsumerStatefulWidget {
  const JournalScreen({super.key});

  @override
  ConsumerState<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends ConsumerState<JournalScreen> {
  final TextEditingController _contentController = TextEditingController();
  final Set<MoodTag> _selectedMoods = {};
  DateTime _selectedDate = DateTime.now();
  bool _isInitialized = false;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  void _normalizeDate(DateTime date) {
    _selectedDate = DateTime(date.year, date.month, date.day);
  }

  Future<void> _loadEntry() async {
    _normalizeDate(_selectedDate);
    final entry = await ref.read(journalEntryByDateProvider(_selectedDate).future);
    
    if (entry != null) {
      _contentController.text = entry.content;
      _selectedMoods.clear();
      _selectedMoods.addAll(entry.moods);
      ref.read(currentPromptProvider.notifier).setPrompt(entry.prompt);
    } else {
      _contentController.clear();
      _selectedMoods.clear();
      // Keep existing prompt or shuffle if it's a new day
    }
    setState(() {
      _isInitialized = true;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadEntry());
  }

  @override
  Widget build(BuildContext context) {
    final currentPrompt = ref.watch(currentPromptProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                setState(() {
                  _selectedDate = picked;
                  _isInitialized = false;
                });
                _loadEntry();
              }
            },
          ),
        ],
      ),
      body: !_isInitialized 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  DateFormat('EEEE, MMM dd').format(_selectedDate),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 24),
                Text('How are you feeling?', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: MoodTag.values.map((tag) {
                    final isSelected = _selectedMoods.contains(tag);
                    return FilterChip(
                      label: Text(tag.name),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedMoods.add(tag);
                          } else {
                            _selectedMoods.remove(tag);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 32),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Daily Prompt', style: TextStyle(fontWeight: FontWeight.bold)),
                            IconButton(
                              icon: const Icon(Icons.shuffle, size: 20),
                              onPressed: () => ref.read(currentPromptProvider.notifier).shuffle(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          currentPrompt,
                          style: const TextStyle(fontStyle: FontStyle.italic),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _contentController,
                  maxLines: 10,
                  decoration: const InputDecoration(
                    hintText: 'Write your thoughts here...',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _saveEntry,
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
                  child: const Text('Save Entry'),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
    );
  }

  void _saveEntry() async {
    final entry = JournalEntry(
      date: _selectedDate,
      content: _contentController.text,
      moodTags: _selectedMoods.map((e) => e.name).join(','),
      prompt: ref.read(currentPromptProvider),
    );
    
    await ref.read(journalListProvider.notifier).saveEntry(entry);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Entry saved successfully')),
      );
    }
  }
}
