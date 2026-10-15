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
  static const double _fallbackMaxWidth = 360;
  static const double _minKeyWidth = 16;
  static const double _maxKeyWidth = 48;

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
            child: SizedBox(
              width: 160,
              height: 32,
              child: SegmentedButton<KeyboardLayout>(
                style: SegmentedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: EdgeInsets.zero,
                  textStyle: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                showSelectedIcon: false,
                expandedInsets: EdgeInsets.zero,
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
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final horizontalGap = constraints.maxWidth < 340 ? 3.0 : 4.0;
              const verticalGap = 6.0;
              final maxWidth = constraints.maxWidth.isFinite
                  ? constraints.maxWidth
                  : _fallbackMaxWidth;
              // Reference the widest layout (QWERTY with 10 keys per row) so ABC layout
              // keys match the exact same size as QWERTY keys.
              final referenceMaxCols = KeyboardLayout.qwerty.rows
                  .map((r) => r.length)
                  .reduce(math.max);
              final rawKeyWidth =
                  (maxWidth - (referenceMaxCols - 1) * horizontalGap) /
                  referenceMaxCols;
              final keyWidth = rawKeyWidth.clamp(_minKeyWidth, _maxKeyWidth);

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
                          if (i > 0) SizedBox(width: horizontalGap),
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
