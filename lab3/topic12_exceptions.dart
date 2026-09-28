int? safeDivide(int a, int b) {
  try {
    return a ~/ b;
  } on UnsupportedError catch (e) {
    print('Cannot divide $a by $b: $e');
    return null;
  }
}

String greet(String? name) {
  if (name == null || name.trim().isEmpty) {
    throw ArgumentError.value(name, 'name', 'must not be null or empty');
  }
  return 'Hello, $name!';
}

void parseAge(String input) {
  try {
    final age = int.parse(input);
    if (age < 0) throw RangeError.value(age, 'age', 'cannot be negative');
    print('Age: $age');
  } on FormatException {
    print('"$input" is not a number');
  } on RangeError catch (e) {
    print('Range problem: ${e.message}');
  } catch (e) {
    print('Unexpected error: $e');
  }
}

void levelThree() => throw StateError('Something broke deep inside');
void levelTwo() => levelThree();
void levelOne() => levelTwo();

Map<String, dynamic> loadConfig(String raw) {
  try {
    if (!raw.startsWith('{')) throw FormatException('Invalid config', raw);
    return {'loaded': true};
  } on FormatException catch (e) {
    print('loadConfig: logging error -> ${e.message}');
    rethrow;
  }
}

void main() {
  print('10 / 2 = ${safeDivide(10, 2)}');
  print('10 / 0 = ${safeDivide(10, 0)}');

  print(greet('Samadjon'));
  for (final bad in [null, '   ']) {
    try {
      greet(bad);
    } on ArgumentError catch (e) {
      print('ArgumentError: ${e.message} (got: ${e.invalidValue})');
    }
  }

  parseAge('20');
  parseAge('abc');
  parseAge('-5');

  try {
    levelOne();
  } catch (e, stackTrace) {
    print('Caught: $e');
    print('Stack trace:\n$stackTrace');
  }

  try {
    loadConfig('not json');
  } on FormatException catch (e) {
    print('main: caught rethrown exception -> ${e.message}');
  }
}
