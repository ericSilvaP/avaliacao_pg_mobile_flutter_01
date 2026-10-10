import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/answer_entry.dart';

class AnswerLocalDataSource {
  AnswerLocalDataSource({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;

  static const String _assetPath = 'assets/data/hangman.json';

  final AssetBundle _bundle;

  Future<List<AnswerEntry>> loadEntries() async {
    try {
      final jsonString = await _bundle.loadString(_assetPath);

      final decoded = jsonDecode(jsonString);

      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Invalid JSON root structure.');
      }

      final rawEntries = decoded['entries'];

      if (rawEntries is! List || rawEntries.isEmpty) {
        throw const FormatException('Invalid or empty entries list.');
      }

      final entries = <AnswerEntry>[];

      for (final item in rawEntries) {
        if (item is! Map<String, dynamic>) {
          throw const FormatException('Invalid answer entry structure.');
        }

        entries.add(AnswerEntry.fromJson(item));
      }

      return List.unmodifiable(entries);
    } on FormatException {
      rethrow;
    } catch (error) {
      throw Exception('Failed to load answer asset: $error');
    }
  }
}
