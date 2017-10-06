// Copyright (c) 2017, SERAGUD. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';

class PathValue {
  // TODO
}

class Model {
  final Map<String, dynamic> cache = <String, dynamic>{};

  Model({Map<String, dynamic> cache}) {
    if (cache != null) this.cache.addAll(cache);
  }

  /// Get data for a single [path]
  dynamic getOne(String path) {
    // TODO
  }

  /// Set [value] for a single [path]
  Future setOne(String path, dynamic value) {
    // TODO
  }

  dynamic exec(String path, List args) {
    // TODO
  }

  dynamic get(List<String> paths) {
    // TODO
  }

  dynamic set(List<PathValue> values) {
    // TODO
  }
}
