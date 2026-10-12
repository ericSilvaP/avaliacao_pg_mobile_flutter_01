import 'package:flutter_test/flutter_test.dart';

import 'package:avaliacao_pg_mobile_flutter_01/features/session/round_outcome.dart';
import 'package:avaliacao_pg_mobile_flutter_01/features/session/session_statistics.dart';

void main() {
  late SessionStatistics statistics;

  RoundOutcome buildOutcome({
    RoundOutcomeType type = RoundOutcomeType.victory,
    String answer = 'COELHO',
    int errorCount = 0,
    bool hintUsed = false,
  }) {
    return RoundOutcome(
      type: type,
      answer: answer,
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
        statistics.register(
          buildOutcome(type: RoundOutcomeType.victory, errorCount: 2),
        );
        statistics.register(
          buildOutcome(type: RoundOutcomeType.defeat, errorCount: 6),
        );

        expect(statistics.completedRounds, 2);
        expect(statistics.victories, 1);
        expect(statistics.defeats, 1);
        expect(statistics.totalErrors, 8);
      },
    );

    test('should calculate percentages from completed rounds', () {
      statistics.register(buildOutcome(type: RoundOutcomeType.victory));
      statistics.register(buildOutcome(type: RoundOutcomeType.victory));
      statistics.register(buildOutcome(type: RoundOutcomeType.defeat));

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
      statistics.register(buildOutcome(hintUsed: true));
      statistics.register(buildOutcome(hintUsed: false));
      statistics.register(buildOutcome(hintUsed: true));

      expect(statistics.hintsUsed, 2);
    });

    test('should reject a negative error count', () {
      expect(() => buildOutcome(errorCount: -1), throwsArgumentError);
    });

    test('should clear every indicator on reset', () {
      statistics.register(
        buildOutcome(
          type: RoundOutcomeType.defeat,
          errorCount: 5,
          hintUsed: true,
        ),
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
