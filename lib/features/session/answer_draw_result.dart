import '../../data/models/answer_entry.dart';

sealed class AnswerDrawResult {
  const AnswerDrawResult();
}

final class DrawnAnswer extends AnswerDrawResult {
  const DrawnAnswer(this.entry);

  final AnswerEntry entry;
}

final class AnswersExhausted extends AnswerDrawResult {
  const AnswersExhausted({required this.totalAnswers});

  final int totalAnswers;
}

final class NoAnswersAvailable extends AnswerDrawResult {
  const NoAnswersAvailable();
}
