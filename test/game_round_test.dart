import 'package:avaliacao_pg_mobile_flutter_01/data/models/answer_entry.dart';
import 'package:avaliacao_pg_mobile_flutter_01/domain/enums/answer_category.dart';
import 'package:avaliacao_pg_mobile_flutter_01/domain/enums/difficulty.dart';
import 'package:avaliacao_pg_mobile_flutter_01/domain/game_round.dart';
import 'package:avaliacao_pg_mobile_flutter_01/domain/round_status.dart';
import 'package:flutter_test/flutter_test.dart';

AnswerEntry buildEntry(String answer, {List<String> hints = const ['Dica.']}) {
  return AnswerEntry(
    answer: answer,
    category: AnswerCategory.animals,
    difficulty: Difficulty.easy,
    hints: hints,
  );
}

void main() {
  group('GameRound', () {
    test('keeps separators visible and hides only missing letters', () {
      final round = GameRound(answer: buildEntry('A B'));

      round.guessLetter('A');

      expect(round.displayedAnswer, 'A _');
    });

    test('declares defeat after reaching the maximum of errors', () {
      final round = GameRound(answer: buildEntry('LOBO'), maxErrors: 2);

      round.guessLetter('X');
      round.guessLetter('Y');

      expect(round.status, RoundStatus.lost);
      expect(round.isFinished, isTrue);
      expect(round.currentErrors, 2);
      expect(round.remainingErrors, 0);
      expect(round.wrongLetters, {'X', 'Y'});
    });

    test('declares victory when every playable letter is revealed', () {
      final round = GameRound(answer: buildEntry('OURO'));

      round.guessLetter('O');
      round.guessLetter('U');
      round.guessLetter('R');

      expect(round.status, RoundStatus.won);
      expect(round.displayedAnswer, 'OURO');
    });

    test('normalizes accented letters from the answer and the guess', () {
      final round = GameRound(answer: buildEntry('AÇÚCAR'));

      round.guessLetter('c');
      round.guessLetter('á');
      round.guessLetter('u');
      round.guessLetter('r');

      expect(round.status, RoundStatus.won);
      expect(round.displayedAnswer, 'AÇÚCAR');
    });

    test('ignores repeated and invalid guesses', () {
      final round = GameRound(answer: buildEntry('GATO'));

      expect(round.guessLetter('G'), isTrue);
      expect(round.guessLetter('g'), isFalse);
      expect(round.guessLetter(' '), isFalse);
      expect(round.guessLetter('1'), isFalse);
      expect(round.guessLetter('é'), isTrue);
      expect(round.currentErrors, 1);
    });

    test('rejects guesses after the round is finished', () {
      final round = GameRound(answer: buildEntry('AU'));

      round.guessLetter('A');
      round.guessLetter('U');

      expect(round.guessLetter('X'), isFalse);
    });

    test('counts only letters outside the answer as errors', () {
      final round = GameRound(answer: buildEntry('GATO'));

      round.guessLetter('G');
      round.guessLetter('X');
      round.guessLetter('Z');

      expect(round.currentErrors, 2);
      expect(round.wrongLetters, {'X', 'Z'});
      expect(round.guessedLetters, {'G', 'X', 'Z'});
      expect(round.isLetterUsed('g'), isTrue);
    });

    test('marks the hint as used and returns the first hint', () {
      final round = GameRound(
        answer: buildEntry(
          'LOBO',
          hints: ['Mamífero canino.', 'Animal doméstico.'],
        ),
      );

      expect(round.hintUsed, isFalse);
      expect(round.requestHint(), 'Mamífero canino.');
      expect(round.hintUsed, isTrue);
    });

    test('returns an empty hint when the answer has none', () {
      final round = GameRound(answer: buildEntry('AU', hints: []));

      expect(round.requestHint(), '');
    });

    test('toResult throws while the round is still in progress', () {
      final round = GameRound(answer: buildEntry('GATO'));

      expect(round.toResult, throwsStateError);
    });

    test('toResult exposes the round summary after the end', () {
      final round = GameRound(answer: buildEntry('LOBO'));

      round.requestHint();
      round.guessLetter('X');
      round.guessLetter('L');
      round.guessLetter('O');
      round.guessLetter('B');

      final result = round.toResult();

      expect(result.answerEntry.answer, 'LOBO');
      expect(result.status, RoundStatus.won);
      expect(result.errorCount, 1);
      expect(result.hintUsed, isTrue);
      expect(result.isVictory, isTrue);
    });
  });
}
