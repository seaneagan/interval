import 'package:test/test.dart';
import 'package:xrange/integers.dart';

void main() {
  group('integers', () {
    test('should generate integer values from the given range from start to '
        'end (both inclusive)', () {
      expect(integers(-10, 10), equals([-10, -9, -8, -7, -6, -5, -4, -3, -2,
        -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]));
    });

    test('should consider step parameter while generating the values', () {
      expect(integers(-10, 10, step: 2), equals([-10, -8, -6, -4, -2, 0, 2, 4,
        6, 8, 10]));
    });

    test('should consider step, that is not multiple of two of boundaries', () {
      expect(integers(-10, 10, step: 3), equals([-10, -7, -4, -1, 2, 5, 8]));
    });
  });
}
