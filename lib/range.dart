/// A contiguous set of values.
///
/// If an interval [contains] two values, it also contains all values between
/// them.  It may have an [upper] and [lower] bound, and those bounds may be
/// open or closed.
class Range<T extends Comparable<T>> {
  /// An interval constructed from its [Bound]s.
  ///
  /// If [lowerBound] or [upperBound] are `null`, then the interval is unbounded
  /// in that direction.
  Range({this.lower, this.upper, this.lowerClosed, this.upperClosed}) {
    _checkNotOpenAndEqual(_checkBoundOrder());
  }

  /// `(`[lower]`..`[upper]`)`
  Range.open(this.lower, this.upper)
      : lowerClosed = false,
        upperClosed = false {
    _checkNotOpenAndEqual(_checkBoundOrder());
  }

  /// `[`[lower]`..`[upper]`]`
  Range.closed(this.lower, this.upper)
      : lowerClosed = true,
        upperClosed = true {
    if (lower == null) throw ArgumentError('lower cannot be null');
    if (upper == null) throw ArgumentError('upper cannot be null');
    _checkBoundOrder();
  }

  /// `(`[lower]`..`[upper]`]`
  Range.openClosed(this.lower, this.upper)
      : lowerClosed = false,
        upperClosed = true {
    if (upper == null) throw ArgumentError('upper cannot be null');
    _checkBoundOrder();
  }

  /// `[`[lower]`..`[upper]`)`
  Range.closedOpen(this.lower, this.upper)
      : lowerClosed = true,
        upperClosed = false {
    if (lower == null) throw ArgumentError('lower cannot be null');
    _checkBoundOrder();
  }

  /// `[`[lower]`.. +∞ )`
  Range.atLeast(this.lower)
      : upper = null,
        lowerClosed = true,
        upperClosed = false {
    if (lower == null) throw ArgumentError('lower cannot be null');
  }

  /// `( -∞ ..`[upper]`]`
  Range.atMost(this.upper)
      : lower = null,
        lowerClosed = false,
        upperClosed = true {
    if (upper == null) throw ArgumentError('upper cannot be null');
  }

  /// `(`[lower]`.. +∞ )`
  Range.greaterThan(this.lower)
      : upper = null,
        lowerClosed = false,
        upperClosed = false;

  /// `( -∞ ..`[upper]`)`
  Range.lessThan(this.upper)
      : lower = null,
        lowerClosed = false,
        upperClosed = false;

  /// `( -∞ .. +∞ )`
  Range.all()
      : lower = null,
        upper = null,
        lowerClosed = false,
        upperClosed = false;

  /// `[`[value]`..`[value]`]`
  Range.singleton(T value)
      : lower = value,
        upper = value,
        lowerClosed = true,
        upperClosed = true {
    if (value == null) throw ArgumentError('value cannot be null');
  }

  /// The minimal interval which [contains] each value in [values].
  ///
  /// If [values] is empty, the returned interval contains all values.
  factory Range.span(Iterable<T> all) {
    final iterator = all.iterator;
    final hasNext = iterator.moveNext();
    if (!hasNext) return Range<T>.all();
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
    return Range<T>.closed(lower, upper);
  }

  /// The minimal interval which [encloses] each interval in [intervals].
  ///
  /// If [intervals] is empty, the returned interval contains all values.
  factory Range.encloseAll(Iterable<Range<T>> intervals) {
    final iterator = intervals.iterator;
    if (!iterator.moveNext()) return Range<T>.all();
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
    return Range<T>(
        lower: lower,
        upper: upper,
        lowerClosed: lowerClosed,
        upperClosed: upperClosed);
  }

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
  Range<T> get interior => isOpen ? this : Range<T>.open(lower, upper);

  /// Returns an interval which contains the same values as `this`, except any
  /// open bounds become closed.
  Range<T> get closure => isClosed ? this : Range<T>.closed(lower, upper);

  int _checkBoundOrder() {
    if (lower == null || upper == null) return -1;
    final compare = Comparable.compare(lower, upper);
    if (compare > 0) {
      throw ArgumentError('upper must not be less than lower');
    }
    return compare;
  }

  void _checkNotOpenAndEqual(int compare) {
    if (compare == 0 && !lowerClosed && !upperClosed) {
      throw ArgumentError('invalid empty open interval ( of form (v..v) )');
    }
  }

  /// Whether `this` contains [test].
  bool contains(T test) {
    if (lower != null) {
      final lowerCompare = Comparable.compare(lower, test);
      if (lowerCompare > 0 || (!lowerClosed && lowerCompare == 0)) return false;
    }
    if (upper != null) {
      final upperCompare = Comparable.compare(upper, test);
      if (upperCompare < 0 || (!upperClosed && upperCompare == 0)) return false;
    }
    return true;
  }

  /// Whether `this` [contains] each value that [other] does.
  bool encloses(Range<T> other) {
    if (lowerBounded) {
      if (!other.lowerBounded) {
        return false;
      } else {
        final lowerCompare = Comparable.compare(lower, other.lower);
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
        final upperCompare = Comparable.compare(upper, other.upper);
        if (upperCompare < 0 || (upperCompare == 0 && !upperClosed &&
            other.upperClosed)) {
          return false;
        }
      }
    }
    return true;
  }

  /// Whether the union of `this` and [other] is connected (i.e. is an
  /// [Range]).
  bool connectedTo(Range<T> other) {
    bool overlapping(Range<T> lower, Range<T> upper) {
      if (lower.lower == null || upper.upper == null) return true;
      final comparison = lower.lower.compareTo(upper.upper);
      return comparison < 0 ||
          (comparison == 0 && (lower.lowerClosed || upper.upperClosed));
    }
    return overlapping(this, other) && overlapping(other, this);
  }

  @override
  int get hashCode => lower.hashCode ^ upper.hashCode ^ lowerClosed.hashCode ^
      upperClosed.hashCode;

  @override
  bool operator == (Object other) =>
      other is Range<T> &&
      lower == other.lower &&
      upper == other.upper &&
      lowerClosed == other.lowerClosed &&
      upperClosed == other.upperClosed;

  @override
  String toString() {
    final open = '${lowerClosed ? '[' : '('}${lower == null ? '-∞' : lower}';
    final close = '${upper == null ? '+∞' : upper}${upperClosed ? ']' : ')'}';
    return '$open..$close';
  }

}
