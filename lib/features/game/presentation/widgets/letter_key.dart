import 'package:flutter/material.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_theme.dart';

enum LetterKeyState {
  available,
  hit,
  miss,
  disabled;

  bool get isInteractive => this == LetterKeyState.available;
}

class LetterKey extends StatelessWidget {
  const LetterKey({
    super.key,
    required this.letter,
    this.state = LetterKeyState.available,
    this.onPressed,
  }) : assert(letter.length == 1, 'letter must be a single character');

  final String letter;
  final LetterKeyState state;
  final VoidCallback? onPressed;

  bool get _isClickable => state.isInteractive && onPressed != null;

  String get _semanticsLabel {
    return switch (state) {
      LetterKeyState.available => 'Letra $letter',
      LetterKeyState.hit => 'Letra $letter, correta',
      LetterKeyState.miss => 'Letra $letter, incorreta',
      LetterKeyState.disabled => 'Letra $letter, desabilitada',
    };
  }

  Color get _backgroundColor {
    return switch (state) {
      LetterKeyState.available => AppColors.keySurface,
      LetterKeyState.hit => AppColors.secondaryContainer,
      LetterKeyState.miss => AppColors.exhaustedKeySurface,
      LetterKeyState.disabled => AppColors.exhaustedKeySurface,
    };
  }

  Color get _textColor {
    return switch (state) {
      LetterKeyState.available => AppColors.textHigh,
      LetterKeyState.hit => AppColors.accent,
      LetterKeyState.miss => AppColors.exhaustedKeyText,
      LetterKeyState.disabled => AppColors.disabledText,
    };
  }

  BorderSide get _borderSide {
    return switch (state) {
      LetterKeyState.hit => const BorderSide(
        color: AppColors.accent,
        width: 1.5,
      ),
      LetterKeyState.available => const BorderSide(
        color: AppColors.outlineVariant,
        width: 1,
      ),
      _ => BorderSide.none,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: _semanticsLabel,
      button: _isClickable,
      enabled: _isClickable,
      excludeSemantics: true,
      child: Material(
        color: _backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.base),
          side: _borderSide,
        ),
        child: InkWell(
          onTap: _isClickable ? onPressed : null,
          borderRadius: BorderRadius.circular(AppRadius.base),
          child: Container(
            constraints: const BoxConstraints(minHeight: 44, minWidth: 28),
            alignment: Alignment.center,
            child: Text(
              letter,
              style: AppTextStyles.runeLabel.copyWith(color: _textColor),
            ),
          ),
        ),
      ),
    );
  }
}
