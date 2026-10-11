import 'package:flutter/material.dart';

import 'app.dart';
import 'data/repositories/local_answer_repository.dart';
import 'data/sources/answer_local_data_source.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final repository = LocalAnswerRepository(AnswerLocalDataSource());
  runApp(HangmanApp(repository: repository));
}
