import 'package:flutter_test/flutter_test.dart';
import 'package:avaliacao_pg_mobile_flutter_01/data/models/answer_entry.dart';
import 'package:avaliacao_pg_mobile_flutter_01/domain/enums/answer_category.dart';
import 'package:avaliacao_pg_mobile_flutter_01/domain/enums/difficulty.dart';

void main() {
  group('AnswerEntry.fromJson', () {
    test('should deserialize a valid entry', () {
      final json = {
        'answer': 'MÃO DIREITA',
        'category': 'humanBody',
        'difficulty': 'easy',
        'hints': ['Parte do membro superior com cinco dedos.'],
      };

      final entry = AnswerEntry.fromJson(json);

      expect(entry.answer, 'MÃO DIREITA');
      expect(entry.category, AnswerCategory.humanBody);
      expect(entry.difficulty, Difficulty.easy);
      expect(entry.hints.length, 1);
    });

    test('should preserve hyphens and accents', () {
      final json = {
        'answer': 'ARTICULAÇÃO TÊMPORO-MANDIBULAR',
        'category': 'humanBody',
        'difficulty': 'hard',
        'hints': ['Articulação da mandíbula.'],
      };

      final entry = AnswerEntry.fromJson(json);

      expect(entry.answer, 'ARTICULAÇÃO TÊMPORO-MANDIBULAR');
    });

    test('should reject an unknown category', () {
      final json = {
        'answer': 'TESTE',
        'category': 'unknown',
        'difficulty': 'easy',
        'hints': ['Dica de teste'],
      };

      expect(() => AnswerEntry.fromJson(json), throwsFormatException);
    });

    test('should reject an unknown difficulty', () {
      final json = {
        'answer': 'TESTE',
        'category': 'technology',
        'difficulty': 'unknown',
        'hints': ['Dica de teste'],
      };

      expect(() => AnswerEntry.fromJson(json), throwsFormatException);
    });
  });
}
