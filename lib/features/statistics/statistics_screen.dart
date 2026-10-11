import 'package:flutter/material.dart';

import '../../shared/theme/app_colors.dart';
import '../../shared/theme/app_theme.dart';
import '../session/session_statistics.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key, required this.statistics});

  final SessionStatistics statistics;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final hasRounds = statistics.completedRounds > 0;

    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLowest,
      appBar: AppBar(
        title: const Text('Estatísticas da sessão'),
        backgroundColor: AppColors.surfaceContainerLowest,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 448),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.margin,
                AppSpacing.xl,
                AppSpacing.margin,
                AppSpacing.xl,
              ),
              children: [
                _SummaryCard(
                  completedRounds: statistics.completedRounds,
                  victories: statistics.victories,
                  defeats: statistics.defeats,
                ),
                if (!hasRounds) ...[
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    'Nenhuma rodada concluída nesta sessão.',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium,
                  ),
                ] else ...[
                  const SizedBox(height: AppSpacing.lg),
                  _StatisticCard(
                    icon: Icons.emoji_events_outlined,
                    label: 'Vitórias',
                    value: '${statistics.victories}',
                    detail: _formatPercentage(statistics.victoryPercentage),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _StatisticCard(
                    icon: Icons.sentiment_dissatisfied_outlined,
                    label: 'Derrotas',
                    value: '${statistics.defeats}',
                    detail: _formatPercentage(statistics.defeatPercentage),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _StatisticCard(
                    icon: Icons.error_outline,
                    label: 'Erros cometidos',
                    value: '${statistics.totalErrors}',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _StatisticCard(
                    icon: Icons.lightbulb_outline,
                    label: 'Dicas utilizadas',
                    value: '${statistics.hintsUsed}',
                  ),
                ],
                const SizedBox(height: AppSpacing.xl),
                Text(
                  'Os percentuais são calculados sobre as rodadas concluídas. '
                  'As estatísticas são encerradas junto com o aplicativo.',
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatPercentage(double percentage) {
    final formatted = percentage.toStringAsFixed(1).replaceAll('.', ',');

    return '$formatted%';
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.completedRounds,
    required this.victories,
    required this.defeats,
  });

  final int completedRounds;
  final int victories;
  final int defeats;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.action,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: const Icon(Icons.bar_chart, color: AppColors.textHigh),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Rodadas realizadas', style: textTheme.bodyMedium),
                  Text('$completedRounds', style: textTheme.headlineMedium),
                  Text(
                    '$victories vitória(s) · $defeats derrota(s)',
                    style: textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatisticCard extends StatelessWidget {
  const _StatisticCard({
    required this.icon,
    required this.label,
    required this.value,
    this.detail,
  });

  final IconData icon;
  final String label;
  final String value;
  final String? detail;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.accent),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: textTheme.bodyMedium),
                  Text(value, style: textTheme.titleLarge),
                ],
              ),
            ),
            if (detail != null) ...[
              const SizedBox(width: AppSpacing.sm),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Text(
                    detail!,
                    style: textTheme.titleMedium?.copyWith(
                      color: AppColors.accent,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
