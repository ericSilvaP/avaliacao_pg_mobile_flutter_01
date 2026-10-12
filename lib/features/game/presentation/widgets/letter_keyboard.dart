import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../shared/theme/app_theme.dart';
import 'keyboard_layout.dart';
import 'letter_key.dart';

class LetterKeyboard extends StatefulWidget {
  const LetterKeyboard({
    super.key,
    required this.guessedLetters,
    required this.wrongLetters,
    this.isFinished = false,
    required this.onLetterPressed,
    this.initialLayout = KeyboardLayout.qwerty,
    this.layout,
    this.onLayoutChanged,
  });

  final Set<String> guessedLetters;
  final Set<String> wrongLetters;
  final bool isFinished;
  final ValueChanged<String> onLetterPressed;
  final KeyboardLayout initialLayout;
  final KeyboardLayout? layout;
  final ValueChanged<KeyboardLayout>? onLayoutChanged;

  @override
  State<LetterKeyboard> createState() => _LetterKeyboardState();
}

class _LetterKeyboardState extends State<LetterKeyboard> {
  late KeyboardLayout _internalLayout = widget.initialLayout;

  KeyboardLayout get _effectiveLayout => widget.layout ?? _internalLayout;

  void _onSelectLayout(KeyboardLayout newLayout) {
    if (newLayout == _effectiveLayout) return;
    if (widget.layout == null) {
      setState(() => _internalLayout = newLayout);
    }
    widget.onLayoutChanged?.call(newLayout);
  }

  LetterKeyState _stateFor(String letter) {
    if (widget.wrongLetters.contains(letter)) {
      return LetterKeyState.miss;
    }
    if (widget.guessedLetters.contains(letter)) {
      return LetterKeyState.hit;
    }
    return widget.isFinished
        ? LetterKeyState.disabled
        : LetterKeyState.available;
  }

  @override
  Widget build(BuildContext context) {
    final currentLayout = _effectiveLayout;

    return Semantics(
      label: 'Teclado de letras',
      container: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: SegmentedButton<KeyboardLayout>(
              segments: [
                for (final option in KeyboardLayout.values)
                  ButtonSegment<KeyboardLayout>(
                    value: option,
                    label: Text(option.label),
                  ),
              ],
              selected: {currentLayout},
              onSelectionChanged: (selected) {
                if (selected.isNotEmpty) {
                  _onSelectLayout(selected.first);
                }
              },
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              const horizontalGap = 4.0;
              const verticalGap = 6.0;
              final maxWidth = constraints.maxWidth.isFinite
                  ? constraints.maxWidth
                  : 360.0;
              final maxCols = currentLayout.rows
                  .map((r) => r.length)
                  .reduce(math.max);
              final rawKeyWidth =
                  (maxWidth - (maxCols - 1) * horizontalGap) / maxCols;
              final keyWidth = rawKeyWidth.clamp(28.0, 48.0);

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var r = 0; r < currentLayout.rows.length; r++) ...[
                    if (r > 0) const SizedBox(height: verticalGap),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (
                          var i = 0;
                          i < currentLayout.rows[r].length;
                          i++
                        ) ...[
                          if (i > 0) const SizedBox(width: horizontalGap),
                          SizedBox(
                            width: keyWidth,
                            child: LetterKey(
                              letter: currentLayout.rows[r][i],
                              state: _stateFor(currentLayout.rows[r][i]),
                              onPressed: () => widget.onLetterPressed(
                                currentLayout.rows[r][i],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
