import 'dart:math';

class JournalPromptService {
  static const List<String> _prompts = [
    "How did your body feel today compared to yesterday?",
    "What's one small win you had in managing your symptoms today?",
    "Are there any specific symptoms that felt particularly frustrating today?",
    "What is one thing you'd like to ask your doctor at your next visit?",
    "How are you feeling about your energy levels today?",
    "Describe a moment today when you felt kind to your body.",
    "What's a PCOS-friendly meal or snack you enjoyed today?",
    "Did you notice any changes in your skin or hair today?",
    "How has your sleep quality been affecting your mood lately?",
    "What's one thing you wish people understood better about living with PCOS?",
    "Are there any stressors today that might be impacting your hormonal health?",
    "How do you handle 'brain fog' when it hits during the day?",
    "What are you doing today to prioritize your self-care?",
    "Reflect on a time you felt empowered in your health journey.",
    "What's one goal you have for your health this coming week?",
    "How do you stay motivated when progress feels slow?",
    "Describe your current relationship with your body image.",
    "What are three things you're grateful for today, outside of health?",
    "Did you take any steps today to manage your stress levels?",
    "What does 'listening to your body' look like for you today?"
  ];

  String getRandomPrompt({String? lastPrompt}) {
    final availablePrompts = _prompts.where((p) => p != lastPrompt).toList();
    return availablePrompts[Random().nextInt(availablePrompts.length)];
  }

  List<String> get allPrompts => _prompts;
}
