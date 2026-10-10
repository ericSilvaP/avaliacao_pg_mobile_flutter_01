import 'package:flutter/material.dart';

import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_theme.dart';

class SetupHeader extends StatelessWidget {
  const SetupHeader({super.key, this.logoAssetPath});

  final String? logoAssetPath;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExcludeSemantics(
          child: SizedBox(
            width: 144,
            height: 144,
            child: logoAssetPath == null
                ? const Icon(
                    Icons.auto_awesome_rounded,
                    size: 86,
                    color: AppColors.accent,
                  )
                : Image.asset(
                    logoAssetPath!,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => const Icon(
                      Icons.auto_awesome_rounded,
                      size: 86,
                      color: AppColors.accent,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Semantics(
          header: true,
          child: Text(
            'Purple-Term',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Decifre as palavras ocultas antes que as chances se esgotem.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
