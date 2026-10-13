import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:avaliacao_pg_mobile_flutter_01/app.dart';
import 'package:avaliacao_pg_mobile_flutter_01/data/models/answer_entry.dart';
import 'package:avaliacao_pg_mobile_flutter_01/data/repositories/answer_repository.dart';
import 'package:avaliacao_pg_mobile_flutter_01/domain/enums/answer_category.dart';
import 'package:avaliacao_pg_mobile_flutter_01/domain/enums/difficulty.dart';
import 'package:avaliacao_pg_mobile_flutter_01/features/about/about_screen.dart';
import 'package:avaliacao_pg_mobile_flutter_01/features/game/presentation/game_screen.dart';
import 'package:avaliacao_pg_mobile_flutter_01/features/game/presentation/widgets/letter_key.dart';
import 'package:avaliacao_pg_mobile_flutter_01/features/setup/setup_screen.dart';
import 'package:avaliacao_pg_mobile_flutter_01/src/domain/text_format.dart';

class FakeAnswerRepository implements AnswerRepository {
  FakeAnswerRepository(this.entries);

  final List<AnswerEntry> entries;

  @override
  Future<List<AnswerCategory>> getCategories() async {
    return entries.map((entry) => entry.category).toSet().toList();
  }

  @override
  Future<List<Difficulty>> getDifficulties(AnswerCategory category) async {
    return entries
        .where((entry) => entry.category == category)
        .map((entry) => entry.difficulty)
        .toSet()
        .toList();
  }

  @override
  Future<List<AnswerEntry>> findEntries({
    required AnswerCategory category,
    required Difficulty difficulty,
  }) async {
    return entries
        .where(
          (entry) =>
              entry.category == category && entry.difficulty == difficulty,
        )
        .toList();
  }
}

List<AnswerEntry> buildEntries(List<(String, String)> answers) {
  return [
    for (final (answer, hint) in answers)
      AnswerEntry(
        answer: answer,
        category: AnswerCategory.animals,
        difficulty: Difficulty.easy,
        hints: [hint],
      ),
  ];
}

Future<void> pumpApp(
  WidgetTester tester, {
  AnswerRepository? repository,
}) async {
  tester.view.physicalSize = const Size(800, 950);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    HangmanApp(
      repository:
          repository ??
          FakeAnswerRepository(
            buildEntries([
              ('COELHO', 'Mamífero de orelhas longas.'),
              ('GATO DOMÉSTICO', 'Felino criado como animal de companhia.'),
              ('URSO POLAR', 'Grande mamífero adaptado ao gelo.'),
            ]),
          ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> reveal(WidgetTester tester, Finder finder) async {
  final scrollable = find.byType(Scrollable);
  if (scrollable.evaluate().isNotEmpty) {
    await tester.scrollUntilVisible(finder, 200, scrollable: scrollable.last);
    await tester.pumpAndSettle();
  }
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
}

Future<void> choose<T>(WidgetTester tester, String label) async {
  await tester.pumpAndSettle();
  final dropdown = find.byType(DropdownButton<T>);
  await reveal(tester, dropdown);
  await tester.tap(dropdown);
  await tester.pumpAndSettle();
  await tester.tap(find.text(label).last);
  await tester.pumpAndSettle();
}

Future<void> startRound(WidgetTester tester) async {
  await reveal(tester, find.text('INICIAR RODADA'));
  await tester.tap(find.text('INICIAR RODADA'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Iniciar partida'));
  await tester.pumpAndSettle();
}

Future<void> tapGameLetter(WidgetTester tester, String letter) async {
  final finder = find.widgetWithText(LetterKey, letter);
  await tester.scrollUntilVisible(
    finder,
    150,
    scrollable: find.byType(Scrollable).last,
  );
  await tester.pumpAndSettle();
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pump();
}

Future<void> winRound(WidgetTester tester) async {
  final state = tester.state<GameScreenState>(find.byType(GameScreen));
  final answer = state.round.answer.answer;
  final letters = TextFormat.format(answer)
      .split('')
      .where(TextFormat.isPlayableLetter)
      .toSet();
  for (final l in letters) {
    await tapGameLetter(tester, l);
  }
  await tester.pump(const Duration(seconds: 2));
  await tester.pumpAndSettle();
}

Future<void> loseRound(WidgetTester tester) async {
  final state = tester.state<GameScreenState>(find.byType(GameScreen));
  final answer = state.round.answer.answer;
  final answerLetters = TextFormat.format(answer).split('').toSet();
  for (final l in 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('')) {
    if (state.round.isFinished) break;
    if (!answerLetters.contains(l)) {
      await tapGameLetter(tester, l);
    }
  }
  await tester.pump(const Duration(seconds: 2));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('opens the about screen from the setup screen', (tester) async {
    await pumpApp(tester);

    await reveal(tester, find.text('Sobre a equipe'));
    await tester.tap(find.text('Sobre a equipe'));
    await tester.pumpAndSettle();

    expect(find.byType(AboutScreen), findsOneWidget);
    expect(find.text('Eric Silva Patricio'), findsOneWidget);
  });

  testWidgets('starts a round from the setup screen', (tester) async {
    await pumpApp(tester);

    await choose<AnswerCategory>(tester, 'Animais');
    await choose<Difficulty>(tester, 'Fácil');
    await startRound(tester);

    expect(find.byType(GameScreen), findsOneWidget);
    expect(find.text('Animais'), findsOneWidget);
    expect(find.text('Fácil'), findsOneWidget);
  });

  testWidgets('registers a victory in the session statistics', (tester) async {
    await pumpApp(tester);

    await choose<AnswerCategory>(tester, 'Animais');
    await choose<Difficulty>(tester, 'Fácil');
    await startRound(tester);

    await winRound(tester);

    expect(find.text('Vitória!'), findsOneWidget);

    await reveal(tester, find.text('Ver estatísticas da sessão'));
    await tester.tap(find.text('Ver estatísticas da sessão'));
    await tester.pumpAndSettle();

    expect(find.text('Rodadas realizadas'), findsOneWidget);
    expect(find.text('1 vitória(s) · 0 derrota(s)'), findsOneWidget);
  });

  testWidgets('starts a new round after the result', (tester) async {
    await pumpApp(tester);

    await choose<AnswerCategory>(tester, 'Animais');
    await choose<Difficulty>(tester, 'Fácil');
    await startRound(tester);

    await winRound(tester);

    await reveal(tester, find.text('Jogar novamente'));
    await tester.tap(find.text('Jogar novamente'));
    await tester.pumpAndSettle();

    expect(find.byType(GameScreen), findsOneWidget);
    expect(find.text('Vitória!'), findsNothing);
  });

  testWidgets('returns to the setup screen after a defeat', (tester) async {
    await pumpApp(tester);

    await choose<AnswerCategory>(tester, 'Animais');
    await choose<Difficulty>(tester, 'Fácil');
    await startRound(tester);

    await loseRound(tester);

    expect(find.text('Derrota'), findsOneWidget);

    await reveal(tester, find.text('Trocar configuração'));
    await tester.tap(find.text('Trocar configuração'));
    await tester.pumpAndSettle();

    expect(find.byType(SetupScreen), findsOneWidget);
    expect(find.byType(GameScreen), findsNothing);
  });

  testWidgets('informs when every answer of a combination was used', (
    tester,
  ) async {
    final repository = FakeAnswerRepository(
      buildEntries([('COELHO', 'Mamífero de orelhas longas.')]),
    );

    await pumpApp(tester, repository: repository);

    await choose<AnswerCategory>(tester, 'Animais');
    await choose<Difficulty>(tester, 'Fácil');
    await startRound(tester);

    await loseRound(tester);

    await reveal(tester, find.text('Jogar novamente'));
    await tester.tap(find.text('Jogar novamente'));
    await tester.pumpAndSettle();

    expect(find.text('Rodada indisponível'), findsOneWidget);
    expect(find.textContaining('já foram usadas nesta sessão'), findsOneWidget);
  });

  testWidgets('keeps the session statistics across rounds', (tester) async {
    final repository = FakeAnswerRepository(
      buildEntries([
        ('COELHO', 'Mamífero de orelhas longas.'),
        ('GATO DOMÉSTICO', 'Felino criado como animal de companhia.'),
      ]),
    );

    await pumpApp(tester, repository: repository);

    await choose<AnswerCategory>(tester, 'Animais');
    await choose<Difficulty>(tester, 'Fácil');
    await startRound(tester);

    await winRound(tester);

    await reveal(tester, find.text('Jogar novamente'));
    await tester.tap(find.text('Jogar novamente'));
    await tester.pumpAndSettle();

    await loseRound(tester);

    await reveal(tester, find.text('Ver estatísticas da sessão'));
    await tester.tap(find.text('Ver estatísticas da sessão'));
    await tester.pumpAndSettle();

    expect(find.text('Rodadas realizadas'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('1 vitória(s) · 1 derrota(s)'), findsOneWidget);
    expect(find.text('50,0%'), findsNWidgets(2));
  });
}
