import 'package:flutter/material.dart';

import '../../shared/theme/app_colors.dart';
import '../../shared/theme/app_theme.dart';
import '../../domain/round_result.dart';

const Color _resultBackground = Color(0xFF0F0C1B);

class ResultScreen extends StatelessWidget {
  const ResultScreen({
    super.key,
    required this.result,
    required this.onPlayAgain,
    required this.onChangeSetup,
    this.onOpenStatistics,
    this.victoryLogoAssetPath,
    this.defeatLogoAssetPath,
  });

  final RoundResult result;
  final VoidCallback onPlayAgain;
  final VoidCallback onChangeSetup;
  final VoidCallback? onOpenStatistics;
  final String? victoryLogoAssetPath;
  final String? defeatLogoAssetPath;

  bool get _isVictory => result.isVictory;

  Color get _statusColor => _isVictory ? AppColors.accent : AppColors.error;

  IconData get _statusIcon => _isVictory
      ? Icons.emoji_events_rounded
      : Icons.sentiment_dissatisfied_rounded;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final logoAssetPath = _isVictory
        ? victoryLogoAssetPath
        : defeatLogoAssetPath;

    return Scaffold(
      backgroundColor: _resultBackground,
      appBar: AppBar(
        title: const Text('Resultado da rodada'),
        backgroundColor: _resultBackground,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 448),
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.margin),
              children: [
                Center(
                  child: ExcludeSemantics(
                    child: SizedBox(
                      width: 120,
                      height: 120,
                      child: logoAssetPath == null
                          ? Icon(_statusIcon, size: 80, color: _statusColor)
                          : Image.asset(
                              logoAssetPath,
                              fit: BoxFit.contain,
                              errorBuilder: (_, _, _) => Icon(
                                _statusIcon,
                                size: 80,
                                color: _statusColor,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Semantics(
                  header: true,
                  child: Text(
                    _isVictory ? 'Vitória!' : 'Derrota',
                    textAlign: TextAlign.center,
                    style: textTheme.headlineMedium?.copyWith(
                      color: _statusColor,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  _isVictory
                      ? 'Você descobriu a resposta antes do limite de erros.'
                      : 'O limite máximo de erros foi atingido.',
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.xl),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Resposta', style: textTheme.bodyMedium),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          result.answerEntry.answer,
                          style: textTheme.headlineSmall,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.md,
                    ),
                    child: Column(
                      children: [
                        _ResultRow(
                          label: 'Erros cometidos',
                          value: '${result.errorCount}',
                        ),
                        const Divider(),
                        _ResultRow(
                          label: 'Dica utilizada',
                          value: result.hintUsed ? 'Sim' : 'Não',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                FilledButton.icon(
                  onPressed: onPlayAgain,
                  icon: const Icon(Icons.replay_rounded),
                  label: const Text('Jogar novamente'),
                ),
                const SizedBox(height: AppSpacing.md),
                OutlinedButton.icon(
                  onPressed: onChangeSetup,
                  icon: const Icon(Icons.tune_rounded),
                  label: const Text('Trocar configuração'),
                ),
                if (onOpenStatistics != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  TextButton.icon(
                    onPressed: onOpenStatistics,
                    icon: const Icon(Icons.bar_chart_outlined),
                    label: const Text('Ver estatísticas da sessão'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: Text(label, style: textTheme.bodyMedium)),
          const SizedBox(width: AppSpacing.md),
          Text(value, style: textTheme.titleMedium),
        ],
      ),
    );
  }
}
