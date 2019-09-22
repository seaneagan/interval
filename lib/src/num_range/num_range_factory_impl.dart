import 'package:xrange/src/num_range/num_range.dart';
import 'package:xrange/src/num_range/num_range_factory.dart';

class NumRangeFactoryImpl implements NumRangeFactory {
  const NumRangeFactoryImpl();

  @override
  NumRange create({int lower, int upper, bool lowerClosed, bool upperClosed}) =>
    NumRange(
        lower: lower,
        upper: upper,
        lowerClosed: lowerClosed,
        upperClosed: upperClosed
    );
}
