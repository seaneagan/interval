This is a fork of [Interval library](https://github.com/seaneagan/interval)

## XRange lib

Provides the `Range` class, a contiguous set of values, and the `ZRange` class, that along with functionality of 
`Range` class can also generate values of arithmetic progression in a specific diapason. This range can contain just 
integer numbers, that's why `Z` is used as a prefix for the class name (the letter `Z` denotes the set
of all integers in mathematics).

If a range contains two values, it also contains all values between them.  It may have an upper and lower bound, 
and those bounds may be open or closed.

## Usage

### Range

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

### XRange

```dart
import 'package:xrange/zrange.dart';

void main() {
  final range = ZRange.closed(-10, 10);
  
  for (final value in range.values(step: 2)) {
    print(value); // it yields numbers from -10 to 10 with step equals 2
  }
}
```

Please, pay attention to `values` method - it is a generator function, so there is no need to save the range values in 
a variable before iterating.
