import 'dart:async';

import 'package:flutter/material.dart';

import '../../../data/models/answer_entry.dart';
import '../../../domain/enums/answer_category.dart';
import '../../../domain/enums/difficulty.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_theme.dart';
import '../../../src/domain/game_round.dart';
import '../../../src/domain/round_result.dart';
import 'widgets/answer_board.dart';
import 'widgets/error_progress.dart';
import 'widgets/hangman_figure.dart';
import 'widgets/hint_panel.dart';
import 'widgets/keyboard_layout.dart';
import 'widgets/letter_keyboard.dart';
import 'widgets/round_info_header.dart';
import 'widgets/round_outcome_banner.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({
    super.key,
    required this.entry,
    required this.category,
    required this.difficulty,
    required this.onRoundFinished,
    this.initialLayout = KeyboardLayout.qwerty,
    this.layoutNotifier,
    this.round,
    this.finishDelay = const Duration(seconds: 2),
  });

  final AnswerEntry entry;
  final AnswerCategory category;
  final Difficulty difficulty;
  final void Function(RoundResult result) onRoundFinished;
  final KeyboardLayout initialLayout;
  final ValueNotifier<KeyboardLayout>? layoutNotifier;
  final GameRound? round;
  final Duration finishDelay;

  @override
  State<GameScreen> createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen> {
  late final GameRound _round;
  late KeyboardLayout _currentLayout;
  String? _hint;
  Timer? _finishTimer;

  GameRound get round => _round;

  @override
  void initState() {
    super.initState();
    _round = widget.round ?? GameRound(answer: widget.entry);
    _currentLayout = widget.layoutNotifier?.value ?? widget.initialLayout;
    widget.layoutNotifier?.addListener(_onLayoutNotifierChanged);
    if (_round.hintUsed && widget.entry.hints.isNotEmpty) {
      _hint = widget.entry.hints.first;
    }
    if (_round.isFinished) {
      _scheduleFinish();
    }
  }

  void _scheduleFinish() {
    if (_finishTimer != null) return;
    _finishTimer = Timer(widget.finishDelay, () {
      if (mounted) {
        widget.onRoundFinished(_round.toResult());
      }
    });
  }

  void _onLayoutNotifierChanged() {
    if (widget.layoutNotifier != null &&
        widget.layoutNotifier!.value != _currentLayout) {
      setState(() {
        _currentLayout = widget.layoutNotifier!.value;
      });
    }
  }

  @override
  void dispose() {
    _finishTimer?.cancel();
    _finishTimer = null;
    widget.layoutNotifier?.removeListener(_onLayoutNotifierChanged);
    super.dispose();
  }

  void _onLayoutChanged(KeyboardLayout newLayout) {
    setState(() {
      _currentLayout = newLayout;
    });
    if (widget.layoutNotifier != null) {
      widget.layoutNotifier!.value = newLayout;
    }
  }

  void _onLetterPressed(String letter) {
    if (_round.isFinished) return;
    setState(() {
      _round.guessLetter(letter);
    });
    if (_round.isFinished) {
      _scheduleFinish();
    }
  }

  void _onHintRequested() {
    if (_round.isFinished) return;
    setState(() {
      _hint = _round.requestHint();
    });
  }

  Future<bool> _confirmAbandon(BuildContext context) async {
    if (_round.isFinished) return true;

    final shouldAbandon = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Abandonar rodada?'),
        content: const Text(
          'A rodada em andamento será cancelada e não será contabilizada nas estatísticas.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Continuar jogando'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Abandonar'),
          ),
        ],
      ),
    );

    return shouldAbandon ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _round.isFinished,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final navigator = Navigator.of(context);
        final confirmed = await _confirmAbandon(context);
        if (confirmed && mounted) {
          navigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Partida'),
          backgroundColor: AppColors.background,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            tooltip: 'Voltar',
            onPressed: () async {
              final confirmed = await _confirmAbandon(context);
              if (confirmed && context.mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
          actions: [
            if (!_round.isFinished)
              IconButton(
                icon: const Icon(Icons.close_rounded),
                tooltip: 'Abandonar rodada',
                onPressed: () async {
                  final confirmed = await _confirmAbandon(context);
                  if (confirmed && context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
              ),
          ],
        ),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.margin,
                  vertical: AppSpacing.sm,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    RoundInfoHeader(
                      category: widget.category,
                      difficulty: widget.difficulty,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      height: 190,
                      child: Center(
                        child: HangmanFigure(
                          errors: _round.currentErrors,
                          maxErrors: _round.maxErrors,
                          status: _round.status,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ErrorProgress(
                      currentErrors: _round.currentErrors,
                      maxErrors: _round.maxErrors,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AnswerBoard(displayedAnswer: _round.displayedAnswer),
                    const SizedBox(height: AppSpacing.lg),
                    HintPanel(
                      hintUsed: _round.hintUsed,
                      hint: _hint,
                      isFinished: _round.isFinished,
                      onHintRequested: _onHintRequested,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    if (_round.isFinished) ...[
                      RoundOutcomeBanner(status: _round.status),
                      const SizedBox(height: AppSpacing.md),
                    ],
                    LetterKeyboard(
                      guessedLetters: _round.guessedLetters,
                      wrongLetters: _round.wrongLetters,
                      isFinished: _round.isFinished,
                      layout: _currentLayout,
                      onLayoutChanged: _onLayoutChanged,
                      onLetterPressed: _onLetterPressed,
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
