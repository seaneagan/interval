import 'package:xrange/range.dart';

class NumRange extends Range<num> {
  NumRange({num lower, num upper, bool lowerClosed, bool upperClosed}) :
        super(lower: lower, upper: upper, lowerClosed: lowerClosed,
          upperClosed: upperClosed);

  NumRange.open(num lower, num upper) : super.open(lower, upper);

  NumRange.closed(num lower, num upper) : super.closed(lower, upper);

  NumRange.openClosed(num lower, num upper) : super.openClosed(lower, upper);

  NumRange.closedOpen(num lower, num upper) : super.closedOpen(lower, upper);

  NumRange.atLeast(num lower) : super.atLeast(lower);

  NumRange.atMost(num upper) : super.atMost(upper);

  NumRange.greaterThan(num lower) : super.greaterThan(lower);

  NumRange.lessThan(num upper) : super.lessThan(upper);

  NumRange.all() : super.all();

  NumRange.singleton(num value) : super.singleton(value);

  int get length => !bounded ? null : lastValue - firstValue + 1;

  int get firstValue {
    if (lower == null) {
      return null;
    }
    return (lowerClosed ? lower : lower + 1).toInt();
  }

  int get lastValue {
    if (upper == null) {
      return null;
    }
    return (upperClosed ? upper : upper - 1).toInt();
  }

  Iterable<num> values({int step = 1}) sync* {
    if (step <= 0) {
      throw ArgumentError.value(step, 'A step should be greater than 0');
    }
    if (!bounded) {
      throw Exception('There is no bound, '
          '${lower == null ? '`lower`' : '`upper`'} is not defined');
    }
    for (int val = firstValue; val <= lastValue; val += step) {
      yield val;
    }
  }
}