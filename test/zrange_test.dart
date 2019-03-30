import 'package:test/test.dart';
import 'package:xrange/zrange.dart';

void main() {
  group('XRange.closed', () {
    testRange(
      'should generate proper values from specified interval',
      [
        <dynamic>['lower', 'upper', 'step',     'expected'    ],
        <dynamic>[   -2,      2,      1,     [-2, -1, 0, 1, 2]],
        <dynamic>[   -4,      4,      2,     [-4, -2, 0, 2, 4]],
        <dynamic>[   -4,      4,      3,        [-4, -1, 2]   ],
      ], (int lower, int upper) => ZRange.closed(lower, upper));
  });

  group('XRange.open', () {
    testRange(
      'should generate proper values from specified interval',
      [
        <dynamic>['lower', 'upper', 'step',   'expected'    ],
        <dynamic>[   -2,      2,      1,      [-1, 0, 1]    ],
        <dynamic>[   -4,      4,      2,     [-3, -1, 1, 3] ],
        <dynamic>[   -4,      4,      3,      [-3, 0, 3]    ],
      ], (int lower, int upper) => ZRange.open(lower, upper));
  });
}

void testRange(String description, List<List<dynamic>> params,
    ZRange rangeFactory(int lower, int upper)) {
  test(description, () {
    final iterator = params.iterator;
    iterator.moveNext();
    while (iterator.moveNext()) {
      final args = iterator.current;
      final range = rangeFactory(args[0] as int, args[1] as int);
      final values = range.values(step: args[2] as int);
      expect(values, equals(args[3]));
    }
  });
}
