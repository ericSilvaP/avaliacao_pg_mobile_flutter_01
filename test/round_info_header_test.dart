import 'package:avaliacao_pg_mobile_flutter_01/domain/enums/answer_category.dart';
import 'package:avaliacao_pg_mobile_flutter_01/domain/enums/difficulty.dart';
import 'package:avaliacao_pg_mobile_flutter_01/features/game/presentation/widgets/round_info_header.dart';
import 'package:avaliacao_pg_mobile_flutter_01/shared/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: AppTheme.dark(),
    home: Scaffold(
      body: Center(child: SizedBox(width: 360, child: child)),
    ),
  );
}

void main() {
  group('RoundInfoHeader', () {
    testWidgets('renders category and difficulty labels in Portuguese', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const RoundInfoHeader(
            category: AnswerCategory.animals,
            difficulty: Difficulty.easy,
          ),
        ),
      );

      expect(find.text('Categoria'), findsOneWidget);
      expect(find.text('Animais'), findsOneWidget);
      expect(find.text('Dificuldade'), findsOneWidget);
      expect(find.text('Fácil'), findsOneWidget);
      expect(find.byIcon(Icons.pets_rounded), findsOneWidget);
    });

    testWidgets('renders different category and difficulty properly', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const RoundInfoHeader(
            category: AnswerCategory.technology,
            difficulty: Difficulty.hard,
          ),
        ),
      );

      expect(find.text('Tecnologia'), findsOneWidget);
      expect(find.text('Difícil'), findsOneWidget);
      expect(find.byIcon(Icons.computer_rounded), findsOneWidget);
    });

    testWidgets('exposes proper accessibility semantics', (tester) async {
      final semantics = tester.ensureSemantics();

      await tester.pumpWidget(
        _wrap(
          const RoundInfoHeader(
            category: AnswerCategory.sports,
            difficulty: Difficulty.medium,
          ),
        ),
      );

      final data = tester
          .getSemantics(find.byType(RoundInfoHeader))
          .getSemanticsData();
      expect(data.label, 'Categoria: Esportes. Dificuldade: Médio.');

      semantics.dispose();
    });
  });
}
