import 'package:avaliacao_pg_mobile_flutter_01/features/game/presentation/widgets/hangman_figure.dart';
import 'package:avaliacao_pg_mobile_flutter_01/src/domain/round_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: Center(child: SizedBox(width: 300, height: 300, child: child)),
    ),
  );
}

void main() {
  group('HangmanFigure', () {
    testWidgets('renders only gallows when errors is 0', (tester) async {
      await tester.pumpWidget(_wrap(const HangmanFigure(errors: 0)));

      final images = tester.widgetList<Image>(find.byType(Image)).toList();
      expect(images.length, 1);

      final gallowsProvider = images[0].image as AssetImage;
      expect(gallowsProvider.assetName, HangmanAssets.gallows);
    });

    testWidgets('renders gallows and alive head when errors is 1', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(const HangmanFigure(errors: 1)));

      final images = tester.widgetList<Image>(find.byType(Image)).toList();
      expect(images.length, 2);

      final headProvider = images[1].image as AssetImage;
      expect(headProvider.assetName, HangmanAssets.head);
    });

    testWidgets('renders all 6 body parts plus gallows when errors is 6', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(const HangmanFigure(errors: 6)));

      final images = tester.widgetList<Image>(find.byType(Image)).toList();
      expect(images.length, 7);

      final assetNames = images
          .map((img) => (img.image as AssetImage).assetName)
          .toList();

      expect(assetNames, [
        HangmanAssets.gallows,
        HangmanAssets.head,
        HangmanAssets.torso,
        HangmanAssets.armLeft,
        HangmanAssets.armRight,
        HangmanAssets.legLeft,
        HangmanAssets.legRight,
      ]);
    });

    testWidgets(
      'swaps alive head with dead head on defeat (status == RoundStatus.lost)',
      (tester) async {
        await tester.pumpWidget(
          _wrap(const HangmanFigure(errors: 6, status: RoundStatus.lost)),
        );

        final images = tester.widgetList<Image>(find.byType(Image)).toList();
        expect(images.length, 7);

        final assetNames = images
            .map((img) => (img.image as AssetImage).assetName)
            .toList();

        expect(assetNames.contains(HangmanAssets.head), isFalse);
        expect(assetNames.contains(HangmanAssets.headDead), isTrue);
      },
    );

    testWidgets('exposes proper semantic descriptions', (tester) async {
      final semantics = tester.ensureSemantics();

      await tester.pumpWidget(_wrap(const HangmanFigure(errors: 0)));
      var data = tester
          .getSemantics(find.byType(HangmanFigure))
          .getSemanticsData();
      expect(data.label, 'Forca vazia, nenhum erro cometido');

      await tester.pumpWidget(_wrap(const HangmanFigure(errors: 3)));
      data = tester.getSemantics(find.byType(HangmanFigure)).getSemanticsData();
      expect(data.label, 'Forca com 3 de 6 erros');

      await tester.pumpWidget(
        _wrap(const HangmanFigure(errors: 6, status: RoundStatus.lost)),
      );
      data = tester.getSemantics(find.byType(HangmanFigure)).getSemanticsData();
      expect(data.label, 'Forca completa: boneco enforcado, rodada perdida');

      semantics.dispose();
    });
  });
}
