import 'package:flutter/material.dart';

import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_theme.dart';

class SetupDropdownField<T> extends StatelessWidget {
  const SetupDropdownField({
    super.key,
    required this.label,
    required this.icon,
    required this.hint,
    required this.items,
    required this.value,
    required this.onChanged,
    required this.itemLabel,
  });

  final String label;
  final IconData icon;
  final String hint;
  final List<T> items;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final String Function(T) itemLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: AppColors.onSurfaceVariant),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: ExcludeSemantics(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          constraints: const BoxConstraints(minHeight: 58),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColors.outlineVariant.withAlpha(128)),
          ),
          child: Semantics(
            label: label,
            enabled: onChanged != null,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<T>(
                isExpanded: true,
                itemHeight: null,
                value: value,
                hint: Text(hint),
                dropdownColor: AppColors.surfaceContainerHigh,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.onSurfaceVariant,
                ),
                style: Theme.of(context).textTheme.bodyLarge,
                items: [
                  for (final item in items)
                    DropdownMenuItem<T>(
                      value: item,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.sm,
                        ),
                        child: Text(itemLabel(item)),
                      ),
                    ),
                ],
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
