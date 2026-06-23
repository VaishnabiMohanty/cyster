import 'package:flutter_test/flutter_test.dart';
import 'package:cyster/features/journal/journal_prompt_service.dart';

void main() {
  group('JournalPromptService', () {
    final service = JournalPromptService();

    test('getRandomPrompt returns a prompt from the bank', () {
      final prompt = service.getRandomPrompt();
      expect(service.allPrompts, contains(prompt));
    });

    test('getRandomPrompt avoids repeating the last prompt', () {
      const lastPrompt = "How did your body feel today compared to yesterday?";
      for (int i = 0; i < 50; i++) {
        final newPrompt = service.getRandomPrompt(lastPrompt: lastPrompt);
        expect(newPrompt, isNot(equals(lastPrompt)));
      }
    });

    test('allPrompts has at least 15 prompts', () {
      expect(service.allPrompts.length, greaterThanOrEqualTo(15));
    });
  });
}
