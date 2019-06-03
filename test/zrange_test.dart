import 'package:test/test.dart';
import 'package:xrange/zrange.dart';

void main() {
  group('ZRange.closed', () {
    testRange(
      'should generate proper values from specified interval',
      [
        <dynamic>['lower', 'upper', 'step',     'expected'    ],
        <dynamic>[   -2,      2,      1,     [-2, -1, 0, 1, 2]],
        <dynamic>[   -4,      4,      2,     [-4, -2, 0, 2, 4]],
        <dynamic>[   -4,      4,      3,        [-4, -1, 2]   ],
      ], (int lower, int upper) => ZRange.closed(lower, upper));

    test('should return proper range length', () {
      final range = ZRange.closed(1, 4);
      expect(range.length, 4);
    });
  });

  group('ZRange.open', () {
    testRange(
      'should generate proper values from specified interval',
      [
        <dynamic>['lower', 'upper', 'step',   'expected'    ],
        <dynamic>[   -2,      2,      1,      [-1, 0, 1]    ],
        <dynamic>[   -4,      4,      2,     [-3, -1, 1, 3] ],
        <dynamic>[   -4,      4,      3,      [-3, 0, 3]    ],
      ], (int lower, int upper) => ZRange.open(lower, upper));

    test('should return proper range length', () {
      final range = ZRange.open(1, 4);
      expect(range.length, 2);
    });
  });

  group('ZRange (common)', () {
    group('values', () {
      test('should throw an argument value if passed step is equal to '
          'zero', () {
        final range = ZRange.open(-1, 10);
        expect(() => range.values(step: 0), throwsArgumentError);
      });

      test('should throw an argument value if passed step is less than '
          'zero', () {
        final range = ZRange.open(-1, 10);
        expect(() => range.values(step: -1), throwsArgumentError);
      });

      test('should throw an exception if the range lower values is '
          'unbounded', () {
        final range = ZRange.atMost(-1);
        expect(() => range.values(step: 1), throwsException);
      });

      test('should throw an exception if the range upper values is '
          'unbounded', () {
        final range = ZRange.atLeast(-1);
        expect(() => range.values(step: 1), throwsException);
      });

      test('should throw an exception if the range is unbounded', () {
        final range = ZRange.all();
        expect(() => range.values(step: 1), throwsException);
      });
    });
  });

  group('ZRange.firstValue', () {
    test('should return `null` if the range is (-∞; <finite_number>]', () {
      final range = ZRange.atMost(-1);
      expect(range.firstValue, isNull);
    });

    test('should return a finite number if the range is '
        '[<finite_number>; ∞+)', () {
      final range = ZRange.atLeast(15);
      expect(range.firstValue, 15);
    });

    test('should return `null` if the range is (-∞; +∞)', () {
      final range = ZRange.all();
      expect(range.firstValue, isNull);
    });

    test('should return a finite number if the range is open', () {
      final range = ZRange.open(-20, 30);
      expect(range.firstValue, -19);
    });

    test('should return a finite number if the range is open-closed', () {
      final range = ZRange.openClosed(-20, 30);
      expect(range.firstValue, -19);
    });

    test('should return a finite number if the range is closed', () {
      final range = ZRange.closed(-20, 30);
      expect(range.firstValue, -20);
    });

    test('should return a finite number if the range is closed-open', () {
      final range = ZRange.closedOpen(-20, 30);
      expect(range.firstValue, -20);
    });
  });

  group('ZRange.lastValue', () {
    test('should return a finite number if the range is '
        '(-∞; <finite_number>]', () {
      final range = ZRange.atMost(-1);
      expect(range.lastValue, -1);
    });

    test('should return a finite number if the range is '
        '[<finite_number>; ∞+)', () {
      final range = ZRange.atLeast(15);
      expect(range.lastValue, isNull);
    });

    test('should return `null` if the range is (-∞; +∞)', () {
      final range = ZRange.all();
      expect(range.lastValue, isNull);
    });

    test('should return a finite number if the range is open', () {
      final range = ZRange.open(-20, 30);
      expect(range.lastValue, 29);
    });

    test('should return a finite number if the range is open-closed', () {
      final range = ZRange.openClosed(-20, 30);
      expect(range.lastValue, 30);
    });

    test('should return a finite number if the range is closed', () {
      final range = ZRange.closed(-20, 30);
      expect(range.lastValue, 30);
    });

    test('should return a finite number if the range is closed-open', () {
      final range = ZRange.closedOpen(-20, 30);
      expect(range.lastValue, 29);
    });
  });

  group('ZRange.length', () {
    test('should return `null` if the range is (-∞; <finite_number>]', () {
      final range = ZRange.atMost(-1);
      expect(range.length, isNull);
    });

    test('should return `null` if the range is [<finite_number>; ∞+)', () {
      final range = ZRange.atLeast(15);
      expect(range.length, isNull);
    });

    test('should return `null` if the range is (-∞; +∞)', () {
      final range = ZRange.all();
      expect(range.length, isNull);
    });

    test('should return a finite number if the range is (-5; +5)', () {
      final range = ZRange.open(-5, 5);
      expect(range.length, 9);
    });

    test('should return a finite number if the range is (0; +5)', () {
      final range = ZRange.open(0, 5);
      expect(range.length, 4);
    });

    test('should return a finite number if the range is (-10; -5)', () {
      final range = ZRange.open(-10, -5);
      expect(range.length, 4);
    });

    test('should return a finite number if the range is [-10; -5]', () {
      final range = ZRange.closed(-10, -5);
      expect(range.length, 6);
    });
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
