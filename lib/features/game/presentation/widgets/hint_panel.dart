import 'package:flutter/material.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_theme.dart';

class HintPanel extends StatelessWidget {
  const HintPanel({
    super.key,
    required this.hintUsed,
    this.hint,
    this.onHintRequested,
    this.isFinished = false,
  });

  final bool hintUsed;
  final String? hint;
  final VoidCallback? onHintRequested;
  final bool isFinished;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    if (!hintUsed) {
      return Center(
        child: OutlinedButton.icon(
          onPressed: isFinished ? null : onHintRequested,
          icon: const Icon(Icons.lightbulb_outline_rounded, size: 20),
          label: const Text('Pedir dica'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.tertiary,
            side: const BorderSide(color: AppColors.tertiaryContainer),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
          ),
        ),
      );
    }

    final effectiveHint = (hint != null && hint!.trim().isNotEmpty)
        ? hint!
        : 'Nenhuma dica disponível para esta rodada.';

    return Semantics(
      label: 'Dica da rodada: $effectiveHint',
      container: true,
      child: Card(
        color: AppColors.surfaceContainerHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: const BorderSide(color: AppColors.tertiaryContainer, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.lightbulb_rounded,
                color: AppColors.tertiary,
                size: 22,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Dica',
                          style: textTheme.labelLarge?.copyWith(
                            color: AppColors.tertiary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Dica utilizada',
                          style: textTheme.bodySmall?.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      effectiveHint,
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.textHigh,
                      ),
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
