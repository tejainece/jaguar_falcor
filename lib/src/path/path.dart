class Range {
  int start;

  int end;

  Range(this.start, this.end);

  String toString() => '[$start:$end]';
}

class Path {
  final List<dynamic> segments = <dynamic>[];

  Path();

  Path.parse(String path) {
    // TODO
  }

  void field(String name) {
    segments.add(name);
  }

  void subscript(int index) {
    segments.add(index);
  }

  void range(int start, int end) {
    segments.add(new Range(start, end));
  }

  String toString() {
    if (segments.length == 0) return null;

    final sb = new StringBuffer();

    Iterator ite = segments.iterator;

    ite.moveNext();
    sb.write(ite.current.toString());

    while (ite.moveNext()) {
      sb.write('.');
      sb.write(ite.current.toString());
    }

    return sb.toString();
  }

  static Path define(String field) {
    return new Path()..field(field);
  }
}

class PathParser {
  static List<dynamic> parse(String path) {
    final segments = <dynamic>[];

    List<int> chars = path.codeUnits.toList();

    if (isVar(chars.first)) {
      segments.add(parseField(chars));
      // '.'
      if (chars.length > 0 && chars.first == 46) {
        chars.removeAt(0);
        if (chars.length == 0) throw new Exception('Invalid path!');
      }
    } else
      throw new Exception('Invalid path!');

    while (chars.length > 0) {
      final int char = chars.first;
      if (isVar(char)) {
        segments.add(parseField(chars));
        // '.'
        if (chars.length > 0 && chars.first == 46) {
          chars.removeAt(0);
          if (chars.length == 0) throw new Exception('Invalid path!');
        }
        continue;
      } else if (char == 91) {
        segments.add(parseSubscript(chars));
        continue;
      } else if (char == 123) {
        segments.add(parseSubDocument(chars));
        if (chars.length != 0) throw new Exception('Invalid path!');
        continue;
      }

      throw new Exception('Invalid path!');
    }

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
    else if (char == 95) return true;

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

  static Map<String, dynamic> parseSubDocument(List<int> chars) {
    final segments = <String, dynamic>{};

    int i = 0;

    // '{'
    if (chars.first != 123) throw new Exception('Invalid path!');
    i++;

    for (; i < chars.length; i++) {
      int char = chars[i];

      if (isVar(char)) {
        final subList = chars.sublist(i);
        final String field = parseField(subList);
        // Update i
        i = chars.length - subList.length;

        if (i == chars.length) break;

        char = chars[i];

        // '.'
        if (char == 46) {
          i++;
          if (i == chars.length) break;
          char = chars[i];
        }

        // '{'
        if (char == 123) {
          final List<int> subList = chars.sublist(i);
          segments[field] = parseSubDocument(subList);

          // Update i
          i = chars.length - subList.length;
          if (i == chars.length) break;
          char = chars[i];
        } else {
          segments[field] = true;
        }

        // ','
        if (char == 44) continue;

        // '}'
        if (char == 125) break;

        throw new Exception('Invalid path!');
      }

      // '}'
      if (char == 125) break;

      throw new Exception('Invalid path!');
    }

    if (i == chars.length) throw new Exception('Invalid path!');
    chars.removeRange(0, i + 1);

    return segments;
  }
}