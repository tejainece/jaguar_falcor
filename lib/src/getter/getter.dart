import 'package:jaguar_falcor/jaguar_falcor.dart';

class Getter {
  static Map<String, dynamic> get(
      Map<String, dynamic> path, Map<String, dynamic> data) {
    final ret = <String, dynamic>{};

    for (final String field in path.keys) {
      if (!data.containsKey(field)) continue;

      final value = path[field];
      final dv = data[field];

      if (dv is! List && dv is! Map) {
        if (value is bool) {
          if (value) {
            ret[field] = dv;
          }
        }
      } else if (dv is List) {
        if (value is bool) {
          if (value) {
            ret[field] = dv;
          }
        } else if (value is int) {
          if (value < dv.length) {
            ret[field] = dv[value];
          }
        } else if (value is Range) {
          int start = value.start ?? 0;
          if (start < dv.length) {
            int end = value.end ?? dv.length;
            if (end > dv.length) end = dv.length;
            ret[field] = dv.sublist(start, end);
          }
        } else if (value is ArrayLookup) {
          ret[field] = arrayLookup(value, dv);
        }
      } else if (dv is Map) {
        if (value is bool) {
          if (value) {
            ret[field] = dv;
          }
        } else if (value is Map) {
          ret[field] = get(value, dv);
        }
      }
    }

    if (path['*'] == true) {
      for (String key in data.keys) {
        if (path.containsKey(key)) continue;
        ret[key] = data[key];
      }
    }

    return ret;
  }

  static List arrayLookup(ArrayLookup lookup, List data) {
    final Range range = lookup.range;

    int start = range.start ?? 0;

    if (start >= data.length) return null;

    final ret = [];

    int len = range.end ?? data.length;
    if (len > data.length) len = data.length;

    for (int i = start; i < len; i++) {
      ret.add(get(lookup.path, data[i]));
    }

    return ret;
  }
}

class ArrayLookup {
  final Range range;

  final Map path;

  ArrayLookup(this.range, this.path);

  String toString() => {'\$range': range, '\$path': path}.toString();
}

ArrayLookup array(Range range, Map path) => new ArrayLookup(range, path);
