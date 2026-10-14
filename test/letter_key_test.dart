import 'dart:ui' show Tristate;

import 'package:avaliacao_pg_mobile_flutter_01/features/game/presentation/widgets/letter_key.dart';
import 'package:avaliacao_pg_mobile_flutter_01/shared/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: AppTheme.dark(),
    home: Scaffold(body: Center(child: child)),
  );
}

void main() {
  group('LetterKey', () {
    testWidgets('displays the letter text', (tester) async {
      await tester.pumpWidget(_wrap(const LetterKey(letter: 'A')));

      expect(find.text('A'), findsOneWidget);
    });

    testWidgets('triggers callback when available and tapped', (tester) async {
      var pressed = false;

      await tester.pumpWidget(
        _wrap(
          LetterKey(
            letter: 'B',
            state: LetterKeyState.available,
            onPressed: () => pressed = true,
          ),
        ),
      );

      await tester.tap(find.byType(LetterKey));
      await tester.pump();

      expect(pressed, isTrue);
    });

    testWidgets('does not trigger callback when hit', (tester) async {
      var pressed = false;

      await tester.pumpWidget(
        _wrap(
          LetterKey(
            letter: 'C',
            state: LetterKeyState.hit,
            onPressed: () => pressed = true,
          ),
        ),
      );

      await tester.tap(find.byType(LetterKey));
      await tester.pump();

      expect(pressed, isFalse);
    });

    testWidgets('does not trigger callback when miss', (tester) async {
      var pressed = false;

      await tester.pumpWidget(
        _wrap(
          LetterKey(
            letter: 'D',
            state: LetterKeyState.miss,
            onPressed: () => pressed = true,
          ),
        ),
      );

      await tester.tap(find.byType(LetterKey));
      await tester.pump();

      expect(pressed, isFalse);
    });

    testWidgets('does not trigger callback when disabled', (tester) async {
      var pressed = false;

      await tester.pumpWidget(
        _wrap(
          LetterKey(
            letter: 'E',
            state: LetterKeyState.disabled,
            onPressed: () => pressed = true,
          ),
        ),
      );

      await tester.tap(find.byType(LetterKey));
      await tester.pump();

      expect(pressed, isFalse);
    });

    testWidgets('exposes proper semantics for available state', (tester) async {
      final semantics = tester.ensureSemantics();

      await tester.pumpWidget(
        _wrap(
          LetterKey(
            letter: 'F',
            state: LetterKeyState.available,
            onPressed: () {},
          ),
        ),
      );

      final data = tester
          .getSemantics(find.byType(LetterKey))
          .getSemanticsData();
      expect(data.label, 'Letra F');
      expect(data.flagsCollection.isButton, isTrue);
      expect(data.flagsCollection.isEnabled, Tristate.isTrue);

      semantics.dispose();
    });

    testWidgets('exposes proper semantics for hit state', (tester) async {
      final semantics = tester.ensureSemantics();

      await tester.pumpWidget(
        _wrap(
          LetterKey(letter: 'G', state: LetterKeyState.hit, onPressed: () {}),
        ),
      );

      final data = tester
          .getSemantics(find.byType(LetterKey))
          .getSemanticsData();
      expect(data.label, 'Letra G, correta');
      expect(data.flagsCollection.isButton, isFalse);
      expect(data.flagsCollection.isEnabled, Tristate.isFalse);

      semantics.dispose();
    });

    testWidgets('exposes proper semantics for miss state', (tester) async {
      final semantics = tester.ensureSemantics();

      await tester.pumpWidget(
        _wrap(
          LetterKey(letter: 'H', state: LetterKeyState.miss, onPressed: () {}),
        ),
      );

      final data = tester
          .getSemantics(find.byType(LetterKey))
          .getSemanticsData();
      expect(data.label, 'Letra H, incorreta');
      expect(data.flagsCollection.isButton, isFalse);
      expect(data.flagsCollection.isEnabled, Tristate.isFalse);

      semantics.dispose();
    });

    testWidgets('exposes proper semantics for disabled state', (tester) async {
      final semantics = tester.ensureSemantics();

      await tester.pumpWidget(
        _wrap(const LetterKey(letter: 'I', state: LetterKeyState.disabled)),
      );

      final data = tester
          .getSemantics(find.byType(LetterKey))
          .getSemanticsData();
      expect(data.label, 'Letra I, desabilitada');
      expect(data.flagsCollection.isButton, isFalse);
      expect(data.flagsCollection.isEnabled, Tristate.isFalse);

      semantics.dispose();
    });
  });
}
