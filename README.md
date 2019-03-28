This is a fork of [Interval](https://github.com/seaneagan/interval)

## XRange

Provides the `Range` class, a contiguous set of values.

If an Interval contains two values, it also contains all values between
them.  It may have an upper and lower bound, and those bounds may be
open or closed.

## Usage

```dart
import 'package:xrange/range.dart';

void main() {
  final date1 = DateTime(2015);
  final date2 = DateTime(2021);
  final dates = Range<DateTime>.closed(date1, date2);

  if (dates.contains(DateTime.now())) {
    print('Hi, contemporary!');
  } else {
    print('Apparently, you are from the future!');
  }
}
```
