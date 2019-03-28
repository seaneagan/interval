import 'package:xrange/range.dart';

void main() {
  final date1 = DateTime(2015);
  final date2 = DateTime(2021);
  final activeDates = Range<DateTime>.closed(date1, date2);

  if (activeDates.contains(DateTime.now())) {
    print('Hi, contemporary!');
  } else {
    print('Apparently, you are from the future!');
  }
}
