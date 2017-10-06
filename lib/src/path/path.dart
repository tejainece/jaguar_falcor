library jaguar.falcor.path;

import 'package:jaguar_falcor/jaguar_falcor.dart';

part 'compile.dart';
part 'parser.dart';

/// Holds information about array range operator
class Range {
  /// Start of the range
  final int start;

  /// End of the range
  final int end;

  /// Build range from [start] and [end]
  Range(this.start, this.end);

  bool operator ==(other) {
    if (other is Range) return other.start == start && other.end == end;
    return false;
  }

  String toString() => '[$start:$end]';
}

Map compile(String path) => Compiler.compile(PathParser.parse(path));
