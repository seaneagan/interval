import 'package:xrange/src/injector.dart';
import 'package:xrange/src/num_range/num_range_factory.dart';

Iterable<int> integers(int lower, int upper, {
  int step = 1,
  bool lowerClosed = true,
  bool upperClosed = true,
}) {
  final rangeFactory = getDependencies()
      .get<NumRangeFactory>();
  final range = rangeFactory.create(
    lower: lower,
    upper: upper,
    lowerClosed: lowerClosed,
    upperClosed: upperClosed,
  );
  return range
      .values(step: step)
      .map((el) => el.toInt());
}
