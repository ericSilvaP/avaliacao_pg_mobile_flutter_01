import 'package:flutter/material.dart';

import '../../shared/theme/app_colors.dart';
import '../../shared/theme/app_theme.dart';
import 'team_members.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre a equipe'),
        backgroundColor: AppColors.background,
      ),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 448),
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.margin),
              children: [
                Text('Purple-Term', style: textTheme.headlineMedium),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Jogo da Forca desenvolvido em Flutter e Dart para a 1ª '
                  'Avaliação da disciplina de Programação para Dispositivos '
                  'Móveis, da UESPI.',
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.xl),
                Text('Integrantes', style: textTheme.titleLarge),
                const SizedBox(height: AppSpacing.md),
                for (final member in teamMembers) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor: AppColors.action,
                            child: Icon(
                              Icons.person_outline,
                              color: AppColors.textHigh,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.lg),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(member.name, style: textTheme.titleMedium),
                                Text(
                                  member.githubUrl,
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: AppColors.accent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Professor: Eyder Rios',
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
}
