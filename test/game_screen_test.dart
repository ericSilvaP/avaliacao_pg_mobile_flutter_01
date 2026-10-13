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
import 'package:avaliacao_pg_mobile_flutter_01/features/game/presentation/widgets/round_outcome_banner.dart';
import 'package:avaliacao_pg_mobile_flutter_01/shared/theme/app_theme.dart';
import 'package:avaliacao_pg_mobile_flutter_01/src/domain/round_result.dart';
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

    testWidgets(
      'plays a full winning round via letter taps and auto-advances after delay',
      (tester) async {
        tester.view.physicalSize = const Size(500, 950);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        RoundResult? finishedResult;

        await tester.pumpWidget(
          _wrap(
            GameScreen(
              entry: _sampleEntry(answer: 'PAO'),
              category: AnswerCategory.animals,
              difficulty: Difficulty.easy,
              onRoundFinished: (result) => finishedResult = result,
            ),
          ),
        );

        final state = tester.state<GameScreenState>(find.byType(GameScreen));
        expect(state.round.status, RoundStatus.inProgress);

        // Guess 'P'
        await _tapKey(tester, 'P');
        expect(find.text('P'), findsNWidgets(2));

        // Guess 'A'
        await _tapKey(tester, 'A');
        expect(find.text('A'), findsNWidgets(2));

        // Guess 'O'
        await _tapKey(tester, 'O');
        expect(find.text('O'), findsNWidgets(2));

        expect(state.round.status, RoundStatus.won);
        expect(state.round.isFinished, isTrue);

        // Outcome banner is shown immediately
        expect(find.byType(RoundOutcomeBanner), findsOneWidget);
        expect(find.text('Vitória!'), findsOneWidget);

        // All remaining keys are disabled after win
        final keyZ = tester.widget<LetterKey>(
          find.widgetWithText(LetterKey, 'Z'),
        );
        expect(keyZ.state, LetterKeyState.disabled);

        // onRoundFinished is NOT called immediately
        expect(finishedResult, isNull);

        // Advances after the 2-second delay
        await tester.pump(const Duration(seconds: 2));
        expect(finishedResult, isNotNull);
        expect(finishedResult!.isVictory, isTrue);
      },
    );

    testWidgets(
      'commits errors, shows defeat banner, and auto-advances after delay',
      (tester) async {
        tester.view.physicalSize = const Size(500, 950);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        RoundResult? finishedResult;

        await tester.pumpWidget(
          _wrap(
            GameScreen(
              entry: _sampleEntry(answer: 'SOL'),
              category: AnswerCategory.technology,
              difficulty: Difficulty.medium,
              onRoundFinished: (result) => finishedResult = result,
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

        // Outcome banner is shown immediately
        expect(find.byType(RoundOutcomeBanner), findsOneWidget);
        expect(find.text('Derrota'), findsOneWidget);

        // Callback not called yet
        expect(finishedResult, isNull);

        // Advances after the 2-second delay
        await tester.pump(const Duration(seconds: 2));
        expect(finishedResult, isNotNull);
        expect(finishedResult!.isVictory, isFalse);
      },
    );

    testWidgets(
      'cancels finish timer and does not call onRoundFinished if screen is disposed early',
      (tester) async {
        tester.view.physicalSize = const Size(500, 950);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        RoundResult? finishedResult;

        await tester.pumpWidget(
          _wrap(
            GameScreen(
              entry: _sampleEntry(answer: 'A'),
              category: AnswerCategory.animals,
              difficulty: Difficulty.easy,
              onRoundFinished: (result) => finishedResult = result,
            ),
          ),
        );

        // Guess 'A' to win
        await _tapKey(tester, 'A');
        expect(find.text('Vitória!'), findsOneWidget);
        expect(finishedResult, isNull);

        // Dispose screen before 2-second timer elapses
        await tester.pumpWidget(const SizedBox());

        // Advance clock well past the timer
        await tester.pump(const Duration(seconds: 3));

        // Callback must never be called
        expect(finishedResult, isNull);
      },
    );

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

    testWidgets(
      'switches between narrow and wide layout based on 600dp breakpoint',
      (tester) async {
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        // Narrow (< 600)
        tester.view.physicalSize = const Size(599, 800);
        tester.view.devicePixelRatio = 1.0;

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

        expect(find.byKey(const Key('game-narrow-layout')), findsOneWidget);
        expect(find.byKey(const Key('game-wide-layout')), findsNothing);

        // Wide (>= 600)
        tester.view.physicalSize = const Size(600, 800);
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('game-wide-layout')), findsOneWidget);
        expect(find.byKey(const Key('game-narrow-layout')), findsNothing);
      },
    );

    testWidgets('plays round in wide layout via letter taps', (tester) async {
      tester.view.physicalSize = const Size(800, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        _wrap(
          GameScreen(
            entry: _sampleEntry(answer: 'RIO'),
            category: AnswerCategory.technology,
            difficulty: Difficulty.easy,
            onRoundFinished: (_) {},
          ),
        ),
      );

      expect(find.byKey(const Key('game-wide-layout')), findsOneWidget);
      expect(find.byType(HangmanFigure), findsOneWidget);
      expect(find.byType(ErrorProgress), findsOneWidget);
      expect(find.byType(RoundInfoHeader), findsOneWidget);
      expect(find.byType(AnswerBoard), findsOneWidget);
      expect(find.byType(LetterKeyboard), findsOneWidget);

      await _tapKey(tester, 'R');
      expect(find.text('R'), findsNWidgets(2));
    });

    testWidgets(
      'supports 320dp width with 1.5x text scale for all required plan answers without overflow',
      (tester) async {
        tester.view.physicalSize = const Size(320, 640);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final testAnswers = [
          'ARTICULAÇÃO TÊMPORO-MANDIBULAR',
          'CORRIDA COM OBSTÁCULOS',
          'CONTROLE DE VERSÃO',
          'QUATI SUL-AMERICANO',
        ];

        for (final answer in testAnswers) {
          await tester.pumpWidget(
            MaterialApp(
              theme: AppTheme.dark(),
              home: MediaQuery(
                data: const MediaQueryData(
                  size: Size(320, 640),
                  textScaler: TextScaler.linear(1.5),
                ),
                child: GameScreen(
                  entry: _sampleEntry(answer: answer),
                  category: AnswerCategory.animals,
                  difficulty: Difficulty.hard,
                  onRoundFinished: (_) {},
                ),
              ),
            ),
          );

          expect(
            tester.takeException(),
            isNull,
            reason: 'Overflow or error on $answer',
          );
          expect(find.byKey(const Key('game-narrow-layout')), findsOneWidget);
        }
      },
    );
  });
}
