// Copyright (c) 2017, SERAGUD. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:jaguar_falcor/jaguar_falcor.dart';

main() {
  final m = new Model(cache: <String, dynamic>{
    'todos': [
      {
        'id': 1,
        'name': 'Do laundry',
        'done': false,
      },
      {
        'id': 2,
        'name': 'Finish Jaguar Falcor',
        'done': false,
      },
    ],
  });

  <String, dynamic>{
    'todo[0]': {
      'time': {
        'seconds': true,
        'minutes': true,
      },
      'done': true,
    },
  };

  '''todo[0].{
    time.{
      seconds,
      minutes},
    done}
  ''';

  // TODO print(Path.define('todos')..range(0, 2));

  // TODO m.getOne('todos.0');

  /* TODO
  print(PathParser.parseField('todos.time'.codeUnits.toList()));
  print(PathParser.parse('todos.time'));
  print(PathParser.parseField('todos{'.codeUnits.toList()));
  print(PathParser.parseSubscript('[5]'.codeUnits.toList()));
  print(PathParser.parseSubscript('[5:10]'.codeUnits.toList()));
  print(PathParser.parse('todos[5]'));
  print(PathParser.parseSubDocument('{name,time}'.codeUnits.toList()));
  print(PathParser.parse('todos.{name,time}'));
  print(PathParser.parseSubDocument('{name,time.{seconds,minutes}}'.codeUnits.toList()));
  print(PathParser.parse('todos.{name,time.{seconds,minutes}}'));
  */

  print(PathParser.parse('todos.{name,location.{address[0],zipcode}}'));
}
