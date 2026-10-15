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
import 'widgets/game_status_slot.dart';
import 'widgets/hangman_figure.dart';
import 'widgets/keyboard_layout.dart';
import 'widgets/letter_keyboard.dart';
import 'widgets/round_info_header.dart';

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
    this.finishDelay = const Duration(seconds: 5),
  });

  static const double wideLayoutBreakpoint = 768.0;
  static const double narrowHangmanPanelHeight = 190;
  static const double wideHangmanPanelHeight = 240;
  static const double narrowContentMaxWidth = 480;
  static const double wideContentMaxWidth = 960;
  static const int wideLeftPanelFlex = 4;
  static const int wideRightPanelFlex = 6;

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
  KeyboardLayout get currentLayout => _currentLayout;

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
        ),
        body: SafeArea(
          child: Center(
            child:
                MediaQuery.sizeOf(context).width >=
                    GameScreen.wideLayoutBreakpoint
                ? _buildWideLayout(context)
                : _buildNarrowLayout(context),
          ),
        ),
      ),
    );
  }

  Widget _buildRoundInfoHeader() {
    return RoundInfoHeader(
      category: widget.category,
      difficulty: widget.difficulty,
    );
  }

  Widget _buildHangmanPanel(double height) {
    return SizedBox(
      height: height,
      child: Center(
        child: HangmanFigure(
          errors: _round.currentErrors,
          status: _round.status,
        ),
      ),
    );
  }

  Widget _buildErrorProgress() {
    return ErrorProgress(
      currentErrors: _round.currentErrors,
      maxErrors: _round.maxErrors,
    );
  }

  Widget _buildAnswerBoard() {
    return AnswerBoard(displayedAnswer: _round.displayedAnswer);
  }

  Widget _buildStatusSlot() {
    return GameStatusSlot(
      status: _round.status,
      hintUsed: _round.hintUsed,
      hint: _hint,
      onHintRequested: _onHintRequested,
    );
  }

  Widget _buildKeyboard() {
    return LetterKeyboard(
      guessedLetters: _round.guessedLetters,
      wrongLetters: _round.wrongLetters,
      isFinished: _round.isFinished,
      layout: _currentLayout,
      onLayoutChanged: _onLayoutChanged,
      onLetterPressed: _onLetterPressed,
    );
  }

  Widget _buildNarrowLayout(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final minHeight = constraints.maxHeight.isFinite
            ? (constraints.maxHeight - (AppSpacing.md * 2)).clamp(
                0.0,
                double.infinity,
              )
            : 0.0;

        return SingleChildScrollView(
          key: const Key('game-narrow-layout'),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.margin,
            vertical: AppSpacing.md,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: minHeight,
              maxWidth: GameScreen.narrowContentMaxWidth,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildRoundInfoHeader(),
                    const SizedBox(height: AppSpacing.lg),
                    _buildHangmanPanel(GameScreen.narrowHangmanPanelHeight),
                    const SizedBox(height: AppSpacing.md),
                    _buildErrorProgress(),
                    const SizedBox(height: AppSpacing.xl),
                    _buildAnswerBoard(),
                    const SizedBox(height: AppSpacing.lg),
                    _buildStatusSlot(),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.md),
                  child: _buildKeyboard(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWideLayout(BuildContext context) {
    return ConstrainedBox(
      key: const Key('game-wide-layout'),
      constraints: const BoxConstraints(
        maxWidth: GameScreen.wideContentMaxWidth,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.margin,
          vertical: AppSpacing.md,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: GameScreen.wideLeftPanelFlex,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHangmanPanel(GameScreen.wideHangmanPanelHeight),
                  const SizedBox(height: AppSpacing.md),
                  _buildErrorProgress(),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              flex: GameScreen.wideRightPanelFlex,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildRoundInfoHeader(),
                  const SizedBox(height: AppSpacing.md),
                  _buildAnswerBoard(),
                  const SizedBox(height: AppSpacing.md),
                  _buildStatusSlot(),
                  const SizedBox(height: AppSpacing.md),
                  _buildKeyboard(),
                  const SizedBox(height: AppSpacing.md),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
