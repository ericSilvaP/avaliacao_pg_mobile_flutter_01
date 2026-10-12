enum RoundOutcomeType { victory, defeat }

class RoundOutcome {
  RoundOutcome({
    required this.type,
    required this.answer,
    required this.errorCount,
    required this.hintUsed,
  }) {
    if (errorCount < 0) {
      throw ArgumentError.value(
        errorCount,
        'errorCount',
        'Error count cannot be negative.',
      );
    }
  }

  final RoundOutcomeType type;
  final String answer;
  final int errorCount;
  final bool hintUsed;
}
