import 'package:avaliacao_pg_mobile_flutter_01/features/game/presentation/widgets/game_status_slot.dart';
import 'package:avaliacao_pg_mobile_flutter_01/features/game/presentation/widgets/hint_panel.dart';
import 'package:avaliacao_pg_mobile_flutter_01/features/game/presentation/widgets/round_outcome_banner.dart';
import 'package:avaliacao_pg_mobile_flutter_01/shared/theme/app_theme.dart';
import 'package:avaliacao_pg_mobile_flutter_01/src/domain/round_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: AppTheme.dark(),
    home: Scaffold(
      body: Center(child: SizedBox(width: 400, child: child)),
    ),
  );
}

void main() {
  group('GameStatusSlot', () {
    testWidgets('renders hint button when in progress and hint not used', (
      tester,
    ) async {
      var requested = false;

      await tester.pumpWidget(
        _wrap(
          GameStatusSlot(
            status: RoundStatus.inProgress,
            hintUsed: false,
            onHintRequested: () => requested = true,
          ),
        ),
      );

      expect(find.byType(HintPanel), findsOneWidget);
      expect(find.text('Pedir dica'), findsOneWidget);
      expect(find.byType(RoundOutcomeBanner), findsNothing);

      await tester.tap(find.text('Pedir dica'));
      await tester.pump();
      expect(requested, isTrue);

      final size = tester.getSize(find.byType(GameStatusSlot));
      expect(size.height, greaterThanOrEqualTo(76.0));
    });

    testWidgets('renders hint card when in progress and hint is used', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const GameStatusSlot(
            status: RoundStatus.inProgress,
            hintUsed: true,
            hint: 'Mamífero aquático',
          ),
        ),
      );

      expect(find.byType(HintPanel), findsOneWidget);
      expect(find.text('Mamífero aquático'), findsOneWidget);
      expect(find.byType(RoundOutcomeBanner), findsNothing);

      final size = tester.getSize(find.byType(GameStatusSlot));
      expect(size.height, greaterThanOrEqualTo(76.0));
    });

    testWidgets('renders RoundOutcomeBanner with victory when status is won', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const GameStatusSlot(
            status: RoundStatus.won,
            hintUsed: true,
            hint: 'Mamífero aquático',
          ),
        ),
      );

      expect(find.byType(RoundOutcomeBanner), findsOneWidget);
      expect(find.text('Vitória!'), findsOneWidget);

      final size = tester.getSize(find.byType(GameStatusSlot));
      expect(size.height, greaterThanOrEqualTo(76.0));
    });

    testWidgets('renders RoundOutcomeBanner with defeat when status is lost', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(const GameStatusSlot(status: RoundStatus.lost, hintUsed: false)),
      );

      expect(find.byType(RoundOutcomeBanner), findsOneWidget);
      expect(find.text('Derrota'), findsOneWidget);

      final size = tester.getSize(find.byType(GameStatusSlot));
      expect(size.height, greaterThanOrEqualTo(76.0));
    });

    testWidgets('smoothly transitions between in progress and finished state', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const GameStatusSlot(status: RoundStatus.inProgress, hintUsed: false),
        ),
      );

      expect(find.text('Pedir dica'), findsOneWidget);

      await tester.pumpWidget(
        _wrap(const GameStatusSlot(status: RoundStatus.won, hintUsed: false)),
      );

      await tester.pumpAndSettle();
      expect(find.text('Vitória!'), findsOneWidget);
      expect(find.text('Pedir dica'), findsNothing);
    });
  });
}
