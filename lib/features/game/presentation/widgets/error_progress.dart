import 'package:flutter/material.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_theme.dart';

class ErrorProgress extends StatelessWidget {
  const ErrorProgress({
    super.key,
    required this.currentErrors,
    this.maxErrors = 6,
  }) : assert(maxErrors > 0, 'maxErrors must be positive');

  final int currentErrors;
  final int maxErrors;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final clampedErrors = currentErrors.clamp(0, maxErrors);

    return Semantics(
      label: 'Erros: $clampedErrors de $maxErrors',
      container: true,
      excludeSemantics: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                'Erros: ',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              Text(
                '$clampedErrors de $maxErrors',
                style: textTheme.titleMedium?.copyWith(
                  color: clampedErrors > 0
                      ? AppColors.error
                      : AppColors.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              for (var i = 0; i < maxErrors; i++)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 20,
                  height: 6,
                  decoration: BoxDecoration(
                    color: i < clampedErrors
                        ? AppColors.error
                        : AppColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    border: i < clampedErrors
                        ? null
                        : Border.all(color: AppColors.outlineVariant, width: 1),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
