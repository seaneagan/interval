import 'package:xrange/num_range.dart';

Iterable<int> integers(int start, int end, {int step = 1}) =>
    NumRange.closed(start, end)
        .values(step: step)
        .map((el) => el.toInt());
