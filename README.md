[![Build Status](https://github.com/gyrdym/xrange/workflows/CI%20pipeline/badge.svg)](https://github.com/gyrdym/xrange/actions?query=branch%3Amaster+)
[![Coverage Status](https://coveralls.io/repos/github/gyrdym/xrange/badge.svg?branch=master)](https://coveralls.io/github/gyrdym/xrange?branch=master)
[![pub package](https://img.shields.io/pub/v/xrange.svg)](https://pub.dartlang.org/packages/xrange)
[![Gitter Chat](https://badges.gitter.im/gyrdym/gyrdym.svg)](https://gitter.im/gyrdym/)

This is a fork of [Interval library](https://github.com/seaneagan/interval)

## XRange lib

Provides the `Range` class, a contiguous set of values, and the `NumRange` class, that along with functionality of 
`Range` class can also generate values of arithmetic progression in a specific diapason.

If a range contains two values, it also contains all values between them.  It may have an upper and lower bound, 
and those bounds may be open or closed.

Also the library contains `integers` generator function, that is based on `NumRange` class. It produces integer values 
from a specific closed diapason.

## Usage

### Range

```dart
import 'package:xrange/xrange.dart';

void main() {
  final date1 = DateTime(2015);
  final date2 = DateTime(2221);
  final dates = Range<DateTime>.closed(date1, date2);

  if (dates.contains(DateTime.now())) {
    print('Hi, contemporary!');
  } else {
    print('Apparently, you are from the future!');
  }
}
```

### NumRange

```dart
import 'package:xrange/xrange.dart';

void main() {
  final range = NumRange.closed(-10, 10);
  
  for (final value in range.values(step: 2)) {
    print(value); // it yields numbers from -10 to 10 with step equals 2
  }
}
```

Pay attention to `values` method - it is a generator function, so use all the benefits of this.

### integers

````dart
import 'package:xrange/xrange.dart';

void main() {
  for (final value in integers(-10, 10)) {
    print(value); // it yields numbers from -10 to 10 with step equals 2
  }
}
````

The `integers` function returns a lazy iterable, thus it consumes little memory, since the whole collection is not 
being generated when `integers` is called.
