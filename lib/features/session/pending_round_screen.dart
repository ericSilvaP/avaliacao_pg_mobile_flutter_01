import 'package:flutter/material.dart';

import '../../data/models/answer_entry.dart';
import '../../domain/enums/answer_category.dart';
import '../../domain/enums/difficulty.dart';
import '../../shared/presentation/enum_labels.dart';
import '../../shared/theme/app_colors.dart';
import '../../shared/theme/app_theme.dart';
import '../../domain/game_round.dart';
import '../../domain/round_result.dart';
import '../../domain/text_format.dart';

const Color _roundBackground = Color(0xFF0E0920);

class PendingRoundScreen extends StatelessWidget {
  const PendingRoundScreen({
    super.key,
    required this.entry,
    required this.category,
    required this.difficulty,
    required this.onRoundFinished,
  });

  final AnswerEntry entry;
  final AnswerCategory category;
  final Difficulty difficulty;
  final void Function(RoundResult result) onRoundFinished;

  RoundResult _simulateVictory() {
    final round = GameRound(answer: entry);

    for (final character in TextFormat.format(entry.answer).split('')) {
      round.guessLetter(character);
    }

    return round.toResult();
  }

  RoundResult _simulateDefeat() {
    final round = GameRound(answer: entry);
    final answerLetters = TextFormat.format(entry.answer).split('').toSet();

    for (final letter in 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('')) {
      if (round.isFinished) break;

      if (!answerLetters.contains(letter)) {
        round.guessLetter(letter);
      }
    }

    return round.toResult();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: _roundBackground,
      appBar: AppBar(
        title: const Text('Partida'),
        backgroundColor: _roundBackground,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 448),
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.margin),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Categoria', style: textTheme.bodyMedium),
                              Text(
                                category.label,
                                style: textTheme.titleMedium,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Dificuldade', style: textTheme.bodyMedium),
                              Text(
                                difficulty.label,
                                style: textTheme.titleMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Resposta sorteada', style: textTheme.bodyMedium),
                        const SizedBox(height: AppSpacing.xs),
                        Text(entry.answer, style: textTheme.headlineSmall),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Na partida real esta resposta fica oculta e é '
                          'revelada letra a letra. Esta tela é provisória e '
                          'será substituída pela interface da partida.',
                          style: textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Dicas', style: textTheme.bodyMedium),
                        const SizedBox(height: AppSpacing.sm),
                        for (final hint in entry.hints)
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.xs,
                            ),
                            child: Text(hint, style: textTheme.bodyLarge),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  'Ambiente de teste provisório: os botões abaixo encerram a '
                  'rodada para validar o fluxo de resultado e estatísticas.',
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                FilledButton.icon(
                  onPressed: () => onRoundFinished(_simulateVictory()),
                  icon: const Icon(Icons.emoji_events_outlined),
                  label: const Text('Simular vitória'),
                ),
                const SizedBox(height: AppSpacing.md),
                OutlinedButton.icon(
                  onPressed: () => onRoundFinished(_simulateDefeat()),
                  icon: const Icon(Icons.sentiment_dissatisfied_outlined),
                  label: const Text('Simular derrota'),
                ),
                const SizedBox(height: AppSpacing.sm),
                TextButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                  label: const Text('Abandonar rodada'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
