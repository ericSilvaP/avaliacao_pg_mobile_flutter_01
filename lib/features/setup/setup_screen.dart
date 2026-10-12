import 'package:flutter/material.dart';

import '../../data/repositories/answer_repository.dart';
import '../../domain/enums/answer_category.dart';
import '../../domain/enums/difficulty.dart';
import '../../shared/presentation/enum_labels.dart';
import '../../shared/theme/app_colors.dart';
import '../../shared/theme/app_theme.dart';
import 'widgets/setup_async_dropdown_field.dart';
import 'widgets/setup_start_button.dart';
import 'widgets/setup_header.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({
    super.key,
    required this.repository,
    required this.onStart,
    this.onOpenStatistics,
    this.onOpenAbout,
    this.logoAssetPath,
  });

  final AnswerRepository repository;
  final void Function(AnswerCategory category, Difficulty difficulty) onStart;
  final VoidCallback? onOpenStatistics;
  final VoidCallback? onOpenAbout;
  final String? logoAssetPath;

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  late Future<List<AnswerCategory>> _categoriesFuture;
  Future<List<Difficulty>>? _difficultiesFuture;
  AnswerCategory? _category;
  Difficulty? _difficulty;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = widget.repository.getCategories();
    _categoriesFuture.ignore();
  }

  void _changeCategory(AnswerCategory? value) {
    setState(() {
      _category = value;
      _difficulty = null;
      _difficultiesFuture = value == null
          ? null
          : widget.repository.getDifficulties(value);
      // FutureBuilder subscribes on the next frame (or when scrolled into view).
      // Observe early errors without changing the future it uses to show them.
      _difficultiesFuture?.ignore();
    });
  }

  Future<void> _confirm() async {
    final category = _category;
    final difficulty = _difficulty;
    if (category == null || difficulty == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        scrollable: true,
        title: const Text('Confirmar partida'),
        content: Text(
          'Categoria: ${category.label}\nDificuldade: ${difficulty.label}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Voltar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Iniciar partida'),
          ),
        ],
      ),
    );

    if (!mounted || confirmed != true) return;
    widget.onStart(category, difficulty);
  }

  void _retryCategories() {
    setState(() {
      _category = null;
      _difficulty = null;
      _difficultiesFuture = null;
      _categoriesFuture = widget.repository.getCategories();
      _categoriesFuture.ignore();
    });
  }

  @override
  Widget build(BuildContext context) {
    final enabled = _category != null && _difficulty != null;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 448),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 32, 16, 32),
              children: [
                SetupHeader(logoAssetPath: widget.logoAssetPath),
                const SizedBox(height: 48),
                SetupAsyncDropdownField<AnswerCategory>(
                  future: _categoriesFuture,
                  label: 'Categoria do Enigma',
                  icon: Icons.auto_awesome_outlined,
                  hint: 'Selecione uma categoria',
                  loadingLabel: 'Carregando categorias',
                  errorMessage: 'Não foi possível carregar as categorias.',
                  emptyMessage: 'Nenhuma categoria disponível.',
                  value: _category,
                  itemLabel: (category) => category.label,
                  onChanged: _changeCategory,
                  onRetry: _retryCategories,
                ),
                const SizedBox(height: 12),
                SetupAsyncDropdownField<Difficulty>(
                  future: _difficultiesFuture,
                  label: 'Dificuldade',
                  icon: Icons.tune,
                  hint: _category == null
                      ? 'Selecione uma categoria primeiro'
                      : 'Selecione uma dificuldade',
                  loadingLabel: 'Carregando dificuldades',
                  errorMessage: 'Não foi possível carregar as dificuldades.',
                  emptyMessage: 'Nenhuma dificuldade disponível.',
                  value: _difficulty,
                  itemLabel: (difficulty) => difficulty.label,
                  onChanged: (value) => setState(() => _difficulty = value),
                  onRetry: () => _changeCategory(_category),
                ),
                const SizedBox(height: 32),
                if (enabled) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Sua escolha:',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),

                        const SizedBox(height: 12),
                        Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Categoria - ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: _category!.label),
                            ],
                          ),
                        ),

                        const SizedBox(height: 8),
                        Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Dificuldade - ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: _difficulty!.label),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                SetupStartButton(onPressed: enabled ? _confirm : null),
                if (widget.onOpenStatistics != null ||
                    widget.onOpenAbout != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: AppSpacing.sm,
                    children: [
                      if (widget.onOpenStatistics != null)
                        TextButton.icon(
                          onPressed: widget.onOpenStatistics,
                          icon: const Icon(Icons.bar_chart_outlined),
                          label: const Text('Estatísticas da sessão'),
                        ),
                      if (widget.onOpenAbout != null)
                        TextButton.icon(
                          onPressed: widget.onOpenAbout,
                          icon: const Icon(Icons.info_outline),
                          label: const Text('Sobre a equipe'),
                        ),
                    ],
                  ),
                ],
                const SizedBox(height: 8),
                Text(
                  'Boa sorte em sua jornada mágica!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelMedium
                      ?.copyWith(color: AppColors.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
