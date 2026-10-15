import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_theme.dart';

class AnswerBoard extends StatelessWidget {
  const AnswerBoard({super.key, required this.displayedAnswer});

  static const double _fallbackMaxWidth = 360;
  static const double _minCellWidth = 14;
  static const double _maxCellWidth = 36;
  static const double _minCellHeight = 22;
  static const double _maxCellHeight = 48;
  static const double _minFontSize = 11;
  static const double _maxFontSize = 22;
  static const double _minWordSpacing = 10;
  static const double _maxWordSpacing = 18;
  static const double _minRunSpacing = 8;
  static const double _maxRunSpacing = 16;

  final String displayedAnswer;

  static final RegExp _letterRegex = RegExp(r'^\p{L}$', unicode: true);

  String get _semanticLabel {
    final buffer = StringBuffer('Palavra: ');
    for (var i = 0; i < displayedAnswer.length; i++) {
      final char = displayedAnswer[i];
      if (char == '_') {
        buffer.write('letra oculta ');
      } else if (char == ' ') {
        buffer.write('espaço ');
      } else if (char == '-') {
        buffer.write('hífen ');
      } else {
        buffer.write('$char ');
      }
    }
    return buffer.toString().trim();
  }

  Widget _buildCell(String char, double width, double height, double fontSize) {
    final isHidden = char == '_';
    final isLetterChar = !isHidden && _letterRegex.hasMatch(char);

    if (!isHidden && !isLetterChar) {
      return SizedBox(
        width: width * 0.7,
        height: height,
        child: Center(
          child: Text(
            char,
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.accent,
            ),
          ),
        ),
      );
    }

    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isHidden
            ? AppColors.surfaceContainerLowest
            : AppColors.cardSurface,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border(
          bottom: BorderSide(
            color: isHidden ? AppColors.accent : AppColors.primary,
            width: isHidden ? 2.5 : 2.0,
          ),
        ),
      ),
      child: isHidden
          ? null
          : Text(
              char,
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: fontSize,
                fontWeight: FontWeight.w700,
                color: AppColors.textHigh,
              ),
            ),
    );
  }

  Widget _buildWord(
    String word,
    double cellWidth,
    double cellHeight,
    double fontSize,
    double cellGap,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < word.length; i++) ...[
          if (i > 0) SizedBox(width: cellGap),
          _buildCell(word[i], cellWidth, cellHeight, fontSize),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final words = displayedAnswer.split(' ');

    return Semantics(
      label: _semanticLabel,
      container: true,
      excludeSemantics: true,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth.isFinite
              ? constraints.maxWidth
              : _fallbackMaxWidth;
          final longestWordLength = words.isEmpty
              ? 1
              : words.map((w) => w.length).reduce(math.max);

          final cellGap = longestWordLength > 12 ? 2.0 : 4.0;
          final availableForLongest =
              maxWidth - (longestWordLength - 1) * cellGap;
          final calculatedWidth = availableForLongest / longestWordLength;
          final cellWidth = calculatedWidth.clamp(_minCellWidth, _maxCellWidth);
          final cellHeight = (cellWidth * 1.3).clamp(
            _minCellHeight,
            _maxCellHeight,
          );
          final fontSize = (cellWidth * 0.65).clamp(_minFontSize, _maxFontSize);
          final wordSpacing = (cellWidth * 0.7).clamp(
            _minWordSpacing,
            _maxWordSpacing,
          );
          final runSpacing = (cellHeight * 0.35).clamp(
            _minRunSpacing,
            _maxRunSpacing,
          );

          return Wrap(
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.center,
            spacing: wordSpacing,
            runSpacing: runSpacing,
            children: [
              for (final word in words)
                _buildWord(word, cellWidth, cellHeight, fontSize, cellGap),
            ],
          );
        },
      ),
    );
  }
}
