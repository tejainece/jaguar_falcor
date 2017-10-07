// Copyright (c) 2017, SERAGUD. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'package:jaguar_falcor/jaguar_falcor.dart';

class Model {
  final Map<String, dynamic> cache = <String, dynamic>{};

  Model({Map<String, dynamic> cache}) {
    if (cache != null) this.cache.addAll(cache);
  }

  dynamic exec(String path, List args) {
    // TODO
  }

  FutureOr<dynamic> get(String path) {
    final Map compiled = compile(path);
    return Getter.get(compiled, cache);
  }

  /* TODO
  dynamic set(List<PathValue> values) {
    // TODO
  }
  */
}
