import 'package:flutter_test/flutter_test.dart';

import 'package:avaliacao_pg_mobile_flutter_01/domain/enums/answer_category.dart';
import 'package:avaliacao_pg_mobile_flutter_01/domain/enums/difficulty.dart';
import 'package:avaliacao_pg_mobile_flutter_01/shared/presentation/enum_labels.dart';

void main() {
  group('AnswerCategoryLabel', () {
    test('should translate all categories to Portuguese', () {
      expect(AnswerCategory.animals.label, 'Animais');
      expect(AnswerCategory.humanBody.label, 'Corpo humano');
      expect(AnswerCategory.sports.label, 'Esportes');
      expect(AnswerCategory.technology.label, 'Tecnologia');
    });
  });

  group('DifficultyLabel', () {
    test('should translate all difficulties to Portuguese', () {
      expect(Difficulty.easy.label, 'Fácil');
      expect(Difficulty.medium.label, 'Médio');
      expect(Difficulty.hard.label, 'Difícil');
    });
  });
}
