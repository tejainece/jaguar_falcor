part of jaguar.falcor.path;

class Compiler {
  static Map compile(List path) {
    final root = {};

    Map preTail = null;
    Map tail = root;

    for (int i = 0; i < path.length; i++) {
      final seg = path[i];
      if (seg is String) {
        preTail = tail;
        tail = {};
        preTail[seg] = tail;
      } else if (seg is int) {
        if (i == path.length - 1) {
          preTail[preTail.keys.first] = seg;
        } else {
          preTail[preTail.keys.first] = array(new Range(seg, seg + 1), tail);
        }
      } else if (seg is Range) {
        if (i == path.length - 1) {
          preTail[preTail.keys.first] = seg;
        } else {
          preTail[preTail.keys.first] = array(seg, tail);
        }
      } else if (seg is Map) {
        if (i != path.length - 1) {
          throw new Exception('Invalid path!');
        }
        for (final key in seg.keys) {
          tail.addAll(compile(key));
          if (seg[key] != true) {
            throw new UnimplementedError();
          }
        }
      } else {
        throw new UnimplementedError();
      }
      // TODO
    }

    // Clip tails
    clipTails(root);

    return root;
  }

  static void clipTails(Map map) {
    for (final key in map.keys) {
      final value = map[key];

      if (value is Map) {
        if (value.length == 0) {
          map[key] = true;
        } else {
          clipTails(value);
        }
      } else if (value is ArrayLookup) {
        if (value.path.length == 0) {
          throw new Exception('Invalid path!');
        } else {
          clipTails(value.path);
        }
      }
    }
  }
}
