import 'package:flutter/material.dart';

import '../../../../domain/enums/answer_category.dart';
import '../../../../domain/enums/difficulty.dart';
import '../../../../shared/presentation/enum_labels.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_theme.dart';

class RoundInfoHeader extends StatelessWidget {
  const RoundInfoHeader({
    super.key,
    required this.category,
    required this.difficulty,
  });

  final AnswerCategory category;
  final Difficulty difficulty;

  Color _difficultyColor(Difficulty diff) {
    return switch (diff) {
      Difficulty.easy => AppColors.primary,
      Difficulty.medium => AppColors.tertiary,
      Difficulty.hard => AppColors.error,
    };
  }

  IconData _categoryIcon(AnswerCategory cat) {
    return switch (cat) {
      AnswerCategory.animals => Icons.pets_rounded,
      AnswerCategory.humanBody => Icons.accessibility_new_rounded,
      AnswerCategory.sports => Icons.sports_soccer_rounded,
      AnswerCategory.technology => Icons.computer_rounded,
    };
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      label: 'Categoria: ${category.label}. Dificuldade: ${difficulty.label}.',
      container: true,
      child: Card(
        color: AppColors.surfaceContainerHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: const BorderSide(color: AppColors.outlineVariant, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      _categoryIcon(category),
                      color: AppColors.accent,
                      size: 20,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Categoria',
                            style: textTheme.bodySmall?.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            category.label,
                            style: textTheme.titleSmall?.copyWith(
                              color: AppColors.textHigh,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(height: 28, width: 1, color: AppColors.outlineVariant),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.signal_cellular_alt_rounded,
                      color: _difficultyColor(difficulty),
                      size: 20,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Dificuldade',
                            style: textTheme.bodySmall?.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            difficulty.label,
                            style: textTheme.titleSmall?.copyWith(
                              color: _difficultyColor(difficulty),
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
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
