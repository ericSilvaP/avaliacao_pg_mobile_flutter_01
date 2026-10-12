abstract final class TextFormat {
  static const Map<String, String> _accentMap = {
    'Á': 'A',
    'À': 'A',
    'Â': 'A',
    'Ã': 'A',
    'Ä': 'A',
    'É': 'E',
    'È': 'E',
    'Ê': 'E',
    'Ë': 'E',
    'Í': 'I',
    'Ì': 'I',
    'Î': 'I',
    'Ï': 'I',
    'Ó': 'O',
    'Ò': 'O',
    'Ô': 'O',
    'Õ': 'O',
    'Ö': 'O',
    'Ú': 'U',
    'Ù': 'U',
    'Û': 'U',
    'Ü': 'U',
    'Ç': 'C',
    'Ñ': 'N',
  };

  static final RegExp _letterPattern = RegExp(r'^[A-Z]$');

  static String format(String text) {
    final upper = text.toUpperCase();
    final buffer = StringBuffer();
    for (final char in upper.split('')) {
      buffer.write(_accentMap[char] ?? char);
    }
    return buffer.toString();
  }

  static bool isPlayableLetter(String formatChar) =>
      _letterPattern.hasMatch(formatChar);
}
