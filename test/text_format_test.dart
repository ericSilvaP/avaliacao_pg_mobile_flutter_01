import 'package:avaliacao_pg_mobile_flutter_01/src/domain/text_format.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TextFormat', () {
    test('uppercases and removes accents', () {
      expect(TextFormat.format('ação'), 'ACAO');
      expect(TextFormat.format('ñandú'), 'NANDU');
      expect(TextFormat.format('coração'), 'CORACAO');
    });

    test('isPlayableLetter accepts only uppercase letters', () {
      expect(TextFormat.isPlayableLetter('A'), isTrue);
      expect(TextFormat.isPlayableLetter('Z'), isTrue);
      expect(TextFormat.isPlayableLetter('a'), isFalse);
      expect(TextFormat.isPlayableLetter(' '), isFalse);
      expect(TextFormat.isPlayableLetter('Ç'), isFalse);
      expect(TextFormat.isPlayableLetter('1'), isFalse);
    });
  });
}
