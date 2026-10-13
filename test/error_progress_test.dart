import 'package:avaliacao_pg_mobile_flutter_01/features/game/presentation/widgets/error_progress.dart';
import 'package:avaliacao_pg_mobile_flutter_01/shared/theme/app_colors.dart';
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
  group('ErrorProgress', () {
    testWidgets('displays error count text', (tester) async {
      await tester.pumpWidget(
        _wrap(const ErrorProgress(currentErrors: 0, maxErrors: 6)),
      );

      expect(find.text('Erros: '), findsOneWidget);
      expect(find.text('0 de 6'), findsOneWidget);
    });

    testWidgets('updates count text with multiple errors', (tester) async {
      await tester.pumpWidget(
        _wrap(const ErrorProgress(currentErrors: 4, maxErrors: 6)),
      );

      expect(find.text('4 de 6'), findsOneWidget);
    });

    testWidgets('renders exactly maxErrors pips with proper colors', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(const ErrorProgress(currentErrors: 2, maxErrors: 6)),
      );

      final pips = tester.widgetList<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      expect(pips.length, 6);

      final list = pips.toList();
      // First 2 pips are filled with error color
      final dec0 = list[0].decoration as BoxDecoration;
      expect(dec0.color, AppColors.error);

      final dec1 = list[1].decoration as BoxDecoration;
      expect(dec1.color, AppColors.error);

      // Remaining 4 pips are unfilled
      final dec2 = list[2].decoration as BoxDecoration;
      expect(dec2.color, AppColors.surfaceContainerHigh);

      final dec5 = list[5].decoration as BoxDecoration;
      expect(dec5.color, AppColors.surfaceContainerHigh);
    });

    test('asserts maxErrors must be positive', () {
      expect(
        () => ErrorProgress(currentErrors: 0, maxErrors: 0),
        throwsAssertionError,
      );
    });

    testWidgets('exposes accessible semantic description', (tester) async {
      final semantics = tester.ensureSemantics();

      await tester.pumpWidget(
        _wrap(const ErrorProgress(currentErrors: 3, maxErrors: 6)),
      );

      final data = tester
          .getSemantics(find.byType(ErrorProgress))
          .getSemanticsData();
      expect(data.label, 'Erros: 3 de 6');

      semantics.dispose();
    });
  });
}
