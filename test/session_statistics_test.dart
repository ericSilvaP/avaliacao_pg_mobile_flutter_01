import 'package:flutter_test/flutter_test.dart';

import 'package:avaliacao_pg_mobile_flutter_01/data/models/answer_entry.dart';
import 'package:avaliacao_pg_mobile_flutter_01/domain/enums/answer_category.dart';
import 'package:avaliacao_pg_mobile_flutter_01/domain/enums/difficulty.dart';
import 'package:avaliacao_pg_mobile_flutter_01/features/session/session_statistics.dart';
import 'package:avaliacao_pg_mobile_flutter_01/src/domain/round_result.dart';
import 'package:avaliacao_pg_mobile_flutter_01/src/domain/round_status.dart';

void main() {
  late SessionStatistics statistics;

  RoundResult buildResult({
    bool victory = true,
    int errorCount = 0,
    bool hintUsed = false,
  }) {
    return RoundResult(
      answerEntry: AnswerEntry(
        answer: 'COELHO',
        category: AnswerCategory.animals,
        difficulty: Difficulty.easy,
        hints: const ['Mamífero de orelhas longas.'],
      ),
      status: victory ? RoundStatus.won : RoundStatus.lost,
      errorCount: errorCount,
      hintUsed: hintUsed,
    );
  }

  setUp(() {
    statistics = SessionStatistics();
  });

  group('SessionStatistics', () {
    test('should start with zeroed indicators', () {
      expect(statistics.completedRounds, 0);
      expect(statistics.victories, 0);
      expect(statistics.defeats, 0);
      expect(statistics.totalErrors, 0);
      expect(statistics.hintsUsed, 0);
      expect(statistics.victoryPercentage, 0);
      expect(statistics.defeatPercentage, 0);
    });

    test(
      'should count victories, defeats and errors from completed rounds',
      () {
        statistics.register(buildResult(victory: true, errorCount: 2));
        statistics.register(buildResult(victory: false, errorCount: 6));

        expect(statistics.completedRounds, 2);
        expect(statistics.victories, 1);
        expect(statistics.defeats, 1);
        expect(statistics.totalErrors, 8);
      },
    );

    test('should calculate percentages from completed rounds', () {
      statistics.register(buildResult());
      statistics.register(buildResult());
      statistics.register(buildResult(victory: false));

      expect(statistics.victoryPercentage, closeTo(66.67, 0.01));
      expect(statistics.defeatPercentage, closeTo(33.33, 0.01));
      expect(
        statistics.victoryPercentage + statistics.defeatPercentage,
        closeTo(100, 0.001),
      );
    });

    test('should keep percentages at zero without completed rounds', () {
      expect(statistics.victoryPercentage, 0);
      expect(statistics.defeatPercentage, 0);
    });

    test('should count a hint at most once per round', () {
      statistics.register(buildResult(hintUsed: true));
      statistics.register(buildResult(hintUsed: false));
      statistics.register(buildResult(hintUsed: true));

      expect(statistics.hintsUsed, 2);
    });

    test('should clear every indicator on reset', () {
      statistics.register(
        buildResult(victory: false, errorCount: 5, hintUsed: true),
      );

      statistics.reset();

      expect(statistics.completedRounds, 0);
      expect(statistics.victories, 0);
      expect(statistics.defeats, 0);
      expect(statistics.totalErrors, 0);
      expect(statistics.hintsUsed, 0);
      expect(statistics.victoryPercentage, 0);
      expect(statistics.defeatPercentage, 0);
    });
  });
}
