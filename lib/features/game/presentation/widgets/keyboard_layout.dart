enum KeyboardLayout {
  qwerty,
  alphabetical;

  String get label => switch (this) {
    KeyboardLayout.qwerty => 'QWERTY',
    KeyboardLayout.alphabetical => 'ABC',
  };

  List<String> get rows => switch (this) {
    KeyboardLayout.qwerty => _qwertyRows,
    KeyboardLayout.alphabetical => _alphabeticalRows,
  };

  List<String> get letters =>
      rows.expand((row) => row.split('')).toList(growable: false);

  static const List<String> _qwertyRows = [
    'QWERTYUIOP',
    'ASDFGHJKL',
    'ZXCVBNM',
  ];

  static const List<String> _alphabeticalRows = [
    'ABCDEFGHI',
    'JKLMNOPQR',
    'STUVWXYZ',
  ];
}
