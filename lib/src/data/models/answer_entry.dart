import '../../domain/answer_category.dart';
import '../../domain/difficulty.dart';

class AnswerEntry {
  const AnswerEntry({
    required this.answer,
    required this.category,
    required this.difficulty,
    required this.hints,
  });

  factory AnswerEntry.fromJson(Map<String, dynamic> json) {
    try {
      return AnswerEntry(
        answer: json['answer'] as String,
        category: AnswerCategory.values.byName(json['category'] as String),
        difficulty: Difficulty.values.byName(json['difficulty'] as String),
        hints: List<String>.from(json['hints'] as List),
      );
    } on Object catch (e) {
      throw FormatException('Entrada inválida no JSON: $e');
    }
  }

  final String answer;
  final AnswerCategory category;
  final Difficulty difficulty;
  final List<String> hints;
}