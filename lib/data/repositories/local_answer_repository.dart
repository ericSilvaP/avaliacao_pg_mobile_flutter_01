import '../../domain/enums/answer_category.dart';
import '../../domain/enums/difficulty.dart';
import '../models/answer_entry.dart';
import '../sources/answer_local_data_source.dart';
import 'answer_repository.dart';

final class LocalAnswerRepository implements AnswerRepository {
  LocalAnswerRepository(this._dataSource);

  final AnswerLocalDataSource _dataSource;

  late final Future<List<AnswerEntry>> _entries = _dataSource.loadEntries();

  @override
  Future<List<AnswerCategory>> getCategories() async {
    final entries = await _entries;

    final availableCategories = entries.map((entry) => entry.category).toSet();

    return List.unmodifiable(
      AnswerCategory.values.where(availableCategories.contains),
    );
  }

  @override
  Future<List<Difficulty>> getDifficulties(AnswerCategory category) async {
    final entries = await _entries;

    final availableDifficulties = entries
        .where((entry) => entry.category == category)
        .map((entry) => entry.difficulty)
        .toSet();

    return List.unmodifiable(
      Difficulty.values.where(availableDifficulties.contains),
    );
  }

  @override
  Future<List<AnswerEntry>> findEntries({
    required AnswerCategory category,
    required Difficulty difficulty,
  }) async {
    final entries = await _entries;

    return List.unmodifiable(
      entries.where(
        (entry) => entry.category == category && entry.difficulty == difficulty,
      ),
    );
  }
}
