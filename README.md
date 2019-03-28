interval [![pub package](http://img.shields.io/pub/v/interval.svg)](https://pub.dartlang.org/packages/interval) [![Build Status](https://drone.io/github.com/seaneagan/interval/status.png)](https://drone.io/github.com/seaneagan/interval/latest)
========

Provides the `Interval` class, a contiguous set of values.

If an Interval contains two values, it also contains all values between
them.  It may have an upper and lower bound, and those bounds may be
open or closed.

##Install

```shell
pub global activate den # If you haven't already
den install interval
```

##Usage

```dart
import 'package:interval/interval.dart';

// Date intervals
var activeDates = new Interval<DateTime>.closed(date1, date2);
if (activeDates.contains(new DateTime.now()) {
  print('Item is active!');
}

// View selection model
var slider = new Slider(interval: new Interval.closed(0, 100));

// Validation
class Rating {
  final int value;

  Rating(this.value) {
    if(!new Interval.closed(1, 5).contains(value)) {
      throw new ArgumentError('ratings must be between 1 and 5');
    }
  }
}
```
