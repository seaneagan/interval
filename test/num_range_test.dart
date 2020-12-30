import 'package:test/test.dart';
import 'package:xrange/src/range/num_range.dart';

void main() {
  group('NumRange.closed', () {
    testRange(
      'should generate proper values from specified interval',
      [
        <dynamic>['lower', 'upper', 'step',     'expected'    ],
        <dynamic>[   -2,      2,      1,     [-2, -1, 0, 1, 2]],
        <dynamic>[   -4,      4,      2,     [-4, -2, 0, 2, 4]],
        <dynamic>[   -4,      4,      3,        [-4, -1, 2]   ],
      ], (int lower, int upper) => NumRange.closed(lower, upper));
  });

  group('NumRange.open', () {
    testRange(
      'should generate proper values from specified interval',
      [
        <dynamic>['lower', 'upper', 'step',   'expected'    ],
        <dynamic>[   -2,      2,      1,      [-1, 0, 1]    ],
        <dynamic>[   -4,      4,      2,     [-3, -1, 1, 3] ],
        <dynamic>[   -4,      4,      3,      [-3, 0, 3]    ],
      ], (int lower, int upper) => NumRange.open(lower, upper));
  });

  group('NumRange (common)', () {
    group('values', () {
      test('should throw an argument error if passed step is equal to '
          'zero', () {
        final range = NumRange.open(-1, 10);
        expect(() => range.values(step: 0), throwsArgumentError);
      });

      test('should throw an argument error if passed step is less than '
          'zero', () {
        final range = NumRange.open(-1, 10);
        expect(() => range.values(step: -1), throwsArgumentError);
      });

      test('should throw an exception if the range lower values is '
          'unbounded', () {
        final range = NumRange.atMost(-1);
        expect(() => range.values(step: 1), throwsException);
      });

      test('should throw an exception if the range upper values is '
          'unbounded', () {
        final range = NumRange.atLeast(-1);
        expect(() => range.values(step: 1), throwsException);
      });

      test('should throw an exception if the range is unbounded', () {
        final range = NumRange.all();
        expect(() => range.values(step: 1), throwsException);
      });
    });
  });

  group('NumRange.firstValue', () {
    test('should return `null` if the range is (-∞; <finite_number>]', () {
      final range = NumRange.atMost(-1);
      expect(range.firstValue, isNull);
    });

    test('should return a finite number if the range is '
        '[<finite_number>; ∞+)', () {
      final range = NumRange.atLeast(15);
      expect(range.firstValue, 15);
    });

    test('should return `null` if the range is (-∞; +∞)', () {
      final range = NumRange.all();
      expect(range.firstValue, isNull);
    });

    test('should return a finite number if the range is open', () {
      final range = NumRange.open(-20, 30);
      expect(range.firstValue, -19);
    });

    test('should return a finite number if the range is open-closed', () {
      final range = NumRange.openClosed(-20, 30);
      expect(range.firstValue, -19);
    });

    test('should return a finite number if the range is closed', () {
      final range = NumRange.closed(-20, 30);
      expect(range.firstValue, -20);
    });

    test('should return a finite number if the range is closed-open', () {
      final range = NumRange.closedOpen(-20, 30);
      expect(range.firstValue, -20);
    });
  });

  group('NumRange.lastValue', () {
    test('should return a finite number if the range is '
        '(-∞; <finite_number>]', () {
      final range = NumRange.atMost(-1);
      expect(range.lastValue, -1);
    });

    test('should return a finite number if the range is '
        '[<finite_number>; ∞+)', () {
      final range = NumRange.atLeast(15);
      expect(range.lastValue, isNull);
    });

    test('should return `null` if the range is (-∞; +∞)', () {
      final range = NumRange.all();
      expect(range.lastValue, isNull);
    });

    test('should return a finite number if the range is open', () {
      final range = NumRange.open(-20, 30);
      expect(range.lastValue, 29);
    });

    test('should return a finite number if the range is open-closed', () {
      final range = NumRange.openClosed(-20, 30);
      expect(range.lastValue, 30);
    });

    test('should return a finite number if the range is closed', () {
      final range = NumRange.closed(-20, 30);
      expect(range.lastValue, 30);
    });

    test('should return a finite number if the range is closed-open', () {
      final range = NumRange.closedOpen(-20, 30);
      expect(range.lastValue, 29);
    });
  });
}

void testRange(String description, List<List<dynamic>> params,
    NumRange rangeFactory(int lower, int upper)) {
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
