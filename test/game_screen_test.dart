import 'package:avaliacao_pg_mobile_flutter_01/data/models/answer_entry.dart';
import 'package:avaliacao_pg_mobile_flutter_01/domain/enums/answer_category.dart';
import 'package:avaliacao_pg_mobile_flutter_01/domain/enums/difficulty.dart';
import 'package:avaliacao_pg_mobile_flutter_01/features/game/presentation/game_screen.dart';
import 'package:avaliacao_pg_mobile_flutter_01/features/game/presentation/widgets/answer_board.dart';
import 'package:avaliacao_pg_mobile_flutter_01/features/game/presentation/widgets/error_progress.dart';
import 'package:avaliacao_pg_mobile_flutter_01/features/game/presentation/widgets/hangman_figure.dart';
import 'package:avaliacao_pg_mobile_flutter_01/features/game/presentation/widgets/hint_panel.dart';
import 'package:avaliacao_pg_mobile_flutter_01/features/game/presentation/widgets/letter_key.dart';
import 'package:avaliacao_pg_mobile_flutter_01/features/game/presentation/widgets/letter_keyboard.dart';
import 'package:avaliacao_pg_mobile_flutter_01/features/game/presentation/widgets/round_info_header.dart';
import 'package:avaliacao_pg_mobile_flutter_01/shared/theme/app_theme.dart';
import 'package:avaliacao_pg_mobile_flutter_01/src/domain/round_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) {
  return MaterialApp(theme: AppTheme.dark(), home: child);
}

AnswerEntry _sampleEntry({
  String answer = 'GATO',
  List<String> hints = const ['Animal de estimação felino'],
}) {
  return AnswerEntry(
    answer: answer,
    category: AnswerCategory.animals,
    difficulty: Difficulty.easy,
    hints: hints,
  );
}

Future<void> _tapKey(WidgetTester tester, String letter) async {
  final finder = find.widgetWithText(LetterKey, letter);
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pump();
}

void main() {
  group('GameScreen', () {
    testWidgets('renders all initial game widgets and round info', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          GameScreen(
            entry: _sampleEntry(),
            category: AnswerCategory.animals,
            difficulty: Difficulty.easy,
            onRoundFinished: (_) {},
          ),
        ),
      );

      expect(find.byType(RoundInfoHeader), findsOneWidget);
      expect(find.byType(HangmanFigure), findsOneWidget);
      expect(find.byType(ErrorProgress), findsOneWidget);
      expect(find.byType(AnswerBoard), findsOneWidget);
      expect(find.byType(HintPanel), findsOneWidget);
      expect(find.byType(LetterKeyboard), findsOneWidget);

      expect(find.text('Animais'), findsOneWidget);
      expect(find.text('Fácil'), findsOneWidget);
      expect(find.text('0 de 6'), findsOneWidget);
      expect(find.text('Pedir dica'), findsOneWidget);
    });

    testWidgets('plays a full winning round via letter taps', (tester) async {
      tester.view.physicalSize = const Size(500, 950);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        _wrap(
          GameScreen(
            entry: _sampleEntry(answer: 'PAO'),
            category: AnswerCategory.animals,
            difficulty: Difficulty.easy,
            onRoundFinished: (_) {},
          ),
        ),
      );

      final state = tester.state<GameScreenState>(find.byType(GameScreen));
      expect(state.round.status, RoundStatus.inProgress);

      // Guess 'P'
      await _tapKey(tester, 'P');
      expect(
        find.text('P'),
        findsNWidgets(2),
      ); // Keyboard key + AnswerBoard slot

      // Guess 'A'
      await _tapKey(tester, 'A');
      expect(find.text('A'), findsNWidgets(2));

      // Guess 'O'
      await _tapKey(tester, 'O');
      expect(find.text('O'), findsNWidgets(2));

      expect(state.round.status, RoundStatus.won);
      expect(state.round.isFinished, isTrue);

      // All remaining keys are disabled after win
      final keyZ = tester.widget<LetterKey>(
        find.widgetWithText(LetterKey, 'Z'),
      );
      expect(keyZ.state, LetterKeyState.disabled);
    });

    testWidgets('commits errors and reaches defeat after 6 wrong letters', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(500, 950);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        _wrap(
          GameScreen(
            entry: _sampleEntry(answer: 'SOL'),
            category: AnswerCategory.technology,
            difficulty: Difficulty.medium,
            onRoundFinished: (_) {},
          ),
        ),
      );

      final state = tester.state<GameScreenState>(find.byType(GameScreen));

      final wrongLetters = ['A', 'B', 'C', 'D', 'E', 'F'];
      for (var i = 0; i < wrongLetters.length; i++) {
        await _tapKey(tester, wrongLetters[i]);

        expect(state.round.currentErrors, i + 1);
        expect(find.text('${i + 1} de 6'), findsOneWidget);
      }

      expect(state.round.status, RoundStatus.lost);
      expect(state.round.isFinished, isTrue);

      // Figure now shows defeat (dead head)
      final figure = tester.widget<HangmanFigure>(find.byType(HangmanFigure));
      expect(figure.status, RoundStatus.lost);
      expect(figure.errors, 6);
    });

    testWidgets('requests hint and displays hint content', (tester) async {
      await tester.pumpWidget(
        _wrap(
          GameScreen(
            entry: _sampleEntry(hints: ['Dica secreta do jogo']),
            category: AnswerCategory.animals,
            difficulty: Difficulty.easy,
            onRoundFinished: (_) {},
          ),
        ),
      );

      expect(find.text('Pedir dica'), findsOneWidget);
      expect(find.text('Dica secreta do jogo'), findsNothing);

      await tester.tap(find.text('Pedir dica'));
      await tester.pump();

      expect(find.text('Pedir dica'), findsNothing);
      expect(find.text('Dica secreta do jogo'), findsOneWidget);
      expect(find.text('Dica utilizada'), findsOneWidget);
    });

    testWidgets('confirms abandoning round with dialog', (tester) async {
      var popped = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.dark(),
          home: Navigator(
            pages: [
              MaterialPage(
                child: Builder(
                  builder: (context) => ElevatedButton(
                    onPressed: () {
                      Navigator.of(context)
                          .push(
                            MaterialPageRoute<void>(
                              builder: (_) => GameScreen(
                                entry: _sampleEntry(),
                                category: AnswerCategory.animals,
                                difficulty: Difficulty.easy,
                                onRoundFinished: (_) {},
                              ),
                            ),
                          )
                          .then((_) => popped = true);
                    },
                    child: const Text('Abrir'),
                  ),
                ),
              ),
            ],
            onDidRemovePage: (_) {},
          ),
        ),
      );

      await tester.tap(find.text('Abrir'));
      await tester.pumpAndSettle();

      // Tap close button in AppBar
      await tester.tap(find.byTooltip('Abandonar rodada'));
      await tester.pumpAndSettle();

      expect(find.text('Abandonar rodada?'), findsOneWidget);

      // Cancel
      await tester.tap(find.text('Continuar jogando'));
      await tester.pumpAndSettle();

      expect(find.text('Abandonar rodada?'), findsNothing);
      expect(find.byType(GameScreen), findsOneWidget);
      expect(popped, isFalse);

      // Tap again and confirm
      await tester.tap(find.byTooltip('Abandonar rodada'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Abandonar'));
      await tester.pumpAndSettle();

      expect(popped, isTrue);
    });
  });
}
