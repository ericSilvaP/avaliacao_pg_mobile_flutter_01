import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:avaliacao_pg_mobile_flutter_01/data/models/answer_entry.dart';
import 'package:avaliacao_pg_mobile_flutter_01/domain/enums/answer_category.dart';
import 'package:avaliacao_pg_mobile_flutter_01/domain/enums/difficulty.dart';
import 'package:avaliacao_pg_mobile_flutter_01/features/session/session_statistics.dart';
import 'package:avaliacao_pg_mobile_flutter_01/features/statistics/statistics_screen.dart';
import 'package:avaliacao_pg_mobile_flutter_01/shared/theme/app_theme.dart';
import 'package:avaliacao_pg_mobile_flutter_01/domain/round_result.dart';
import 'package:avaliacao_pg_mobile_flutter_01/domain/round_status.dart';

RoundResult buildResult({
  bool victory = true,
  int errorCount = 0,
  bool hintUsed = false,
}) {
  return RoundResult(
    answerEntry: AnswerEntry(
      answer: 'COELHO',
      category: AnswerCategory.animals,
      difficulty: Difficulty.easy,
      hints: const ['Mamífero de orelhas longas.'],
    ),
    status: victory ? RoundStatus.won : RoundStatus.lost,
    errorCount: errorCount,
    hintUsed: hintUsed,
  );
}

Future<void> pumpStatistics(
  WidgetTester tester,
  SessionStatistics statistics, {
  double textScale = 1,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.dark(),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: TextScaler.linear(textScale)),
        child: child!,
      ),
      home: StatisticsScreen(statistics: statistics),
    ),
  );
  await tester.pump();
}

void main() {
  testWidgets('shows an empty state when no round was completed', (
    tester,
  ) async {
    await pumpStatistics(tester, SessionStatistics());

    expect(find.text('Rodadas realizadas'), findsOneWidget);
    expect(find.text('0'), findsOneWidget);
    expect(find.text('Nenhuma rodada concluída nesta sessão.'), findsOneWidget);
    expect(find.text('Vitórias'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows accumulated indicators and percentages', (tester) async {
    final statistics = SessionStatistics()
      ..register(buildResult(victory: true, errorCount: 2, hintUsed: true))
      ..register(buildResult(errorCount: 1))
      ..register(buildResult(victory: false, errorCount: 6));

    await pumpStatistics(tester, statistics);

    expect(find.text('Rodadas realizadas'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(find.text('2 vitória(s) · 1 derrota(s)'), findsOneWidget);
    expect(find.text('Vitórias'), findsOneWidget);
    expect(find.text('Derrotas'), findsOneWidget);
    expect(find.text('9'), findsOneWidget);
    expect(find.text('Dicas utilizadas'), findsOneWidget);
    expect(find.text('1'), findsNWidgets(2));
    expect(find.text('66,7%'), findsOneWidget);
    expect(find.text('33,3%'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('supports a small screen with large text', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final statistics = SessionStatistics()
      ..register(buildResult(victory: false, errorCount: 6, hintUsed: true))
      ..register(buildResult(errorCount: 1));

    await pumpStatistics(tester, statistics, textScale: 3);

    expect(tester.takeException(), isNull);

    await tester.fling(find.byType(ListView), const Offset(0, -400), 800);
    await tester.pumpAndSettle();

    expect(find.text('Estatísticas da sessão'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
