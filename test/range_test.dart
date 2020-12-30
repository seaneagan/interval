import 'package:test/test.dart';
import 'package:xrange/src/range/range.dart';

void main() {
  group('Range', () {
    group('constructors', () {

      test('should throw when upper less than lower', () {
        expect(() => Range<num>(lower: 1, lowerClosed: true, upper: 0,
            upperClosed: true), throwsArgumentError);
        expect(() => Range<num>.open(1, 0), throwsArgumentError);
        expect(() => Range<num>.closed(1, 0), throwsArgumentError);
        expect(() => Range<num>.openClosed(1, 0), throwsArgumentError);
        expect(() => Range<num>.closedOpen(1, 0), throwsArgumentError);
      });

      test('should throw when open and lower equals upper', () {
        expect(() => Range<num>(upper: 0, upperClosed: false, lower: 0,
            lowerClosed: false), throwsArgumentError);
        expect(() => Range<num>.open(0, 0), throwsArgumentError);
      });

      test('should throw on null when corresponding bound is closed', () {
        expect(() => Range<num>.closed(null, 0), throwsArgumentError);
        expect(() => Range<num>.closed(0, null), throwsArgumentError);
        expect(() => Range<num>.openClosed(0, null), throwsArgumentError);
        expect(() => Range<num>.closedOpen(null, 0), throwsArgumentError);
        expect(() => Range.atMost(null), throwsArgumentError);
        expect(() => Range.atLeast(null), throwsArgumentError);
        expect(() => Range.singleton(null), throwsArgumentError);
      });

      group('span', () {

        test('should contain all values if iterable is empty', () {
          final interval = Range<num>.span([]);
          expect(interval.lower, null);
          expect(interval.upper, null);
          expect(interval.lowerClosed, isFalse);
          expect(interval.upperClosed, isFalse);
        });

        test('should find lower and upper', () {
          final interval = Range<num>.span([2,5,1,4]);
          expect(interval.lower, 1);
          expect(interval.upper, 5);
          expect(interval.lowerClosed, isTrue);
          expect(interval.upperClosed, isTrue);
        });

        test('should be singleton if single element', () {
          final interval = Range<num>.span([2]);
          expect(interval.lower, 2);
          expect(interval.upper, 2);
          expect(interval.lowerClosed, isTrue);
          expect(interval.upperClosed, isTrue);
        });

      });

      group('encloseAll', () {

        test('should contain all values if iterable is empty', () {
          final interval = Range<num>.encloseAll([]);
          expect(interval.lower, null);
          expect(interval.upper, null);
        });

        test('should have null bounds when any input interval does', () {
          final interval = Range<num>.encloseAll([
              Range.atMost(0),
              Range.atLeast(1)]);
          expect(interval.lower, null);
          expect(interval.upper, null);
        });

        test('should have bounds matching extreme input interval bounds', () {
          final interval = Range<num>.encloseAll([
              Range.closed(0, 3),
              Range.closed(-1, 0),
              Range.closed(8, 10),
              Range.closed(5, 7)]);
          expect(interval.lower, -1);
          expect(interval.upper, 10);
        });

        test('should have closed bound when any corresponding extreme input '
            'interval bound does', () {
          final interval = Range<num>.encloseAll([
              Range.closedOpen(0, 1),
              Range.openClosed(0, 1)]);
          expect(interval.lowerClosed, isTrue);
          expect(interval.upperClosed, isTrue);
        });

        test('should have open bound when all extreme input interval bounds '
            'do', () {
          final interval = Range<num>.encloseAll([
              Range.open(0, 1),
              Range.open(0, 1)]);
          expect(interval.lowerClosed, isFalse);
          expect(interval.upperClosed, isFalse);
        });

      });

    });

    group('contains', () {

      test('should be true for values between lower and upper', () {
        expect(Range<num>.closed(0, 2).contains(1), isTrue);
      });

      test('should be false for values below lower', () {
        expect(Range<num>.closed(0, 2).contains(-1), isFalse);
      });

      test('should be false for values above upper', () {
        expect(Range<num>.closed(0, 2).contains(3), isFalse);
      });

      test('should be false for lower when lowerClosed is false', () {
        expect(Range<num>.open(0, 2).contains(0), isFalse);
      });

      test('should be true for lower when lowerClosed is true', () {
        expect(Range<num>.closed(0, 2).contains(0), isTrue);
      });

      test('should be false for upper when upperClosed is false', () {
        expect(Range<num>.open(0, 2).contains(2), isFalse);
      });

      test('should be true for upper when upperClosed is true', () {
        expect(Range<num>.closed(0, 2).contains(2), isTrue);
      });

      test('should be true for greater than lower when upper is null', () {
        expect(Range<num>.atLeast(0).contains(100), isTrue);
      });

      test('should be true for less than upper when lower is null', () {
        expect(Range<num>.atMost(0).contains(-100), isTrue);
      });

      test('should be false for bounds when equal and not both closed', () {
        expect(Range<num>.openClosed(0, 0).contains(0), isFalse);
        expect(Range<num>.closedOpen(0, 0).contains(0), isFalse);
      });

    });

    group('isEmpty', () {

      test('should be true when bounds equal and not both closed', () {
        expect(Range<num>.openClosed(0, 0).isEmpty, isTrue);
        expect(Range<num>.closedOpen(0, 0).isEmpty, isTrue);
      });

      test('should be false when bounds equal and closed', () {
        expect(Range<num>.closed(0, 0).isEmpty, isFalse);
      });

      test('should be false when lower less than upper', () {
        expect(Range<num>.closed(0, 1).isEmpty, isFalse);
      });

    });

    group('isSingleton', () {

      test('should be true when bounds equal and both closed', () {
        expect(Range<num>.closed(0, 0).isSingleton, isTrue);
      });

      test('should be false when empty', () {
        expect(Range<num>.openClosed(0, 0).isSingleton, isFalse);
        expect(Range<num>.closedOpen(0, 0).isSingleton, isFalse);
      });

      test('should be false when lower less than upper', () {
        expect(Range<num>.closed(0, 1).isSingleton, isFalse);
      });

    });

    group('bounded', () {

      test('should be true only when lower bounded and upper bounded', () {
        expect(Range<num>.closedOpen(0, 1).bounded, isTrue);
        expect(Range<num>.atLeast(0).bounded, isFalse);
        expect(Range<num>.atMost(0).bounded, isFalse);
      });

    });

    group('lowerBounded', () {

      test('should be true only when lower bounded', () {
        expect(Range<num>.atLeast(0).lowerBounded, isTrue);
        expect(Range<num>.atMost(0).lowerBounded, isFalse);
      });

    });

    group('upperBounded', () {

      test('should be true only when upper bounded', () {
        expect(Range<num>.atMost(0).upperBounded, isTrue);
        expect(Range<num>.atLeast(0).upperBounded, isFalse);
      });

    });

    group('isOpen', () {

      test('should be true only when both bounds open', () {
        expect(Range<num>.open(0, 1).isOpen, isTrue);
        expect(Range<num>.closedOpen(0, 1).isOpen, isFalse);
        expect(Range<num>.openClosed(0, 1).isOpen, isFalse);
        expect(Range<num>.closed(0, 1).isOpen, isFalse);
      });

    });

    group('isClosed', () {

      test('should be true only when both bounds closed', () {
        expect(Range<num>.closed(0, 1).isClosed, isTrue);
        expect(Range<num>.closedOpen(0, 1).isClosed, isFalse);
        expect(Range<num>.openClosed(0, 1).isClosed, isFalse);
        expect(Range<num>.open(0, 1).isClosed, isFalse);
      });

    });

    group('isClosedOpen', () {

      test('should be true only when lower closed and upper open', () {
        expect(Range<num>.closedOpen(0, 1).isClosedOpen, isTrue);
        expect(Range<num>.open(0, 1).isClosedOpen, isFalse);
        expect(Range<num>.closed(0, 1).isClosedOpen, isFalse);
        expect(Range<num>.openClosed(0, 1).isClosedOpen, isFalse);
      });

    });

    group('isOpenClosed', () {

      test('should be true only when lower open and upper closed', () {
        expect(Range<num>.openClosed(0, 1).isOpenClosed, isTrue);
        expect(Range<num>.open(0, 1).isOpenClosed, isFalse);
        expect(Range<num>.closed(0, 1).isOpenClosed, isFalse);
        expect(Range<num>.closedOpen(0, 1).isOpenClosed, isFalse);
      });

    });

    group('interior', () {

      test('should return input when input already open', () {
        final open = Range<num>.open(0, 1);
        expect(open.interior, same(open));
      });

      test('should return open version of non-open input', () {
        final interior = Range<num>.closed(0, 1).interior;
        expect(interior.lower, 0);
        expect(interior.upper, 1);
        expect(interior.lowerClosed, isFalse);
        expect(interior.upperClosed, isFalse);
      });

    });

    group('closure', () {

      test('should return input when input already open', () {
        final closed = Range<num>.closed(0, 1);
        expect(closed.closure, same(closed));
      });

      test('should return closed version of non-closed input', () {
        final closure = Range<num>.closed(0, 1).closure;
        expect(closure.lower, 0);
        expect(closure.upper, 1);
        expect(closure.lowerClosed, isTrue);
        expect(closure.upperClosed, isTrue);
      });

    });

    group('encloses', () {

      test('should be true when both bounds outside input bounds', () {
        expect(Range<num>.closed(0, 3)
            .encloses(Range<num>.closed(1, 2)), isTrue);
        expect(Range<num>.atLeast(0)
            .encloses(Range<num>.closed(1, 2)), isTrue);
        expect(Range<num>.atMost(3)
            .encloses(Range<num>.closed(1, 2)), isTrue);
      });

      test('should be false when either bound not outside input bound', () {
        expect(Range<num>.closed(0, 2)
            .encloses(Range<num>.closed(1, 3)), isFalse);
        expect(Range<num>.closed(1, 3)
            .encloses(Range<num>.closed(0, 2)), isFalse);
        expect(Range<num>.closed(0, 2)
            .encloses(Range<num>.atLeast(1)), isFalse);
        expect(Range<num>.closed(0, 2)
            .encloses(Range<num>.atMost(1)), isFalse);
      });

      test('should be true when bound closed and input has same bound', () {
        expect(Range<num>.closedOpen(0, 2)
            .encloses(Range<num>.closed(0, 1)), isTrue);
        expect(Range<num>.openClosed(0, 2)
            .encloses(Range<num>.closed(1, 2)), isTrue);
      });

      test('should be false when bound open and input has same bound but '
           'closed', () {
        expect(Range<num>.openClosed(0, 2)
            .encloses(Range<num>.closed(0, 1)), isFalse);
        expect(Range<num>.closedOpen(0, 2)
            .encloses(Range<num>.closed(1, 2)), isFalse);
      });

    });

    group('connectedTo', () {
      void expectConnected(Range interval1, Range interval2, Matcher matcher) {
        expect(interval1.connectedTo(interval2), matcher);
        expect(interval2.connectedTo(interval1), matcher);
      }

      test('should be true when intervals properly intersect', () {
        expectConnected(Range<num>.open(0, 1),
            Range<num>.open(0, 1), isTrue);
        expectConnected(Range<num>.closed(1, 3),
            Range<num>.closed(0, 2),
            isTrue);
        expectConnected(Range<num>.atLeast(1),
            Range<num>.atLeast(2),
            isTrue);
        expectConnected(Range<num>.atLeast(1),
            Range<num>.atLeast(2),
            isTrue);
        expectConnected(Range<num>.atMost(2),
            Range<num>.atMost(1),
            isTrue);
      });

      test('should be true when intervals adjacent and at least one bound '
           'closed', () {
        expectConnected(Range<num>.closed(0, 1),
            Range<num>.closed(1, 2),
            isTrue);
        expectConnected(Range<num>.open(0, 1),
            Range<num>.closed(1, 2),
            isTrue);
        expectConnected(Range<num>.closed(0, 1),
            Range<num>.open(1, 2),
            isTrue);
        expectConnected(Range<num>.atMost(1),
            Range<num>.greaterThan(1),
            isTrue);
      });

      test('should be false when interval closures do not intersect', () {
        expectConnected(Range<num>.closed(0, 1),
            Range<num>.closed(2, 3),
            isFalse);
        expectConnected(Range<num>.closed(2, 3),
            Range<num>.closed(0, 1),
            isFalse);
        expectConnected(Range<num>.atMost(0),
            Range<num>.atLeast(1),
            isFalse);
      });

      test('should be false when intervals adjacent and both bounds open', () {
        expectConnected(Range<num>.open(0, 1),
            Range<num>.greaterThan(1),
            isFalse);
        expectConnected(Range<num>.greaterThan(1),
            Range<num>.lessThan(1),
            isFalse);
      });

    });

    test('should be equal iff lower, upper, lowerClosed, and upperClosed are '
         'all equal', () {
      final it = Range<num>.closed(0, 1);
      expect(it, Range<num>.closed(0, 1));
      expect(it, isNot(equals(Range<num>.closed(0, 2))));
      expect(it, isNot(equals(Range<num>.closed(1, 1))));
      expect(it, isNot(equals(Range<num>.openClosed(0, 1))));
      expect(it, isNot(equals(Range<num>.closedOpen(0, 1))));
    });

    test('hashCode should be equal if lower, upper, lowerClosed, and '
         'upperClosed are all equal', () {
      final it = Range<num>.closed(0, 1);
      expect(it.hashCode, Range<num>.closed(0, 1).hashCode);
    });

    test('toString should depict the interval', () {
      expect(Range<num>.closedOpen(0, 1).toString(), '[0..1)');
      expect(Range<num>.openClosed(0, 1).toString(), '(0..1]');
      expect(Range<num>.atLeast(0).toString(), '[0..+∞)');
      expect(Range<num>.atMost(0).toString(), '(-∞..0]');
    });

  });
}
