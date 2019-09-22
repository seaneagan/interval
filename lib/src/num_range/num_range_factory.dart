import 'package:xrange/src/num_range/num_range.dart';

abstract class NumRangeFactory {
  NumRange create({int lower, int upper, bool lowerClosed, bool upperClosed});
}
