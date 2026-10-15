import 'package:flutter/material.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../domain/round_status.dart';

/// Banner exibido quando a rodada termina (vitória ou derrota).
///
/// Apresenta feedback visual imediato antes da transição automática
/// para a tela de resultado da rodada.
class RoundOutcomeBanner extends StatelessWidget {
  const RoundOutcomeBanner({super.key, required this.status});

  final RoundStatus status;

  @override
  Widget build(BuildContext context) {
    if (status == RoundStatus.inProgress) {
      return const SizedBox.shrink();
    }

    final isWon = status == RoundStatus.won;
    final color = isWon ? AppColors.accent : AppColors.error;
    final title = isWon ? 'Vitória!' : 'Derrota';
    final subtitle = isWon
        ? 'Você descobriu a palavra!'
        : 'O limite de erros foi atingido.';
    final icon = isWon
        ? Icons.emoji_events_rounded
        : Icons.sentiment_dissatisfied_rounded;

    return Semantics(
      liveRegion: true,
      container: true,
      label: 'Resultado da rodada: $title. $subtitle',
      child: Card(
        color: AppColors.surfaceContainerHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: BorderSide(color: color, width: 1.5),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.xs),
                decoration: BoxDecoration(
                  color: AppColors.cardSurface,
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 1),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge
                          ?.copyWith(color: color, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(color: AppColors.textMedium),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
