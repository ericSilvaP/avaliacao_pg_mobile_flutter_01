import 'package:avaliacao_pg_mobile_flutter_01/features/game/presentation/widgets/round_outcome_banner.dart';
import 'package:avaliacao_pg_mobile_flutter_01/shared/theme/app_colors.dart';
import 'package:avaliacao_pg_mobile_flutter_01/shared/theme/app_theme.dart';
import 'package:avaliacao_pg_mobile_flutter_01/domain/round_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: AppTheme.dark(),
    home: Scaffold(body: child),
  );
}

void main() {
  group('RoundOutcomeBanner', () {
    testWidgets('renders nothing when round is inProgress', (tester) async {
      await tester.pumpWidget(
        _wrap(const RoundOutcomeBanner(status: RoundStatus.inProgress)),
      );

      expect(find.byType(Card), findsNothing);
      expect(find.text('Vitória!'), findsNothing);
      expect(find.text('Derrota'), findsNothing);
    });

    testWidgets('renders victory banner with appropriate texts and icon', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(const RoundOutcomeBanner(status: RoundStatus.won)),
      );

      expect(find.byType(Card), findsOneWidget);
      expect(find.text('Vitória!'), findsOneWidget);
      expect(find.text('Você descobriu a palavra!'), findsOneWidget);
      expect(find.byIcon(Icons.emoji_events_rounded), findsOneWidget);

      final titleText = tester.widget<Text>(find.text('Vitória!'));
      expect(titleText.style?.color, AppColors.accent);
    });

    testWidgets('renders defeat banner with appropriate texts and icon', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(const RoundOutcomeBanner(status: RoundStatus.lost)),
      );

      expect(find.byType(Card), findsOneWidget);
      expect(find.text('Derrota'), findsOneWidget);
      expect(find.text('O limite de erros foi atingido.'), findsOneWidget);
      expect(find.byIcon(Icons.sentiment_dissatisfied_rounded), findsOneWidget);

      final titleText = tester.widget<Text>(find.text('Derrota'));
      expect(titleText.style?.color, AppColors.error);
    });

    testWidgets('exposes liveRegion and accessibility semantics', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        _wrap(const RoundOutcomeBanner(status: RoundStatus.won)),
      );

      expect(
        find.bySemanticsLabel(
          'Resultado da rodada: Vitória!. Você descobriu a palavra!',
        ),
        findsOneWidget,
      );

      handle.dispose();
    });
  });
}
