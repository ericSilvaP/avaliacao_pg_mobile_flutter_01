import 'package:avaliacao_pg_mobile_flutter_01/data/models/answer_entry.dart';
import 'package:avaliacao_pg_mobile_flutter_01/src/domain/text_format.dart';

import 'round_result.dart';
import 'round_status.dart';

class GameRound {
  GameRound({required this.answer, this.maxErrors = 6})
    : assert(maxErrors > 0, 'maxErrors deve ser positivo'),
      _normalizedAnswer = TextFormat.format(answer.answer);

  static const String hiddenSymbol = '_';

  final AnswerEntry answer;
  final int maxErrors;

  final String _normalizedAnswer;
  final Set<String> _guessedLetters = {};
  bool _hintUsed = false;

  Set<String> get guessedLetters => Set.unmodifiable(_guessedLetters);

  Set<String> get wrongLetters => Set.unmodifiable(
    _guessedLetters.where((l) => !_normalizedAnswer.contains(l)),
  );

  bool get hintUsed => _hintUsed;

  bool isLetterUsed(String rawLetter) =>
      _guessedLetters.contains(TextFormat.format(rawLetter));

  int get currentErrors => wrongLetters.length;

  int get remainingErrors => maxErrors - currentErrors;

  RoundStatus get status {
    if (currentErrors >= maxErrors) return RoundStatus.lost;
    final allRevealed = _normalizedAnswer
        .split('')
        .where(TextFormat.isPlayableLetter)
        .every(_guessedLetters.contains);
    return allRevealed ? RoundStatus.won : RoundStatus.inProgress;
  }

  bool get isFinished => status != RoundStatus.inProgress;

  String get displayedAnswer {
    final reveal = isFinished;
    final original = answer.answer.split('');
    final normalized = _normalizedAnswer.split('');
    final buffer = StringBuffer();
    for (var i = 0; i < original.length; i++) {
      final isLetter = TextFormat.isPlayableLetter(normalized[i]);
      final visible =
          !isLetter || reveal || _guessedLetters.contains(normalized[i]);
      buffer.write(visible ? original[i] : hiddenSymbol);
    }
    return buffer.toString();
  }

  bool guessLetter(String rawLetter) {
    if (isFinished) return false;
    final letter = TextFormat.format(rawLetter.trim());
    if (!TextFormat.isPlayableLetter(letter)) return false;
    if (_guessedLetters.contains(letter)) return false;
    _guessedLetters.add(letter);
    return true;
  }

  String requestHint() {
    _hintUsed = true;
    return answer.hints.isEmpty ? '' : answer.hints.first;
  }

  RoundResult toResult() {
    if (!isFinished) {
      throw StateError('A rodada ainda está em andamento.');
    }
    return RoundResult(
      answerEntry: answer,
      status: status,
      errorCount: currentErrors,
      hintUsed: _hintUsed,
    );
  }
}
