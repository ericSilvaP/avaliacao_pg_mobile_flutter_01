import 'package:flutter_test/flutter_test.dart';

import 'package:avaliacao_pg_mobile_flutter_01/data/sources/answer_local_data_source.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AnswerLocalDataSource', () {
    test('should load entries from local JSON', () async {
      final dataSource = AnswerLocalDataSource();

      final entries = await dataSource.loadEntries();

      expect(entries, isNotEmpty);
    });

    test('should preserve complex answers', () async {
      final dataSource = AnswerLocalDataSource();

      final entries = await dataSource.loadEntries();

      final expectedAnswers = [
        'MÃO DIREITA',
        'CLIENTE-SERVIDOR',
        'ARTICULAÇÃO TÊMPORO-MANDIBULAR',
        'CORRIDA COM OBSTÁCULOS',
      ];

      for (final answer in expectedAnswers) {
        expect(
          entries.any((entry) => entry.answer == answer),
          isTrue,
          reason: 'Answer not found: $answer',
        );
      }
    });
  });
}
