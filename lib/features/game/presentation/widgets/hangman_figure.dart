import 'package:flutter/material.dart';

import '../../../../domain/round_status.dart';

abstract final class HangmanAssets {
  HangmanAssets._();

  static const String gallows = 'assets/images/hangman/gallows.png';
  static const String head = 'assets/images/hangman/head.png';
  static const String headDead = 'assets/images/hangman/head_dead.png';
  static const String torso = 'assets/images/hangman/torso.png';
  static const String armLeft = 'assets/images/hangman/arm_left.png';
  static const String armRight = 'assets/images/hangman/arm_right.png';
  static const String legLeft = 'assets/images/hangman/leg_left.png';
  static const String legRight = 'assets/images/hangman/leg_right.png';
}

class HangmanFigure extends StatelessWidget {
  const HangmanFigure({
    super.key,
    required this.errors,
    this.status = RoundStatus.inProgress,
    this.gallowsAsset = HangmanAssets.gallows,
    this.headAsset = HangmanAssets.head,
    this.headDeadAsset = HangmanAssets.headDead,
    this.torsoAsset = HangmanAssets.torso,
    this.armLeftAsset = HangmanAssets.armLeft,
    this.armRightAsset = HangmanAssets.armRight,
    this.legLeftAsset = HangmanAssets.legLeft,
    this.legRightAsset = HangmanAssets.legRight,
  });

  static const int bodyPartCount = 6;

  final int errors;
  final RoundStatus status;

  final String gallowsAsset;
  final String headAsset;
  final String headDeadAsset;
  final String torsoAsset;
  final String armLeftAsset;
  final String armRightAsset;
  final String legLeftAsset;
  final String legRightAsset;

  List<String> get _bodyParts {
    final activeHead = status == RoundStatus.lost ? headDeadAsset : headAsset;
    return [
      activeHead,
      torsoAsset,
      armLeftAsset,
      armRightAsset,
      legLeftAsset,
      legRightAsset,
    ];
  }

  String get _semanticLabel {
    if (status == RoundStatus.lost) {
      return 'Forca completa: boneco enforcado, rodada perdida';
    }
    if (errors == 0) {
      return 'Forca vazia, nenhum erro cometido';
    }
    return 'Forca com $errors de ${HangmanFigure.bodyPartCount} erros';
  }

  @override
  Widget build(BuildContext context) {
    final parts = _bodyParts;
    final visibleCount = errors.clamp(0, parts.length);

    return Semantics(
      label: _semanticLabel,
      image: true,
      excludeSemantics: true,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(gallowsAsset, fit: BoxFit.contain),
            for (var i = 0; i < visibleCount; i++)
              Image.asset(parts[i], fit: BoxFit.contain),
          ],
        ),
      ),
    );
  }
}
