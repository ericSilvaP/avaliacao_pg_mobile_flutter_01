import '../../domain/enums/answer_category.dart';
import '../../domain/enums/difficulty.dart';

class AnswerEntry {
  final String answer;
  final AnswerCategory category;
  final Difficulty difficulty;
  final List<String> hints;

  const AnswerEntry({
    required this.answer,
    required this.category,
    required this.difficulty,
    required this.hints,
  });
}
