import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

import 'package:avaliacao_pg_mobile_flutter_01/data/models/answer_entry.dart';
import 'package:avaliacao_pg_mobile_flutter_01/data/repositories/answer_repository.dart';
import 'package:avaliacao_pg_mobile_flutter_01/domain/enums/answer_category.dart';
import 'package:avaliacao_pg_mobile_flutter_01/domain/enums/difficulty.dart';
import 'package:avaliacao_pg_mobile_flutter_01/features/session/answer_draw_result.dart';
import 'package:avaliacao_pg_mobile_flutter_01/features/session/session_manager.dart';

void main() {
  late FakeAnswerRepository repository;
  late SessionManager session;

  AnswerEntry buildEntry({
    required String answer,
    AnswerCategory category = AnswerCategory.animals,
    Difficulty difficulty = Difficulty.easy,
  }) {
    return AnswerEntry(
      answer: answer,
      category: category,
      difficulty: difficulty,
      hints: const ['Dica de teste.'],
    );
  }

  setUp(() {
    repository = FakeAnswerRepository([
      buildEntry(answer: 'GATO DOMÉSTICO'),
      buildEntry(answer: 'URSO POLAR'),
      buildEntry(answer: 'COELHO'),
      buildEntry(
        answer: 'CORRIDA COM OBSTÁCULOS',
        category: AnswerCategory.sports,
      ),
      buildEntry(answer: 'ELEFANTE', difficulty: Difficulty.medium),
    ]);

    session = SessionManager(repository, random: Random(7));
  });

  group('drawAnswer', () {
    test(
      'should draw an entry compatible with category and difficulty',
      () async {
        final result = await session.drawAnswer(
          category: AnswerCategory.animals,
          difficulty: Difficulty.easy,
        );

        expect(result, isA<DrawnAnswer>());

        final drawn = (result as DrawnAnswer).entry;
        expect(drawn.category, AnswerCategory.animals);
        expect(drawn.difficulty, Difficulty.easy);
        expect(repository.lastQuery, (AnswerCategory.animals, Difficulty.easy));
      },
    );

    test('should not repeat answers while other options remain', () async {
      final drawnAnswers = <String>{};

      for (var i = 0; i < 3; i++) {
        final result = await session.drawAnswer(
          category: AnswerCategory.animals,
          difficulty: Difficulty.easy,
        );

        final drawn = result as DrawnAnswer;
        expect(drawnAnswers.add(drawn.entry.answer), isTrue);
      }

      expect(drawnAnswers, {'GATO DOMÉSTICO', 'URSO POLAR', 'COELHO'});
    });

    test('should report exhaustion after every answer was used', () async {
      for (var i = 0; i < 3; i++) {
        await session.drawAnswer(
          category: AnswerCategory.animals,
          difficulty: Difficulty.easy,
        );
      }

      final result = await session.drawAnswer(
        category: AnswerCategory.animals,
        difficulty: Difficulty.easy,
      );

      expect(result, isA<AnswersExhausted>());
      expect((result as AnswersExhausted).totalAnswers, 3);
    });

    test('should track used answers per category and difficulty', () async {
      await session.drawAnswer(
        category: AnswerCategory.animals,
        difficulty: Difficulty.easy,
      );
      await session.drawAnswer(
        category: AnswerCategory.animals,
        difficulty: Difficulty.easy,
      );

      expect(
        session.usedAnswersFor(AnswerCategory.animals, Difficulty.easy).length,
        2,
      );
      expect(
        session
            .usedAnswersFor(AnswerCategory.animals, Difficulty.medium)
            .isEmpty,
        isTrue,
      );
      expect(
        session.usedAnswersFor(AnswerCategory.sports, Difficulty.easy).isEmpty,
        isTrue,
      );
    });

    test(
      'should exhaust answers only within the selected combination',
      () async {
        for (var i = 0; i < 3; i++) {
          await session.drawAnswer(
            category: AnswerCategory.animals,
            difficulty: Difficulty.easy,
          );
        }

        final exhausted = await session.drawAnswer(
          category: AnswerCategory.animals,
          difficulty: Difficulty.easy,
        );
        expect(exhausted, isA<AnswersExhausted>());

        final otherCombination = await session.drawAnswer(
          category: AnswerCategory.animals,
          difficulty: Difficulty.medium,
        );
        expect(otherCombination, isA<DrawnAnswer>());
      },
    );

    test(
      'should report when the combination has no answers in the data',
      () async {
        final result = await session.drawAnswer(
          category: AnswerCategory.technology,
          difficulty: Difficulty.hard,
        );

        expect(result, isA<NoAnswersAvailable>());
        expect(
          session.usedAnswersFor(AnswerCategory.technology, Difficulty.hard),
          isEmpty,
        );
      },
    );

    test(
      'should allow drawing the same combination again after reset',
      () async {
        await session.drawAnswer(
          category: AnswerCategory.animals,
          difficulty: Difficulty.easy,
        );
        await session.drawAnswer(
          category: AnswerCategory.animals,
          difficulty: Difficulty.easy,
        );

        session.reset();

        expect(
          session.usedAnswersFor(AnswerCategory.animals, Difficulty.easy),
          isEmpty,
        );

        final result = await session.drawAnswer(
          category: AnswerCategory.animals,
          difficulty: Difficulty.easy,
        );

        expect(result, isA<DrawnAnswer>());
      },
    );

    test('should return an unmodifiable snapshot of used answers', () async {
      await session.drawAnswer(
        category: AnswerCategory.animals,
        difficulty: Difficulty.easy,
      );

      final usedAnswers = session.usedAnswersFor(
        AnswerCategory.animals,
        Difficulty.easy,
      );

      expect(() => usedAnswers.add('OUTRA RESPOSTA'), throwsUnsupportedError);
    });
  });
}

class FakeAnswerRepository implements AnswerRepository {
  FakeAnswerRepository(this.entries);

  final List<AnswerEntry> entries;

  (AnswerCategory, Difficulty)? lastQuery;

  @override
  Future<List<AnswerCategory>> getCategories() async {
    return AnswerCategory.values;
  }

  @override
  Future<List<Difficulty>> getDifficulties(AnswerCategory category) async {
    return Difficulty.values;
  }

  @override
  Future<List<AnswerEntry>> findEntries({
    required AnswerCategory category,
    required Difficulty difficulty,
  }) async {
    lastQuery = (category, difficulty);

    return entries
        .where(
          (entry) =>
              entry.category == category && entry.difficulty == difficulty,
        )
        .toList(growable: false);
  }
}
