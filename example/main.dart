import 'package:xrange/range.dart';
import 'package:xrange/zrange.dart';

void range() {
  final date1 = DateTime(2015);
  final date2 = DateTime(2021);
  final dates = Range<DateTime>.closed(date1, date2);

  if (dates.contains(DateTime.now())) {
    print('Hi, contemporary!');
  } else {
    print('Apparently, you are from the future!');
  }
}

void zrange() {
  final range = ZRange.closed(-10, 10);
  for (final value in range.values(step: 2)) {
    print(value); // it yields numbers from -10 to 10 with step equals 2
  }
}

void main() {
  range();
  zrange();
}
