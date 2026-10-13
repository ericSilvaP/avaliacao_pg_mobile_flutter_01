import 'package:avaliacao_pg_mobile_flutter_01/features/game/presentation/widgets/answer_board.dart';
import 'package:avaliacao_pg_mobile_flutter_01/shared/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child, {double width = 360}) {
  return MaterialApp(
    theme: AppTheme.dark(),
    home: Scaffold(
      body: Center(
        child: SizedBox(width: width, child: child),
      ),
    ),
  );
}

void main() {
  group('AnswerBoard', () {
    testWidgets('renders hidden slots for unrevealed letters', (tester) async {
      await tester.pumpWidget(
        _wrap(const AnswerBoard(displayedAnswer: '____')),
      );

      expect(find.byType(AnswerBoard), findsOneWidget);
      // No letter texts rendered when completely hidden
      expect(find.text('A'), findsNothing);
    });

    testWidgets('renders revealed letters preserving accents', (tester) async {
      await tester.pumpWidget(
        _wrap(const AnswerBoard(displayedAnswer: '_Ã_ DIREITA')),
      );

      expect(find.text('Ã'), findsOneWidget);
      expect(find.text('D'), findsOneWidget);
      expect(find.text('I'), findsNWidgets(2));
      expect(find.text('R'), findsOneWidget);
      expect(find.text('E'), findsOneWidget);
      expect(find.text('T'), findsOneWidget);
      expect(find.text('A'), findsOneWidget);
    });

    testWidgets('renders hyphens as structural separators', (tester) async {
      await tester.pumpWidget(
        _wrap(const AnswerBoard(displayedAnswer: '____-____')),
      );

      expect(find.text('-'), findsOneWidget);
    });

    testWidgets(
      'renders long complex answers on narrow 320dp width without overflow',
      (tester) async {
        final longAnswers = [
          'ARTICULAÇÃO TÊMPORO-MANDIBULAR',
          'CORRIDA COM OBSTÁCULOS',
          'CONTROLE DE VERSÃO',
          'QUATI SUL-AMERICANO',
        ];

        for (final answer in longAnswers) {
          await tester.pumpWidget(
            _wrap(AnswerBoard(displayedAnswer: answer), width: 320),
          );

          expect(tester.takeException(), isNull);
          expect(find.byType(AnswerBoard), findsOneWidget);
        }
      },
    );

    testWidgets('exposes accessible semantic description of answer', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();

      await tester.pumpWidget(_wrap(const AnswerBoard(displayedAnswer: '_-A')));

      final data = tester
          .getSemantics(find.byType(AnswerBoard))
          .getSemanticsData();
      expect(data.label, 'Palavra: letra oculta hífen A');

      semantics.dispose();
    });
  });
}
