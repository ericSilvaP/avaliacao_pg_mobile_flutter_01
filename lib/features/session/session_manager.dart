import 'dart:math';

import '../../data/repositories/answer_repository.dart';
import '../../domain/enums/answer_category.dart';
import '../../domain/enums/difficulty.dart';
import 'answer_draw_result.dart';
import 'session_statistics.dart';

class SessionManager {
  SessionManager(
    this._repository, {
    Random? random,
    SessionStatistics? statistics,
  }) : _random = random ?? Random(),
       statistics = statistics ?? SessionStatistics();

  final AnswerRepository _repository;
  final Random _random;

  final SessionStatistics statistics;

  final Map<AnswerCategory, Map<Difficulty, Set<String>>> _usedAnswers = {};

  Future<AnswerDrawResult> drawAnswer({
    required AnswerCategory category,
    required Difficulty difficulty,
  }) async {
    final entries = await _repository.findEntries(
      category: category,
      difficulty: difficulty,
    );

    if (entries.isEmpty) {
      return const NoAnswersAvailable();
    }

    final used = _usedAnswersFor(category, difficulty);
    final remaining = entries
        .where((entry) => !used.contains(entry.answer))
        .toList(growable: false);

    if (remaining.isEmpty) {
      return AnswersExhausted(totalAnswers: entries.length);
    }

    final drawn = remaining[_random.nextInt(remaining.length)];
    used.add(drawn.answer);

    return DrawnAnswer(drawn);
  }

  Set<String> usedAnswersFor(AnswerCategory category, Difficulty difficulty) {
    final answers = _usedAnswers[category]?[difficulty];

    if (answers == null) {
      return const <String>{};
    }

    return Set<String>.unmodifiable(answers);
  }

  void reset() {
    _usedAnswers.clear();
    statistics.reset();
  }

  Set<String> _usedAnswersFor(AnswerCategory category, Difficulty difficulty) {
    return _usedAnswers
        .putIfAbsent(category, () => {})
        .putIfAbsent(difficulty, () => <String>{});
  }
}
