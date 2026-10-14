import 'package:avaliacao_pg_mobile_flutter_01/features/game/presentation/widgets/keyboard_layout.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const expectedAlphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

  group('KeyboardLayout', () {
    test('qwerty layout contains all 26 alphabet letters exactly once', () {
      final letters = KeyboardLayout.qwerty.letters;

      expect(letters.length, 26);
      expect(letters.toSet().length, 26);
      expect(letters.toSet(), expectedAlphabet.split('').toSet());
    });

    test('alphabetical layout contains all 26 alphabet letters exactly once in alphabetical order', () {
      final letters = KeyboardLayout.alphabetical.letters;

      expect(letters.length, 26);
      expect(letters.toSet().length, 26);
      expect(letters.join(''), expectedAlphabet);
    });

    test('each layout has 3 rows with proper letter distribution', () {
      expect(KeyboardLayout.qwerty.rows.length, 3);
      expect(KeyboardLayout.qwerty.rows[0], 'QWERTYUIOP');
      expect(KeyboardLayout.qwerty.rows[1], 'ASDFGHJKL');
      expect(KeyboardLayout.qwerty.rows[2], 'ZXCVBNM');

      expect(KeyboardLayout.alphabetical.rows.length, 3);
      expect(KeyboardLayout.alphabetical.rows[0], 'ABCDEFGHI');
      expect(KeyboardLayout.alphabetical.rows[1], 'JKLMNOPQR');
      expect(KeyboardLayout.alphabetical.rows[2], 'STUVWXYZ');
    });

    test('exposes correct display labels', () {
      expect(KeyboardLayout.qwerty.label, 'QWERTY');
      expect(KeyboardLayout.alphabetical.label, 'ABC');
    });
  });
}
