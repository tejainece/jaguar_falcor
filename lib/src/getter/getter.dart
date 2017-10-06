import 'package:jaguar_falcor/jaguar_falcor.dart';

class Getter {
  static Map<String, dynamic> get(Map path, Map<String, dynamic> data) {
    final ret = <String, dynamic>{};

    for(final field in path.keys) {
      if(!data.containsKey(field)) continue;

      final value = path[field];

      final dv = data[field];
      if(dv is! List && dv is! Map) {
        if(value is bool) {
          if(value) {
            ret[field] = dv;
          }
        }
      } else if(dv is List) {
        if(value is bool) {
          if(value) {
            ret[field] = dv;
          }
        } else if(value is int) {
          if(value < dv.length) {
            ret[field] = dv[value];
          }
        } else if(value is Range) {
          if(value.start < dv.length && value.end <= dv.length) {
            ret[field] = dv.sublist(value.start, value.end);
          }
        } else if(value is Map) {
          // TODO
        }
      } else if(dv is Map) {
        if(value is bool) {
          if(value) {
            ret[field] = dv;
          }
        } else if(value is Map) {
          ret[field] = get(value, dv);
        }
      }
    }

    if(path['*'] == true) {
      for(String key in data.keys) {
        if(path.containsKey(key)) continue;
        ret[key] = data[key];
      }
    }

    return ret;
  }
}