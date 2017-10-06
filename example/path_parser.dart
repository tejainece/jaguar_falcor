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

  // TODO print(PathParser.parse('todos.{name,location.{address[0],zipcode}}'));

  // TODO print(compile('todos.name'));
  // TODO print(compile('todos.name[0]'));
  // TODO print(compile('todos[0].name'));
  // TODO print(compile('todos.{name,description}'));
  // TODO print(compile('todos.{name,location.{address[0],zipcode}}'));

  // TODO print(compile('{todos,name}'));

  print(compile('''todo[0].{
    time.{
      seconds,
      minutes,
    },
    done}
  '''));

  print(PathParser.parse('''{  todos,  name,}'''));
}
