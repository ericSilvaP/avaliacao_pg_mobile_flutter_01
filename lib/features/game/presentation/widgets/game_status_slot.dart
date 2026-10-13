import 'package:flutter/material.dart';

import '../../../../src/domain/round_status.dart';
import 'hint_panel.dart';
import 'round_outcome_banner.dart';

/// Contêiner de altura estável que abriga o painel de dica durante a partida
/// e faz a transição suave para o banner de resultado quando a rodada termina.
///
/// Garante que o teclado posicionado abaixo não sofra saltos abruptos ("layout jumping")
/// quando a dica é revelada ou quando a rodada é finalizada.
class GameStatusSlot extends StatelessWidget {
  const GameStatusSlot({
    super.key,
    required this.status,
    required this.hintUsed,
    this.hint,
    this.onHintRequested,
  });

  final RoundStatus status;
  final bool hintUsed;
  final String? hint;
  final VoidCallback? onHintRequested;

  @override
  Widget build(BuildContext context) {
    final isFinished = status != RoundStatus.inProgress;

    final child = isFinished
        ? RoundOutcomeBanner(
            key: const ValueKey('outcome-banner'),
            status: status,
          )
        : HintPanel(
            key: const ValueKey('hint-panel'),
            hintUsed: hintUsed,
            hint: hint,
            isFinished: false,
            onHintRequested: onHintRequested,
          );

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 76.0),
      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          child: child,
        ),
      ),
    );
  }
}
