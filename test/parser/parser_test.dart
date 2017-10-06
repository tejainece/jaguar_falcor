// Copyright (c) 2017, SERAGUD. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:jaguar_falcor/jaguar_falcor.dart';
import 'package:test/test.dart';

void main() {
  group('PathParser', () {
    setUp(() {});

    test('ParseField', () {
      final String path = 'todos.time';
      expect(PathParser.parseField(path.codeUnits.toList()), 'todos');
      expect(PathParser.parseField('todos{'.codeUnits.toList()), 'todos');
    });

    test('ParseSubscript', () {
      expect(PathParser.parseSubscript('[5]'.codeUnits.toList()), 5);
      expect(PathParser.parseSubscript('[5:10]'.codeUnits.toList()),
          new Range(5, 10));
    });

    test('Parse', () {
      expect(compile('{todos,name}'), {'todos': true, 'name': true});
      expect(PathParser.parse('todos.time'), ['todos', 'time']);
      expect(PathParser.parse('todos[5]'), ['todos', 5]);

      // TODO
      expect(compile('todos.{name,time}'), {
        'todos': {'name': true, 'time': true}
      });
      expect(compile('todos.{name,time.{seconds,minutes}}'), {
        'todos': {
          'name': true,
          'time': {'seconds': true, 'minutes': true}
        }
      });
      expect(compile('todos.{name,location.{address[0],zipcode}}'), {
        'todos': {
          'name': true,
          'location': {'address': 0, 'zipcode': true}
        }
      });
    });

    test('ParseSubDocument', () {
      /* TODO
      expect(
          PathParser.parseSubDocument('{name,time}'.codeUnits.toList()).keys, [
        ['name'],
        ['time']
      ]);
      expect(
          PathParser.parseSubDocument('{name,time}'.codeUnits.toList()).values,
          [true, true]);
          */

      /* TODO
      expect(
          PathParser
              .parseSubDocument(
                  '{name,time.{seconds,minutes}}'.codeUnits.toList())
              .keys,
          ['name', 'time']);
          */
    });
  });
}
