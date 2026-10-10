import 'package:flutter_test/flutter_test.dart';

import 'package:avaliacao_pg_mobile_flutter_01/data/repositories/local_answer_repository.dart';
import 'package:avaliacao_pg_mobile_flutter_01/data/sources/answer_local_data_source.dart';
import 'package:avaliacao_pg_mobile_flutter_01/features/setup/setup_screen.dart';
import 'package:avaliacao_pg_mobile_flutter_01/main.dart';

void main() {
  testWidgets('App opens the setup screen', (WidgetTester tester) async {
    final repository = LocalAnswerRepository(AnswerLocalDataSource());

    await tester.pumpWidget(MyApp(repository: repository));
    await tester.pumpAndSettle();

    expect(find.byType(SetupScreen), findsOneWidget);
    expect(find.text('Purple-Term'), findsOneWidget);
    expect(find.text('INICIAR RODADA'), findsOneWidget);
  });
}
