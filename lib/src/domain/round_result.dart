import '/src/data/models/answer_entry.dart';
import 'round_status.dart';
 
class RoundResult {
  const RoundResult({
    required this.answerEntry,
    required this.status,
    required this.errorCount,
    required this.hintUsed,
  });
 
  final AnswerEntry answerEntry;
  final RoundStatus status;
  final int errorCount;
  final bool hintUsed;
 
  bool get isVictory => status == RoundStatus.won;
}