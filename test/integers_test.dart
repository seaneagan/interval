import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:xrange/src/generators/integers.dart';
import 'package:xrange/src/injector.dart';
import 'package:xrange/src/num_range/num_range_factory.dart';
import 'package:xrange/xrange.dart';

class NumRangeFactoryMock extends Mock implements NumRangeFactory {}

class NumRangeMock extends Mock implements NumRange {}

void main() {
  group('integers', () {
    tearDown(() {
      injector.clearAll();
    });

    test('should generate integer values from the given range with step '
        'equals 1 from start to end (both inclusive) if step and boundary '
        'parameters are not provided', () {
      expect(integers(-10, 10), equals([-10, -9, -8, -7, -6, -5, -4, -3, -2,
        -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]));
    });

    test('should proxy calls to implementations of NumRangeFactory and '
        'NumRange', () {
      final numRangeFactoryMock = NumRangeFactoryMock();
      final numRange = NumRangeMock();

      final lower = -5;
      final upper = 5;
      final lowerClosed = false;
      final upperClosed = false;
      final step = 3;

      final returnedIndices = [1, 2, 3, 4, 5];

      when(numRangeFactoryMock.create(
          lower: lower,
          upper: upper,
          lowerClosed: lowerClosed,
          upperClosed: upperClosed)
      ).thenReturn(numRange);

      when(numRange.values(step: step))
          .thenReturn(returnedIndices);

      injector
          .registerSingleton<NumRangeFactory>(() => numRangeFactoryMock);

      final actualIndices = integers(-5, 5,
          lowerClosed: lowerClosed,
          upperClosed: upperClosed,
          step: step,
      );

      verify(numRangeFactoryMock.create(
          lower: lower,
          upper: upper,
          lowerClosed: lowerClosed,
          upperClosed: upperClosed,
      )).called(1);

      verify(numRange.values(step: step)).called(1);

      expect(actualIndices, equals(returnedIndices));
    });
  });
}
