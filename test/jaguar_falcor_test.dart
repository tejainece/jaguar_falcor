// Copyright (c) 2017, SERAGUD. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:jaguar_falcor/jaguar_falcor.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    setUp(() {
    });

    test('First Test', () {
      final String path = 'todos.time';
      expect(PathParser.parseField(path.codeUnits.toList()), ['todos']);
      expect(PathParser.parse('todos.time'), ['todos', 'time']);
    });
  });
}
