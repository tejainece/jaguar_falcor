import 'package:jaguar_falcor/jaguar_falcor.dart';

main() {
  final data = <String, dynamic>{
    'events': {
      '0': {
        'name': "ng-conf",
        'description': "The worlds best Angular Conference",
        'location': {
          'city': "Salt Lake City",
          'state': "Utah",
        }
      },
      '1': {
        'name': "React Rally",
        'description': "Conference focusing on Facebook's React",
        'location': {'city': "Salt Lake City", 'state': "Utah"}
      },
      '2': {
        'name': "ng-Vegas",
        'description':
            "Two days jam-packed with Angular goodness with a focus on Angular 2",
        'location': {
          'city': "Las Vegas",
          'state': "Nevada",
        }
      },
      '3': {
        'name': "Midwest JS",
        'description':
            "Midwest JS is a premier technology conference focused on the JavaScript ecosystem.",
        'location': {
          'city': "Minneapolis",
          'state': "Minnesota",
        }
      },
      '4': {
        'name': "NodeConf",
        'description':
            "NodeConf is the longest running community driven conference for the Node community.",
        'location': {
          'city': "Walker Creek Ranch",
          'state': "California",
        }
      }
    },
    'data': 'hello',
  };

  print(Getter.get(compile('events.0.{*,location.state}'), data));
  print(Getter.get(<String, dynamic>{
    'data': true,
    'events': {
      '0': {
        '*': true,
        'location': {
          'state': true,
        },
      }
    },
  }, data));
}
