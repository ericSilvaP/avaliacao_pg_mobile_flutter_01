import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:avaliacao_pg_mobile_flutter_01/features/about/about_screen.dart';
import 'package:avaliacao_pg_mobile_flutter_01/features/about/team_members.dart';
import 'package:avaliacao_pg_mobile_flutter_01/shared/theme/app_theme.dart';

Future<void> pumpAbout(WidgetTester tester, {double textScale = 1}) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.dark(),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: TextScaler.linear(textScale)),
        child: child!,
      ),
      home: const AboutScreen(),
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
  testWidgets('shows every team member with their GitHub profile', (
    tester,
  ) async {
    await pumpAbout(tester);

    expect(find.text('Sobre a equipe'), findsOneWidget);

    for (final member in teamMembers) {
      await reveal(tester, find.text(member.name));
      expect(find.text(member.name), findsOneWidget);
      expect(find.text(member.githubUrl), findsOneWidget);
    }

    expect(find.text('Professor: Eyder Rios'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('supports a small screen with large text', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpAbout(tester, textScale: 3);

    expect(tester.takeException(), isNull);

    await reveal(tester, find.text(teamMembers.last.name));
    expect(find.text(teamMembers.last.name), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
