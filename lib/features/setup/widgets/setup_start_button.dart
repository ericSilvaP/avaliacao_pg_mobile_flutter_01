import 'package:flutter/material.dart';

import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_theme.dart';

class SetupStartButton extends StatelessWidget {
  const SetupStartButton({super.key, required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style:
          FilledButton.styleFrom(
            minimumSize: const Size(0, 56),
            textStyle: AppTextStyles.actionLabel,
          ).copyWith(
            backgroundBuilder: (context, states, child) => Ink(
              decoration: BoxDecoration(
                gradient: states.contains(WidgetState.disabled)
                    ? null
                    : const LinearGradient(
                        colors: [
                          AppColors.action,
                          AppColors.secondaryContainer,
                        ],
                      ),
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: child,
            ),
          ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.play_arrow_rounded),
          SizedBox(width: AppSpacing.sm),
          Flexible(child: Text('INICIAR RODADA', textAlign: TextAlign.center)),
        ],
      ),
    );
  }
}
