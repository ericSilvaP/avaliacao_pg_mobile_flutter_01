import 'package:avaliacao_pg_mobile_flutter_01/features/game/presentation/widgets/keyboard_layout.dart';
import 'package:avaliacao_pg_mobile_flutter_01/features/game/presentation/widgets/letter_key.dart';
import 'package:avaliacao_pg_mobile_flutter_01/features/game/presentation/widgets/letter_keyboard.dart';
import 'package:avaliacao_pg_mobile_flutter_01/shared/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: AppTheme.dark(),
    home: Scaffold(
      body: Center(child: SizedBox(width: 380, child: child)),
    ),
  );
}

void main() {
  group('LetterKeyboard', () {
    testWidgets('renders all 26 letter keys with QWERTY as default', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          LetterKeyboard(
            guessedLetters: const {},
            wrongLetters: const {},
            onLetterPressed: (_) {},
          ),
        ),
      );

      expect(find.byType(LetterKey), findsNWidgets(26));
      expect(find.text('QWERTY'), findsOneWidget);
      expect(find.text('ABC'), findsOneWidget);

      final firstKey = tester.widget<LetterKey>(find.byType(LetterKey).first);
      expect(firstKey.letter, 'Q');
    });

    testWidgets('switches layout to ABC when segmented button is pressed', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          LetterKeyboard(
            guessedLetters: const {},
            wrongLetters: const {},
            onLetterPressed: (_) {},
          ),
        ),
      );

      await tester.tap(find.text('ABC'));
      await tester.pumpAndSettle();

      final firstKey = tester.widget<LetterKey>(find.byType(LetterKey).first);
      expect(firstKey.letter, 'A');
    });

    testWidgets('triggers onLetterPressed when an available key is tapped', (
      tester,
    ) async {
      String? pressedLetter;

      await tester.pumpWidget(
        _wrap(
          LetterKeyboard(
            guessedLetters: const {},
            wrongLetters: const {},
            onLetterPressed: (l) => pressedLetter = l,
          ),
        ),
      );

      await tester.tap(find.widgetWithText(LetterKey, 'A'));
      await tester.pump();

      expect(pressedLetter, 'A');
    });

    testWidgets('marks keys as hit and miss based on domain sets', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          LetterKeyboard(
            guessedLetters: const {'A', 'B'},
            wrongLetters: const {'B'},
            onLetterPressed: (_) {},
          ),
        ),
      );

      final keyA = tester.widget<LetterKey>(
        find.widgetWithText(LetterKey, 'A'),
      );
      expect(keyA.state, LetterKeyState.hit);

      final keyB = tester.widget<LetterKey>(
        find.widgetWithText(LetterKey, 'B'),
      );
      expect(keyB.state, LetterKeyState.miss);

      final keyC = tester.widget<LetterKey>(
        find.widgetWithText(LetterKey, 'C'),
      );
      expect(keyC.state, LetterKeyState.available);
    });

    testWidgets('disables remaining available keys when round is finished', (
      tester,
    ) async {
      String? pressed;

      await tester.pumpWidget(
        _wrap(
          LetterKeyboard(
            guessedLetters: const {'A'},
            wrongLetters: const {},
            isFinished: true,
            onLetterPressed: (l) => pressed = l,
          ),
        ),
      );

      final keyZ = tester.widget<LetterKey>(
        find.widgetWithText(LetterKey, 'Z'),
      );
      expect(keyZ.state, LetterKeyState.disabled);

      await tester.tap(find.widgetWithText(LetterKey, 'Z'));
      await tester.pump();

      expect(pressed, isNull);
    });

    testWidgets('respects controlled layout and notifies onLayoutChanged', (
      tester,
    ) async {
      KeyboardLayout? reportedLayout;

      await tester.pumpWidget(
        _wrap(
          LetterKeyboard(
            guessedLetters: const {},
            wrongLetters: const {},
            layout: KeyboardLayout.alphabetical,
            onLayoutChanged: (layout) => reportedLayout = layout,
            onLetterPressed: (_) {},
          ),
        ),
      );

      final firstKey = tester.widget<LetterKey>(find.byType(LetterKey).first);
      expect(firstKey.letter, 'A');

      await tester.tap(find.text('QWERTY'));
      await tester.pumpAndSettle();

      expect(reportedLayout, KeyboardLayout.qwerty);
    });

    testWidgets(
      'does not show check confirmation icon on the selected layout segment',
      (tester) async {
        await tester.pumpWidget(
          _wrap(
            LetterKeyboard(
              guessedLetters: const {},
              wrongLetters: const {},
              onLetterPressed: (_) {},
            ),
          ),
        );

        expect(find.byIcon(Icons.check), findsNothing);

        await tester.tap(find.text('ABC'));
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.check), findsNothing);
      },
    );

    testWidgets('layout selector buttons maintain static and equal size', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          LetterKeyboard(
            guessedLetters: const {},
            wrongLetters: const {},
            onLetterPressed: (_) {},
          ),
        ),
      );

      final segmentedSize = tester.getSize(
        find.byType(SegmentedButton<KeyboardLayout>),
      );
      expect(segmentedSize.width, equals(160.0));
      expect(segmentedSize.height, equals(32.0));

      final buttons = find.byType(TextButton);
      expect(buttons, findsNWidgets(2));

      final qwertyWidth1 = tester.getSize(buttons.first).width;
      final abcWidth1 = tester.getSize(buttons.last).width;
      expect(qwertyWidth1, equals(80.0));
      expect(abcWidth1, equals(80.0));

      // Switch to ABC
      await tester.tap(find.text('ABC'));
      await tester.pumpAndSettle();

      final qwertyWidth2 = tester.getSize(buttons.first).width;
      final abcWidth2 = tester.getSize(buttons.last).width;
      expect(qwertyWidth2, equals(qwertyWidth1));
      expect(abcWidth2, equals(abcWidth1));
      expect(qwertyWidth2, equals(abcWidth2));
    });

    testWidgets(
      'ABC layout keys have the exact same size as QWERTY layout keys',
      (tester) async {
        await tester.pumpWidget(
          _wrap(
            LetterKeyboard(
              guessedLetters: const {},
              wrongLetters: const {},
              layout: KeyboardLayout.qwerty,
              onLetterPressed: (_) {},
            ),
          ),
        );

        final qwertyKeySize = tester.getSize(
          find.widgetWithText(LetterKey, 'A'),
        );

        await tester.tap(find.text('ABC'));
        await tester.pumpAndSettle();

        final abcKeySize = tester.getSize(find.widgetWithText(LetterKey, 'A'));

        expect(abcKeySize.width, equals(qwertyKeySize.width));
        expect(abcKeySize.height, equals(qwertyKeySize.height));
      },
    );
  });
}
