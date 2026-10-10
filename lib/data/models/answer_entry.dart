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

  factory AnswerEntry.fromJson(Map<String, dynamic> json) {
    final answer = json['answer'];
    final category = json['category'];
    final difficulty = json['difficulty'];
    final hints = json['hints'];

    if (answer is! String || answer.trim().isEmpty) {
      throw const FormatException('Invalid answer');
    }

    if (category is! String) {
      throw const FormatException('Invalid category');
    }

    if (difficulty is! String) {
      throw const FormatException('Invalid difficulty');
    }

    if (hints is! List ||
        hints.isEmpty ||
        hints.any((hint) => hint is! String || hint.trim().isEmpty)) {
      throw const FormatException('Invalid hints');
    }

    final AnswerCategory parsedCategory;
    final Difficulty parsedDifficulty;

    try {
      parsedCategory = AnswerCategory.values.byName(category);
    } on ArgumentError {
      throw FormatException('Unknown category: $category');
    }

    try {
      parsedDifficulty = Difficulty.values.byName(difficulty);
    } on ArgumentError {
      throw FormatException('Unknown difficulty: $difficulty');
    }

    return AnswerEntry(
      answer: answer,
      category: parsedCategory,
      difficulty: parsedDifficulty,
      hints: List<String>.unmodifiable(hints.cast<String>()),
    );
  }
}
