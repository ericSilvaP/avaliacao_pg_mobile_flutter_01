import 'package:flutter/material.dart';

import 'data/repositories/answer_repository.dart';
import 'domain/enums/answer_category.dart';
import 'domain/enums/difficulty.dart';
import 'features/about/about_screen.dart';
import 'features/result/result_screen.dart';
import 'features/session/answer_draw_result.dart';
import 'features/session/pending_round_screen.dart';
import 'features/session/session_manager.dart';
import 'features/setup/setup_screen.dart';
import 'features/statistics/statistics_screen.dart';
import 'shared/presentation/enum_labels.dart';
import 'shared/theme/app_theme.dart';
import 'src/domain/round_result.dart';

class HangmanApp extends StatefulWidget {
  const HangmanApp({super.key, required this.repository});

  final AnswerRepository repository;

  @override
  State<HangmanApp> createState() => _HangmanAppState();
}

class _HangmanAppState extends State<HangmanApp> {
  late final SessionManager _session = SessionManager(widget.repository);

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
            builder: (_) => PendingRoundScreen(
              entry: entry,
              category: category,
              difficulty: difficulty,
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
          victoryLogoAssetPath: 'assets/images/purple-term-logo.png',
          defeatLogoAssetPath: 'assets/images/purple-term-dead-logo.png',
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
          logoAssetPath: 'assets/images/purple-term-logo.png',
          onStart: (category, difficulty) =>
              _startRound(context, category, difficulty),
          onOpenStatistics: () => _openStatistics(context),
          onOpenAbout: () => _openAbout(context),
        ),
      ),
    );
  }
}
