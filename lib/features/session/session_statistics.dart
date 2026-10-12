import 'round_outcome.dart';

class SessionStatistics {
  int _completedRounds = 0;
  int _victories = 0;
  int _defeats = 0;
  int _totalErrors = 0;
  int _hintsUsed = 0;

  int get completedRounds => _completedRounds;

  int get victories => _victories;

  int get defeats => _defeats;

  int get totalErrors => _totalErrors;

  int get hintsUsed => _hintsUsed;

  double get victoryPercentage => _percentageOf(_victories);

  double get defeatPercentage => _percentageOf(_defeats);

  void register(RoundOutcome outcome) {
    _completedRounds++;

    switch (outcome.type) {
      case RoundOutcomeType.victory:
        _victories++;
      case RoundOutcomeType.defeat:
        _defeats++;
    }

    _totalErrors += outcome.errorCount;

    if (outcome.hintUsed) {
      _hintsUsed++;
    }
  }

  void reset() {
    _completedRounds = 0;
    _victories = 0;
    _defeats = 0;
    _totalErrors = 0;
    _hintsUsed = 0;
  }

  double _percentageOf(int value) {
    if (_completedRounds == 0) {
      return 0;
    }

    return value / _completedRounds * 100;
  }
}
