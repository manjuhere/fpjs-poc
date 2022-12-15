extension StringExtension on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  bool get isNotNullAndNotEmpty => (this != null && this!.trim().isNotEmpty);
}

extension IterableExtensions<T> on Iterable<T>? {
  bool get isNotNullAndNotEmpty => this != null && this!.isNotEmpty;

  bool get isNullOrEmpty => this == null || this!.isEmpty;

  Iterable<E>? mapIndexed<E>(E Function(T value, int index) f) {
    var i = 0;
    return this?.map((value) => f(value, i++));
  }
}
