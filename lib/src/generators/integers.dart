import 'package:xrange/src/range/num_range.dart';

Iterable<int> integers(int lower, int upper, {
  int step = 1,
  bool lowerClosed = true,
  bool upperClosed = false,
}) => NumRange(
    lower: lower,
    upper: upper,
    lowerClosed: lowerClosed,
    upperClosed: upperClosed,
  )
      .values(step: step)
      .map((el) => el.toInt());
