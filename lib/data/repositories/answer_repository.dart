import '../../domain/enums/answer_category.dart';
import '../../domain/enums/difficulty.dart';
import '../models/answer_entry.dart';

abstract interface class AnswerRepository {
  Future<List<AnswerCategory>> getCategories();

  Future<List<Difficulty>> getDifficulties(AnswerCategory category);

  Future<List<AnswerEntry>> findEntries({
    required AnswerCategory category,
    required Difficulty difficulty,
  });
}
