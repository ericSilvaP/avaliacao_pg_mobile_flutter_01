import 'package:flutter_test/flutter_test.dart';

import 'package:avaliacao_pg_mobile_flutter_01/data/repositories/answer_repository.dart';
import 'package:avaliacao_pg_mobile_flutter_01/data/repositories/local_answer_repository.dart';
import 'package:avaliacao_pg_mobile_flutter_01/data/sources/answer_local_data_source.dart';
import 'package:avaliacao_pg_mobile_flutter_01/domain/enums/answer_category.dart';
import 'package:avaliacao_pg_mobile_flutter_01/domain/enums/difficulty.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AnswerRepository repository;

  setUp(() {
    repository = LocalAnswerRepository(AnswerLocalDataSource());
  });

  group('AnswerRepository', () {
    test('should return available categories', () async {
      final categories = await repository.getCategories();

      expect(categories, containsAll(AnswerCategory.values));
      expect(categories.length, AnswerCategory.values.length);
    });

    test('should return available difficulties', () async {
      final difficulties = await repository.getDifficulties(
        AnswerCategory.technology,
      );

      expect(difficulties, containsAll(Difficulty.values));
    });

    test('should filter entries by category and difficulty', () async {
      final entries = await repository.findEntries(
        category: AnswerCategory.technology,
        difficulty: Difficulty.medium,
      );

      expect(entries, isNotEmpty);

      for (final entry in entries) {
        expect(entry.category, AnswerCategory.technology);
        expect(entry.difficulty, Difficulty.medium);
      }

      expect(
        entries.any((entry) => entry.answer == 'CLIENTE-SERVIDOR'),
        isTrue,
      );
    });

    test('should correctly filter all combinations', () async {
      for (final category in AnswerCategory.values) {
        for (final difficulty in Difficulty.values) {
          final entries = await repository.findEntries(
            category: category,
            difficulty: difficulty,
          );

          expect(entries, isNotEmpty);

          expect(
            entries.every(
              (entry) =>
                  entry.category == category && entry.difficulty == difficulty,
            ),
            isTrue,
          );
        }
      }
    });

    test('should return an unmodifiable list', () async {
      final entries = await repository.findEntries(
        category: AnswerCategory.animals,
        difficulty: Difficulty.easy,
      );

      expect(() => entries.clear(), throwsUnsupportedError);
    });
  });
}
