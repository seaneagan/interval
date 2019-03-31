import 'package:xrange/range.dart';

class ZRange extends Range<num> {
  ZRange({int lower, int upper, bool lowerClosed, bool upperClosed}) :
        super(lower: lower, upper: upper, lowerClosed: lowerClosed,
          upperClosed: upperClosed);

  ZRange.open(int lower, int upper) : super.open(lower, upper);

  ZRange.closed(int lower, int upper) : super.closed(lower, upper);

  ZRange.openClosed(int lower, int upper) : super.openClosed(lower, upper);

  ZRange.closedOpen(int lower, int upper) : super.closedOpen(lower, upper);

  ZRange.atLeast(int lower) : super.atLeast(lower);

  ZRange.atMost(int upper) : super.atMost(upper);

  ZRange.greaterThan(int lower) : super.greaterThan(lower);

  ZRange.lessThan(int upper) : super.lessThan(upper);

  ZRange.all() : super.all();

  ZRange.singleton(int value) : super.singleton(value);

  int get length => lastValue.abs() - firstValue.abs() + 1;

  int get firstValue => (lowerClosed ? lower : lower + 1) as int;

  int get lastValue => (upperClosed ? upper : upper - 1) as int;

  Iterable<int> values({int step = 1}) sync* {
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