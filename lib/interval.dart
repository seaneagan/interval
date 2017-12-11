
library interval;

/// A contiguous set of values.
///
/// If an interval [contains] two values, it also contains all values between
/// them.  It may have an [upper] and [lower] bound, and those bounds may be
/// open or closed.
class Interval<T extends Comparable<T>> {

  /// The lower bound value if it exists, or null.
  final T lower;

  /// The upper bound value if it exists, or null.
  final T upper;

  /// Whether `this` contains [lower].  [lower] may also be contained
  /// if [upperClosed] and [lower] equals [upper].
  final bool lowerClosed;

  /// Whether `this` contains [upper].  [upper] may also be contained
  /// if [lowerClosed] is true and [lower] equals [upper].
  final bool upperClosed;

  /// Whether `this` excludes both of its bounds.
  bool get isOpen => !lowerClosed && !upperClosed;

  /// Whether `this` [contains] both of its bounds.
  bool get isClosed => lowerClosed && upperClosed;

  /// Whether `this` excludes its bounds.
  bool get isClosedOpen => lowerClosed && !upperClosed;

  /// Whether `this` [contains] its bounds.
  bool get isOpenClosed => !lowerClosed && upperClosed;

  /// Whether `this` is both [lowerBounded] and [upperBounded].
  bool get bounded => lowerBounded && upperBounded;

  /// Whether `this` has a [lower] bound.
  bool get lowerBounded => lower != null;

  /// Whether `this` has an [upper] bound.
  bool get upperBounded => upper != null;

  /// Whether `this` [contains] any values.
  bool get isEmpty  => _boundValuesEqual && !isClosed;

  /// Whether `this` [contains] exactly one value.
  bool get isSingleton => _boundValuesEqual && isClosed;

  bool get _boundValuesEqual =>
      bounded && Comparable.compare(lower, upper) == 0;

  /// Returns an interval which contains the same values as `this`, except any
  /// closed bounds become open.
  Interval<T> get interior => isOpen ? this : new Interval<T>.open(lower, upper);

  /// Returns an interval which contains the same values as `this`, except any
  /// open bounds become closed.
  Interval<T> get closure => isClosed ? this : new Interval<T>.closed(lower, upper);

  /// An interval constructed from its [Bound]s.
  ///
  /// If [lowerBound] or [upperBound] are `null`, then the interval is unbounded
  /// in that direction.
  Interval({this.lower, this.upper, this.lowerClosed, this.upperClosed}) {
    _checkNotOpenAndEqual(_checkBoundOrder());
  }

  /// `(`[lower]`..`[upper]`)`
  Interval.open(this.lower, this.upper)
      : lowerClosed = false,
        upperClosed = false {
    _checkNotOpenAndEqual(_checkBoundOrder());
  }

  /// `[`[lower]`..`[upper]`]`
  Interval.closed(this.lower, this.upper)
      : lowerClosed = true,
        upperClosed = true {
    if (lower == null) throw new ArgumentError('lower cannot be null');
    if (upper == null) throw new ArgumentError('upper cannot be null');
    _checkBoundOrder();
  }

  /// `(`[lower]`..`[upper]`]`
  Interval.openClosed(this.lower, this.upper)
      : lowerClosed = false,
        upperClosed = true {
    if (upper == null) throw new ArgumentError('upper cannot be null');
    _checkBoundOrder();
  }

  /// `[`[lower]`..`[upper]`)`
  Interval.closedOpen(this.lower, this.upper)
      : lowerClosed = true,
        upperClosed = false {
    if (lower == null) throw new ArgumentError('lower cannot be null');
    _checkBoundOrder();
  }

  int _checkBoundOrder() {
    if (lower == null || upper == null) return -1;
    var compare = Comparable.compare(lower, upper);
    if (compare > 0) {
      throw new ArgumentError('upper must not be less than lower');
    }
    return compare;
  }

  _checkNotOpenAndEqual(int compare) {
    if (compare == 0 && !lowerClosed && !upperClosed) {
      throw new ArgumentError('invalid empty open interval ( of form (v..v) )');
    }
  }

  /// `[`[lower]`.. +∞ )`
  Interval.atLeast(this.lower)
      : upper = null,
        lowerClosed = true,
        upperClosed = false {
    if (lower == null) throw new ArgumentError('lower cannot be null');
  }

  /// `( -∞ ..`[upper]`]`
  Interval.atMost(this.upper)
      : lower = null,
        lowerClosed = false,
        upperClosed = true {
    if (upper == null) throw new ArgumentError('upper cannot be null');
  }

  /// `(`[lower]`.. +∞ )`
  Interval.greaterThan(this.lower)
      : upper = null,
        lowerClosed = false,
        upperClosed = false;

  /// `( -∞ ..`[upper]`)`
  Interval.lessThan(this.upper)
      : lower = null,
        lowerClosed = false,
        upperClosed = false;

  /// `( -∞ .. +∞ )`
  Interval.all()
      : lower = null,
        upper = null,
        lowerClosed = false,
        upperClosed = false;

  /// `[`[value]`..`[value]`]`
  Interval.singleton(T value)
      : lower = value,
        upper = value,
        lowerClosed = true,
        upperClosed = true {
    if (value == null) throw new ArgumentError('value cannot be null');
  }

  /// The minimal interval which [contains] each value in [values].
  ///
  /// If [values] is empty, the returned interval contains all values.
  factory Interval.span(Iterable<T> all) {
    var iterator = all.iterator;
    var hasNext = iterator.moveNext();
    if (!hasNext) return new Interval<T>.all();
    var upper = iterator.current;
    var lower = iterator.current;
    while (iterator.moveNext()) {
      if (Comparable.compare(lower, iterator.current) > 0) {
        lower = iterator.current;
      }
      if (Comparable.compare(upper, iterator.current) < 0) {
        upper = iterator.current;
      }
    }
    return new Interval<T>.closed(lower, upper);
  }

  /// The minimal interval which [encloses] each interval in [intervals].
  ///
  /// If [intervals] is empty, the returned interval contains all values.
  factory Interval.encloseAll(Iterable<Interval<T>> intervals) {

    var iterator = intervals.iterator;
    if (!iterator.moveNext()) return new Interval<T>.all();
    var interval = iterator.current;
    var lower = interval.lower;
    var upper = interval.upper;
    var lowerClosed = interval.lowerClosed;
    var upperClosed = interval.upperClosed;
    while (iterator.moveNext()) {
      interval = iterator.current;
      if (interval.lower == null) {
        lower = null;
        lowerClosed = false;
        if (upper == null) break;
      } else {
        if (lower != null && Comparable.compare(lower, interval.lower) >= 0) {
          lower = interval.lower;
          lowerClosed = lowerClosed || interval.lowerClosed;
        }
      }
      if (interval.upper == null) {
        upper = null;
        upperClosed = false;
        if (lower == null) break;
      } else {
        if (upper != null && Comparable.compare(upper, interval.upper) <= 0) {
          upper = interval.upper;
          upperClosed = upperClosed || interval.upperClosed;
        }
      }
    }
    return new Interval<T>(
        lower: lower,
        upper: upper,
        lowerClosed: lowerClosed,
        upperClosed: upperClosed);
  }

  /// The maximal interval which is enclosed in each interval in [intervals].
  ///
  /// If [intervals] is empty, the returned interval contains all values.
  ///
  /// If [intervals] do not overlap, `null` is returned.
  factory Interval.intersectAll(Iterable<Interval<T>> intervals) {

    var iterator = intervals.iterator;
    if (!iterator.moveNext()) return new Interval.all();
    var interval = iterator.current;
    var lower = interval.lower;
    var upper = interval.upper;
    var lowerClosed = interval.lowerClosed;
    var upperClosed = interval.upperClosed;
    while (iterator.moveNext()) {
      interval = iterator.current;
      if (lower == null) {
        lower = interval.lower;;
        lowerClosed = interval.lowerClosed;
      } else {
        if (interval.lower != null) {
          var cmp =  Comparable.compare(lower, interval.lower);
          if (cmp<=0) {
            lower = interval.lower;
            lowerClosed = (cmp!=0||lowerClosed) && interval.lowerClosed;
          }
        }
      }
      if (upper == null) {
        upper = interval.upper;
        upperClosed = interval.upperClosed;
      } else {
        if (interval.upper != null) {
          var cmp = Comparable.compare(upper, interval.upper);
          if (cmp>=0) {
            upper = interval.upper;
            upperClosed = (cmp!=0||upperClosed) && interval.upperClosed;
          }
        }
      }
    }
    var cmp = Comparable.compare(lower, upper);
    if (cmp>0) return null;
    if (cmp==0&&(!upperClosed||!lowerClosed)) return null;
    return new Interval<T>(
        lower: lower,
        upper: upper,
        lowerClosed: lowerClosed,
        upperClosed: upperClosed);
  }

  /// Returns the intersection of `this` interval with [other].
  ///
  /// If the intervals do not intersect, `null` is returned.
  Interval<T> intersect(Interval<T> other) => new Interval.intersectAll([this,other]);

  /// Returns minimal interval that [encloses] both `this` and [other].
  Interval<T> enclose(Interval<T> other) => new Interval.encloseAll([this,other]);



  /// Whether `this` contains [test].
  bool contains(T test) {
    if (lower != null) {
      var lowerCompare = Comparable.compare(lower, test);
      if (lowerCompare > 0 || (!lowerClosed && lowerCompare == 0)) return false;
    }
    if (upper != null) {
      var upperCompare = Comparable.compare(upper, test);
      if (upperCompare < 0 || (!upperClosed && upperCompare == 0)) return false;
    }
    return true;
  }

  /// Whether `this` [contains] each value that [other] does.
  bool encloses(Interval<T> other) {
    if (lowerBounded) {
      if (!other.lowerBounded) {
        return false;
      } else {
        var lowerCompare = Comparable.compare(lower, other.lower);
        if (lowerCompare > 0 || (lowerCompare == 0 && !lowerClosed &&
            other.lowerClosed)) {
          return false;
        }
      }
    }
    if (upperBounded) {
      if (!other.upperBounded) {
        return false;
      } else {
        var upperCompare = Comparable.compare(upper, other.upper);
        if (upperCompare < 0 || (upperCompare == 0 && !upperClosed &&
            other.upperClosed)) {
          return false;
        }
      }
    }
    return true;
  }

  /// Whether the intersection of `this` and [other] is not empty.
  bool intersects(Interval<T> other) => intersect(other)!=null;

  /// Whether the union of `this` and [other] is connected (i.e. is an
  /// [Interval]).
  bool connectedTo(Interval<T> other) {
    bool overlapping(Interval<T> lower, Interval<T> upper) {
      if (lower.lower == null || upper.upper == null) return true;
      var comparison = lower.lower.compareTo(upper.upper);
      return comparison < 0 ||
          (comparison == 0 && (lower.lowerClosed || upper.upperClosed));
    }
    return overlapping(this, other) && overlapping(other, this);
  }

  int get hashCode => lower.hashCode ^ upper.hashCode ^ lowerClosed.hashCode ^
      upperClosed.hashCode;

  bool operator == (Interval<T> other) =>
      other is Interval<T> &&
      lower == other.lower &&
      upper == other.upper &&
      lowerClosed == other.lowerClosed &&
      upperClosed == other.upperClosed;

  String toString() {
    var open = '${lowerClosed ? '[' : '('}${lower == null ? '-∞' : lower}';
    var close = '${upper == null ? '+∞' : upper}${upperClosed? ']' : ')'}';
    return '$open..$close';
  }

}
