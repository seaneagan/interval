import 'package:test/test.dart';
import 'package:xrange/integers.dart';

void main() {
  group('integers', () {
    testRange(
      'should generate proper values for closed range from specified interval',
      [
        <dynamic>['lower', 'upper', 'step',     'expected'    ],
        <dynamic>[   -2,      2,      1,     [-2, -1, 0, 1, 2]],
        <dynamic>[   -4,      4,      2,     [-4, -2, 0, 2, 4]],
        <dynamic>[   -4,      4,      3,        [-4, -1, 2]   ],
      ],
          (int lower, int upper, int step) => integers(
            lower,
            upper,
            step: step,
            lowerClosed: true,
            upperClosed: true,
          ),
    );

    testRange(
      'should generate proper values for open range from specified interval',
      [
        <dynamic>['lower', 'upper', 'step',   'expected'    ],
        <dynamic>[   -2,      2,      1,      [-1, 0, 1]    ],
        <dynamic>[   -4,      4,      2,     [-3, -1, 1, 3] ],
        <dynamic>[   -4,      4,      3,      [-3, 0, 3]    ],
      ],
          (int lower, int upper, int step) => integers(
            lower,
            upper,
            step: step,
            lowerClosed: false,
            upperClosed: false,
          ),
    );

    test('should throw an argument error if passed step is equal to '
        'zero', () {
      expect(() => integers(-1, 10, step: 0), throwsArgumentError);
    });

    test('should throw an argument error if passed step is less than '
        'zero', () {
      expect(() => integers(-1, 10, step: -1), throwsArgumentError);
    });
  });
}

void testRange(String description, List<List<dynamic>> params,
    Iterable<int> rangeFactory(int lower, int upper, int step)) {
  test(description, () {
    final iterator = params.iterator;

    iterator.moveNext();

    while (iterator.moveNext()) {
      final args = iterator.current;
      final range = rangeFactory(args[0] as int, args[1] as int, args[2] as int);

      expect(range, equals(args[3]));
    }
  });
}
