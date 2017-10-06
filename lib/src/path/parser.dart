part of jaguar.falcor.path;

/// Compiler [PathBuilder] from path string
///
///     PathParser.parse('todos.name');
class PathParser {
  static List<dynamic> parse(String path) {
    List<int> chars = path.codeUnits.toList();

    final segments = parseSubtree(chars);

    if (chars.length != 0) throw new Exception('Invalid path!');

    return segments;
  }

  static bool isVar(int char) {
    // Alphabets
    if (char >= 65 && char <= 90)
      return true;
    // Alphabets
    else if (char >= 97 && char <= 122)
      return true;
    // Numbers
    else if (char >= 48 && char <= 57)
      return true;
    // Underscore
    else if (char == 95)
      return true;
    // Star
    else if (char == 42) return true;

    return false;
  }

  static bool isWhitespace(int char) {
    // Space
    if (char == 32) return true;
    // Tab
    if (char == 9) return true;
    // Line feed
    if (char == 10) return true;
    // Carriage return
    if (char == 13) return true;

    return false;
  }

  static String parseField(List<int> chars) {
    int i = 0;
    for (; i < chars.length; i++) {
      final int char = chars[i];

      if (isVar(char)) continue;

      // '.'
      if (char == 46) break;
      // '[' or ']'
      if (char == 91 || char == 93) break;
      // '{' or '}'
      if (char == 123 || char == 125) break;
      // ','
      if (char == 44) break;

      throw new Exception('Invalid path!');
    }

    final String field = new String.fromCharCodes(chars, 0, i);

    chars.removeRange(0, i);
    return field;
  }

  static dynamic /* int | Range */ parseSubscript(List<int> chars) {
    int i = 0;

    // '['
    if (chars.first != 91) throw new Exception('Invalid path!');
    i++;

    for (; i < chars.length; i++) {
      final int char = chars[i];

      if (char >= 48 && char <= 57) continue;

      // ':'
      if (char == 58) continue;
      // ']'
      if (char == 93) break;

      throw new Exception('Invalid path!');
    }

    if (i == chars.length) throw new Exception('Invalid path!');

    String field = new String.fromCharCodes(chars, 1, i);
    chars.removeRange(0, i + 1);

    final int subscript = int.parse(field, onError: (_) => null);
    if (subscript is int) return subscript;

    final List<String> ranges = field.split(':');
    if (ranges.length != 2) throw new Exception('Invalid path!');

    final int start = int.parse(ranges.first, onError: (_) => null);
    if (start is! int) throw new Exception('Invalid path!');

    final int end = int.parse(ranges.last, onError: (_) => null);
    if (end is! int) throw new Exception('Invalid path!');

    if (start < 0 || end < 0) throw new Exception('Invalid path!');

    if (end <= start) throw new Exception('Invalid path!');

    return new Range(start, end);
  }

  static Map parseSubDocument(List<int> chars) {
    final segments = {};

    int i = 0;

    // '{'
    if (chars.first != 123) throw new Exception('Invalid path!');
    i++;

    for (; i < chars.length; i++) {
      i += _countLeadingWhitespace(chars, i);
      if (i == chars.length) break;
      int char = chars[i];

      if (isVar(char)) {
        final subList = chars.sublist(i);
        final field = parseSubtree(subList);
        segments[field] = true;
        // Update i
        i = chars.length - subList.length;

        if (i == chars.length) break;

        char = chars[i];

        /* TODO
        // '.'
        if (char == 46) {
          i++;
          if (i == chars.length) break;
          char = chars[i];

          i += _countLeadingWhitespace(chars, i);
          if (i == chars.length) break;
          char = chars[i];
          if (char != 123) throw new Exception('Invalid path!');
        }

        // '{'
        if (char == 123) {
          i += _countLeadingWhitespace(chars, i);
          if (i == chars.length) break;

          final List<int> subList = chars.sublist(i);
          segments[field] = parseSubDocument(subList);

          // Update i
          i = chars.length - subList.length;
          if (i == chars.length) break;
          char = chars[i];
        } else {
          segments[field] = true;
        }
        */

        // ','
        if (char == 44) {
          continue;
        }

        i += _countLeadingWhitespace(chars, i);
        if (i == chars.length) break;
        char = chars[i];

        // '}'
        if (char == 125) break;

        throw new Exception('Invalid path!');
      }

      i += _countLeadingWhitespace(chars, i);
      if (i == chars.length) break;
      char = chars[i];

      // '}'
      if (char == 125) break;

      throw new Exception('Invalid path!');
    }

    if (i == chars.length) throw new Exception('Invalid path!');
    chars.removeRange(0, i + 1);

    return segments;
  }

  static List<dynamic> parseSubtree(List<int> chars) {
    final segments = <dynamic>[];

    /* TODO
    if (isVar(chars.first)) {
      segments.add(parseField(chars));
      // '.'
      if (chars.length > 0 && chars.first == 46) {
        chars.removeAt(0);
      }
    } else
      throw new Exception('Invalid path!');
      */

    while (chars.length > 0) {
      // Trim whitespace
      if(_removeLeadingWhitespace(chars) != 0) continue;

      final int char = chars.first;

      if (isVar(char)) {
        segments.add(parseField(chars));
        // '.'
        if (chars.length > 0 && chars.first == 46) {
          chars.removeAt(0);
        }
        // TODO must be followed by valid construct
        continue;
      }
      // '['
      if (char == 91) {
        segments.add(parseSubscript(chars));
        // '.'
        if (chars.length > 0 && chars.first == 46) {
          chars.removeAt(0);
        }
        continue;
      }
      // '{'
      if (char == 123) {
        segments.add(parseSubDocument(chars));
        continue;
      }
      // '}'
      if (char == 125) break;
      // ','
      if (char == 44) break;

      throw new Exception('Invalid path!');
    }

    return segments;
  }

  static int _countLeadingWhitespace(List<int> chars, int start) {
    int ret = 0;
    for (int i = start; i < chars.length; i++) {
      final int char = chars[i];
      if (isWhitespace(char)) {
        ret++;
        continue;
      }
      break;
    }
    return ret;
  }

  static int _removeLeadingWhitespace(List<int> chars) {
    int ret = 0;
    for (int i = 0; i < chars.length; i++) {
      final int char = chars[i];
      if (isWhitespace(char)) {
        ret++;
        continue;
      }
      break;
    }
    if(ret > 0) chars.removeRange(0, ret);
    return ret;
  }
}
