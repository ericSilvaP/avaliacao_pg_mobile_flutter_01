import 'dart:async';
import 'dart:ui' show Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:avaliacao_pg_mobile_flutter_01/data/models/answer_entry.dart';
import 'package:avaliacao_pg_mobile_flutter_01/data/repositories/answer_repository.dart';
import 'package:avaliacao_pg_mobile_flutter_01/domain/enums/answer_category.dart';
import 'package:avaliacao_pg_mobile_flutter_01/domain/enums/difficulty.dart';
import 'package:avaliacao_pg_mobile_flutter_01/features/setup/setup_screen.dart';
import 'package:avaliacao_pg_mobile_flutter_01/features/setup/widgets/setup_start_button.dart';
import 'package:avaliacao_pg_mobile_flutter_01/shared/theme/app_theme.dart';

class FakeAnswerRepository implements AnswerRepository {
  bool failCategories = false;
  bool failDifficulties = false;
  bool emptyCategories = false;
  bool emptyDifficulties = false;
  Future<List<AnswerCategory>>? pendingCategories;

  @override
  Future<List<AnswerCategory>> getCategories() async {
    if (failCategories) throw StateError('Category load failed');
    if (pendingCategories != null) return pendingCategories!;
    return emptyCategories
        ? []
        : [AnswerCategory.animals, AnswerCategory.technology];
  }

  @override
  Future<List<Difficulty>> getDifficulties(AnswerCategory category) async {
    if (failDifficulties) throw StateError('Difficulty load failed');
    if (emptyDifficulties) return [];
    return category == AnswerCategory.animals
        ? [Difficulty.easy]
        : [Difficulty.hard];
  }

  @override
  Future<List<AnswerEntry>> findEntries({
    required AnswerCategory category,
    required Difficulty difficulty,
  }) async => [];
}

Future<void> pumpSetup(
  WidgetTester tester, {
  FakeAnswerRepository? repository,
  void Function(AnswerCategory, Difficulty)? onStart,
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
      home: SetupScreen(
        repository: repository ?? FakeAnswerRepository(),
        onStart: onStart ?? (_, _) {},
      ),
    ),
  );
  await tester.pump();
}

Future<void> choose<T>(WidgetTester tester, String label) async {
  await tester.pumpAndSettle();
  final dropdown = find.byType(DropdownButton<T>);
  await tester.scrollUntilVisible(
    dropdown,
    100,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pumpAndSettle();
  await tester.ensureVisible(dropdown);
  await tester.pumpAndSettle();
  await tester.tap(dropdown);
  await tester.pumpAndSettle();
  await tester.tap(find.text(label).last);
  await tester.pumpAndSettle();
}

Future<void> selectGame(WidgetTester tester) async {
  await choose<AnswerCategory>(tester, 'Animais');
  await choose<Difficulty>(tester, 'Fácil');
  await revealStartButton(tester);
}

Future<void> revealStartButton(WidgetTester tester) async {
  await tester.scrollUntilVisible(
    find.byType(SetupStartButton),
    100,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pumpAndSettle();
  await tester.ensureVisible(startButton);
  await tester.pumpAndSettle();
}

Future<void> openConfirmation(WidgetTester tester) async {
  await revealStartButton(tester);
  await tester.tap(startButton);
  await tester.pumpAndSettle();
}

Finder get startButton => find.descendant(
  of: find.byType(SetupStartButton),
  matching: find.byType(FilledButton),
);

void main() {
  testWidgets('confirms category and difficulty before starting', (
    tester,
  ) async {
    AnswerCategory? category;
    Difficulty? difficulty;
    await pumpSetup(
      tester,
      onStart: (selectedCategory, selectedDifficulty) {
        category = selectedCategory;
        difficulty = selectedDifficulty;
      },
    );
    expect(tester.widget<FilledButton>(startButton).onPressed, isNull);
    await selectGame(tester);
    await openConfirmation(tester);
    expect(find.text('Confirmar partida'), findsOneWidget);
    expect(category, isNull);
    await tester.tap(find.text('Iniciar partida'));
    await tester.pumpAndSettle();
    expect(category, AnswerCategory.animals);
    expect(difficulty, Difficulty.easy);
  });

  testWidgets('changing category clears difficulty and disables start', (
    tester,
  ) async {
    await pumpSetup(tester);
    await selectGame(tester);
    expect(tester.widget<FilledButton>(startButton).onPressed, isNotNull);
    await choose<AnswerCategory>(tester, 'Tecnologia');
    final dropdown = tester.widget<DropdownButton<Difficulty>>(
      find.byType(DropdownButton<Difficulty>),
    );
    expect(dropdown.value, isNull);
    expect(dropdown.items!.map((item) => item.value), [Difficulty.hard]);
    expect(tester.widget<FilledButton>(startButton).onPressed, isNull);
  });

  testWidgets('canceling confirmation does not start the game', (tester) async {
    var starts = 0;
    await pumpSetup(tester, onStart: (_, _) => starts++);
    await selectGame(tester);
    await openConfirmation(tester);
    await tester.tap(find.text('Voltar'));
    await tester.pumpAndSettle();
    expect(starts, 0);
    expect(find.byType(AlertDialog), findsNothing);
    expect(tester.widget<FilledButton>(startButton).onPressed, isNotNull);
  });

  testWidgets('category error can be retried', (tester) async {
    final repository = FakeAnswerRepository()..failCategories = true;
    await pumpSetup(tester, repository: repository);
    expect(
      find.text('Não foi possível carregar as categorias.'),
      findsOneWidget,
    );
    repository.failCategories = false;
    await tester.tap(find.text('Tentar novamente'));
    await tester.pumpAndSettle();
    expect(find.byType(DropdownButton<AnswerCategory>), findsOneWidget);
    expect(find.text('Tentar novamente'), findsNothing);
  });

  testWidgets('difficulty error can be retried', (tester) async {
    final repository = FakeAnswerRepository()..failDifficulties = true;
    await pumpSetup(tester, repository: repository);
    await choose<AnswerCategory>(tester, 'Animais');
    expect(
      find.text('Não foi possível carregar as dificuldades.'),
      findsOneWidget,
    );
    repository.failDifficulties = false;
    await tester.tap(find.text('Tentar novamente'));
    await tester.pumpAndSettle();
    await choose<Difficulty>(tester, 'Fácil');
    await revealStartButton(tester);
    expect(tester.widget<FilledButton>(startButton).onPressed, isNotNull);
  });

  testWidgets('empty categories and difficulties keep start disabled', (
    tester,
  ) async {
    await pumpSetup(
      tester,
      repository: FakeAnswerRepository()..emptyCategories = true,
    );
    expect(find.text('Nenhuma categoria disponível.'), findsOneWidget);
    expect(tester.widget<FilledButton>(startButton).onPressed, isNull);
    await tester.pumpWidget(const SizedBox());
    await pumpSetup(
      tester,
      repository: FakeAnswerRepository()..emptyDifficulties = true,
    );
    await choose<AnswerCategory>(tester, 'Animais');
    expect(find.text('Nenhuma dificuldade disponível.'), findsOneWidget);
    expect(tester.widget<FilledButton>(startButton).onPressed, isNull);
  });

  testWidgets('loading categories has an accessible description', (
    tester,
  ) async {
    final completer = Completer<List<AnswerCategory>>();
    await pumpSetup(
      tester,
      repository: FakeAnswerRepository()..pendingCategories = completer.future,
    );
    expect(find.bySemanticsLabel('Carregando categorias'), findsOneWidget);
    expect(tester.widget<FilledButton>(startButton).onPressed, isNull);
    completer.complete([AnswerCategory.animals]);
    await tester.pumpAndSettle();
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('start button exposes its role and enabled state', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();

    await pumpSetup(tester);
    await tester.ensureVisible(startButton);
    var data = tester.getSemantics(startButton).getSemanticsData();
    expect(data.flagsCollection.isButton, isTrue);
    expect(data.flagsCollection.isEnabled, Tristate.isFalse);
    await selectGame(tester);
    await tester.ensureVisible(startButton);
    await tester.pumpAndSettle();
    data = tester.getSemantics(startButton).getSemanticsData();
    expect(data.flagsCollection.isEnabled, Tristate.isTrue);
    semantics.dispose();
  });

  testWidgets('small screen supports large text and confirmation', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await pumpSetup(tester, textScale: 3);
    expect(tester.takeException(), isNull);
    await selectGame(tester);
    expect(tester.takeException(), isNull);
    await openConfirmation(tester);
    expect(tester.takeException(), isNull);
    await tester.ensureVisible(find.text('Voltar'));
    await tester.tap(find.text('Voltar'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
