import 'package:jaguar_falcor/jaguar_falcor.dart';

main() {
  final data = <String, dynamic>{
    'todos': [
      {
        'id': 0,
        'name': 'Implement parser',
        'done': false,
      },
      {
        'id': 1,
        'name': 'Implement composer',
        'done': false,
      },
      {
        'id': 2,
        'name': 'Implement setter',
        'done': false,
      },
      {
        'id': 3,
        'name': 'Implement data source',
        'done': false,
      },
      {
        'id': 4,
        'name': 'Release!',
        'done': false,
      },
    ],
    'data': 'hello',
  };
  print(Getter.get(compile('todos[0]'), data));
  print(Getter.get(<String, dynamic>{
    'data': true,
    'todos': 0,
  }, data));

  print(Getter.get(compile('todos[1:4]'), data));
  print(Getter.get(<String, dynamic>{
    'data': true,
    'todos': new Range(1, 4),
  }, data));

  print(Getter.get(compile('todos[2:5].{name,done}'), data));
  print(Getter.get(<String, dynamic>{
    'data': true,
    'todos': array(new Range(2, 5), {
      'name': true,
      'done': true,
    }),
  }, data));
}
