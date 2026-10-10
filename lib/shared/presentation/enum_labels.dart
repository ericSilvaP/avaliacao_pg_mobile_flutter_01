import '../../domain/enums/answer_category.dart';
import '../../domain/enums/difficulty.dart';

extension AnswerCategoryLabel on AnswerCategory {
  String get label {
    return switch (this) {
      AnswerCategory.animals => 'Animais',
      AnswerCategory.humanBody => 'Corpo humano',
      AnswerCategory.sports => 'Esportes',
      AnswerCategory.technology => 'Tecnologia',
    };
  }
}

extension DifficultyLabel on Difficulty {
  String get label {
    return switch (this) {
      Difficulty.easy => 'Fácil',
      Difficulty.medium => 'Médio',
      Difficulty.hard => 'Difícil',
    };
  }
}
