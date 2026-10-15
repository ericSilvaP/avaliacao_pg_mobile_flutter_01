import 'package:flutter/material.dart';

import 'data/repositories/answer_repository.dart';
import 'domain/enums/answer_category.dart';
import 'domain/enums/difficulty.dart';
import 'features/about/about_screen.dart';
import 'features/game/presentation/game_screen.dart';
import 'features/game/presentation/widgets/keyboard_layout.dart';
import 'features/result/result_screen.dart';
import 'features/session/answer_draw_result.dart';
import 'features/session/session_manager.dart';
import 'features/setup/setup_screen.dart';
import 'features/statistics/statistics_screen.dart';
import 'shared/presentation/enum_labels.dart';
import 'shared/theme/app_theme.dart';
import 'src/domain/round_result.dart';

const String _victoryLogoAssetPath = 'assets/images/purple-term-logo.png';
const String _defeatLogoAssetPath = 'assets/images/purple-term-dead-logo.png';

class HangmanApp extends StatefulWidget {
  const HangmanApp({super.key, required this.repository});

  final AnswerRepository repository;

  @override
  State<HangmanApp> createState() => _HangmanAppState();
}

class _HangmanAppState extends State<HangmanApp> {
  late final SessionManager _session = SessionManager(widget.repository);
  final ValueNotifier<KeyboardLayout> _keyboardLayout = ValueNotifier(
    KeyboardLayout.qwerty,
  );

  @override
  void dispose() {
    _keyboardLayout.dispose();
    super.dispose();
  }

  Future<void> _startRound(
    BuildContext context,
    AnswerCategory category,
    Difficulty difficulty,
  ) async {
    final result = await _session.drawAnswer(
      category: category,
      difficulty: difficulty,
    );

    if (!context.mounted) return;

    switch (result) {
      case DrawnAnswer(:final entry):
        await Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => GameScreen(
              entry: entry,
              category: category,
              difficulty: difficulty,
              layoutNotifier: _keyboardLayout,
              onRoundFinished: (result) => _finishRound(
                context,
                result: result,
                category: category,
                difficulty: difficulty,
              ),
            ),
          ),
        );
      case NoAnswersAvailable():
        await _showMessage(
          context,
          'Não há respostas disponíveis para ${category.label} / '
          '${difficulty.label}.',
        );
      case AnswersExhausted(:final totalAnswers):
        await _showMessage(
          context,
          'As $totalAnswers respostas de ${category.label} / '
          '${difficulty.label} já foram usadas nesta sessão. '
          'Escolha outra combinação ou reinicie o aplicativo.',
        );
    }
  }

  void _finishRound(
    BuildContext context, {
    required RoundResult result,
    required AnswerCategory category,
    required Difficulty difficulty,
  }) {
    _session.statistics.register(result);

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ResultScreen(
          result: result,
          victoryLogoAssetPath: _victoryLogoAssetPath,
          defeatLogoAssetPath: _defeatLogoAssetPath,
          onPlayAgain: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
            _startRound(context, category, difficulty);
          },
          onChangeSetup: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
          onOpenStatistics: () => _openStatistics(context),
        ),
      ),
    );
  }

  void _openStatistics(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => StatisticsScreen(statistics: _session.statistics),
      ),
    );
  }

  void _openAbout(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const AboutScreen()));
  }

  Future<void> _showMessage(BuildContext context, String message) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Rodada indisponível'),
        content: Text(message),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Entendi'),
          ),
        ],
      ),
    );
  }

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
          repository: widget.repository,
            logoAssetPath: _victoryLogoAssetPath,
          onStart: (category, difficulty) =>
              _startRound(context, category, difficulty),
          onOpenStatistics: () => _openStatistics(context),
          onOpenAbout: () => _openAbout(context),
        ),
      ),
    );
  }
}
