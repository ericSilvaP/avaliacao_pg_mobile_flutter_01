import 'package:avaliacao_pg_mobile_flutter_01/features/game/presentation/widgets/hint_panel.dart';
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
  group('HintPanel', () {
    testWidgets('renders request button when hint has not been used', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(const HintPanel(hintUsed: false)));

      expect(find.text('Pedir dica'), findsOneWidget);
      expect(find.byIcon(Icons.lightbulb_outline_rounded), findsOneWidget);
    });

    testWidgets('triggers onHintRequested when button is tapped', (
      tester,
    ) async {
      var requested = false;

      await tester.pumpWidget(
        _wrap(
          HintPanel(hintUsed: false, onHintRequested: () => requested = true),
        ),
      );

      await tester.tap(find.text('Pedir dica'));
      await tester.pump();

      expect(requested, isTrue);
    });

    testWidgets('disables button when round is finished', (tester) async {
      var requested = false;

      await tester.pumpWidget(
        _wrap(
          HintPanel(
            hintUsed: false,
            isFinished: true,
            onHintRequested: () => requested = true,
          ),
        ),
      );

      final button = tester.widget<OutlinedButton>(find.byType(OutlinedButton));
      expect(button.onPressed, isNull);

      await tester.tap(find.byType(OutlinedButton));
      await tester.pump();

      expect(requested, isFalse);
    });

    testWidgets('renders hint text and badge when hintUsed is true', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const HintPanel(
            hintUsed: true,
            hint: 'Componente do esqueleto humano',
          ),
        ),
      );

      expect(find.text('Pedir dica'), findsNothing);
      expect(find.text('Dica'), findsOneWidget);
      expect(find.text('Dica utilizada'), findsOneWidget);
      expect(find.text('Componente do esqueleto humano'), findsOneWidget);
      expect(find.byIcon(Icons.lightbulb_rounded), findsOneWidget);
    });

    testWidgets(
      'renders fallback text when hint is empty and hintUsed is true',
      (tester) async {
        await tester.pumpWidget(
          _wrap(const HintPanel(hintUsed: true, hint: '')),
        );

        expect(
          find.text('Nenhuma dica disponível para esta rodada.'),
          findsOneWidget,
        );
      },
    );

    testWidgets('exposes accessible semantics for revealed hint', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();

      await tester.pumpWidget(
        _wrap(const HintPanel(hintUsed: true, hint: 'Mamífero com espinhos')),
      );

      final data = tester
          .getSemantics(find.byType(HintPanel))
          .getSemanticsData();
      expect(data.label, 'Dica da rodada: Mamífero com espinhos');

      semantics.dispose();
    });
  });
}
