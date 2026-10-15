import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:avaliacao_pg_mobile_flutter_01/data/models/answer_entry.dart';
import 'package:avaliacao_pg_mobile_flutter_01/domain/enums/answer_category.dart';
import 'package:avaliacao_pg_mobile_flutter_01/domain/enums/difficulty.dart';
import 'package:avaliacao_pg_mobile_flutter_01/features/result/result_screen.dart';
import 'package:avaliacao_pg_mobile_flutter_01/shared/theme/app_theme.dart';
import 'package:avaliacao_pg_mobile_flutter_01/domain/round_result.dart';
import 'package:avaliacao_pg_mobile_flutter_01/domain/round_status.dart';

RoundResult buildResult({
  bool victory = true,
  String answer = 'QUATI SUL-AMERICANO',
  int errorCount = 2,
  bool hintUsed = false,
}) {
  return RoundResult(
    answerEntry: AnswerEntry(
      answer: answer,
      category: AnswerCategory.animals,
      difficulty: Difficulty.easy,
      hints: const ['Mamífero de orelhas curtas.'],
    ),
    status: victory ? RoundStatus.won : RoundStatus.lost,
    errorCount: errorCount,
    hintUsed: hintUsed,
  );
}

Future<void> pumpResult(
  WidgetTester tester, {
  required RoundResult result,
  VoidCallback? onPlayAgain,
  VoidCallback? onChangeSetup,
  VoidCallback? onOpenStatistics,
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
      home: ResultScreen(
        result: result,
        onPlayAgain: onPlayAgain ?? () {},
        onChangeSetup: onChangeSetup ?? () {},
        onOpenStatistics: onOpenStatistics,
      ),
    ),
  );
  await tester.pump();
}

Future<void> reveal(WidgetTester tester, Finder finder) async {
  await tester.scrollUntilVisible(
    finder,
    200,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pumpAndSettle();
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows victory with answer, errors and hint usage', (
    tester,
  ) async {
    await pumpResult(
      tester,
      result: buildResult(
        victory: true,
        answer: 'ARTICULAÇÃO TÊMPORO-MANDIBULAR',
        errorCount: 3,
        hintUsed: true,
      ),
    );

    expect(find.text('Vitória!'), findsOneWidget);
    await reveal(tester, find.text('ARTICULAÇÃO TÊMPORO-MANDIBULAR'));
    expect(find.text('ARTICULAÇÃO TÊMPORO-MANDIBULAR'), findsOneWidget);
    await reveal(tester, find.text('Erros cometidos'));
    expect(find.text('3'), findsOneWidget);
    expect(find.text('Dica utilizada'), findsOneWidget);
    expect(find.text('Sim'), findsOneWidget);
    expect(find.text('Derrota'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows defeat revealing the full answer', (tester) async {
    await pumpResult(
      tester,
      result: buildResult(
        victory: false,
        answer: 'CORRIDA COM OBSTÁCULOS',
        errorCount: 6,
      ),
    );

    expect(find.text('Derrota'), findsOneWidget);
    await reveal(tester, find.text('CORRIDA COM OBSTÁCULOS'));
    expect(find.text('CORRIDA COM OBSTÁCULOS'), findsOneWidget);
    await reveal(tester, find.text('Erros cometidos'));
    expect(find.text('6'), findsOneWidget);
    expect(find.text('Não'), findsOneWidget);
    expect(find.text('Vitória!'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('requests a new round and a setup change', (tester) async {
    var playAgain = 0;
    var changeSetup = 0;

    await pumpResult(
      tester,
      result: buildResult(),
      onPlayAgain: () => playAgain++,
      onChangeSetup: () => changeSetup++,
    );

    await reveal(tester, find.text('Jogar novamente'));
    await tester.tap(find.text('Jogar novamente'));
    await tester.pumpAndSettle();

    await reveal(tester, find.text('Trocar configuração'));
    await tester.tap(find.text('Trocar configuração'));
    await tester.pumpAndSettle();

    expect(playAgain, 1);
    expect(changeSetup, 1);
  });

  testWidgets('shows the statistics action only when it is provided', (
    tester,
  ) async {
    await pumpResult(tester, result: buildResult());
    await reveal(tester, find.text('Trocar configuração'));
    expect(find.text('Ver estatísticas da sessão'), findsNothing);
  });

  testWidgets('requests session statistics when it is provided', (
    tester,
  ) async {
    var openStatistics = 0;

    await pumpResult(
      tester,
      result: buildResult(),
      onOpenStatistics: () => openStatistics++,
    );

    await reveal(tester, find.text('Ver estatísticas da sessão'));
    await tester.tap(find.text('Ver estatísticas da sessão'));
    await tester.pumpAndSettle();

    expect(openStatistics, 1);
  });

  testWidgets('supports a small screen with large text', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpResult(
      tester,
      result: buildResult(
        victory: false,
        answer: 'ARTICULAÇÃO TÊMPORO-MANDIBULAR',
        errorCount: 6,
        hintUsed: true,
      ),
      textScale: 3,
    );

    expect(tester.takeException(), isNull);

    await reveal(tester, find.text('Jogar novamente'));
    expect(tester.takeException(), isNull);

    await reveal(tester, find.text('Trocar configuração'));
    expect(tester.takeException(), isNull);
  });
}
