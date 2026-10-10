import 'package:flutter/material.dart';

import 'data/repositories/answer_repository.dart';
import 'data/repositories/local_answer_repository.dart';
import 'data/sources/answer_local_data_source.dart';
import 'features/setup/setup_screen.dart';
import 'shared/presentation/enum_labels.dart';
import 'shared/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final repository = LocalAnswerRepository(AnswerLocalDataSource());
  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.repository});

  final AnswerRepository repository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Purple-Term',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.dark,
      home: Builder(
        builder: (context) => SetupScreen(
          repository: repository,
          logoAssetPath: 'assets/images/purple-term-logo.png',
          onStart: (category, difficulty) {
            // Temporário: o Integrante 4 conectará a navegação e o sorteio.
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Configuração: ${category.label} / ${difficulty.label}. '
                  'Integração com o jogo pendente.',
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
