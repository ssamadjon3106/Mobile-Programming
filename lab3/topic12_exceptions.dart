// Topic 12: Exceptions & Error Handling (Problems 12.2 - 12.6)

// 12.2 Division catching UnsupportedError on division by zero
int? safeDivide(int a, int b) {
  try {
    return a ~/ b;
  } on UnsupportedError catch (e) {
    print('Cannot divide $a by $b: $e');
    return null;
  }
}

// 12.3 Throw ArgumentError if a string parameter is empty or null
String greet(String? name) {
  if (name == null || name.trim().isEmpty) {
    throw ArgumentError.value(name, 'name', 'must not be null or empty');
  }
  return 'Hello, $name!';
}

// 12.4 `on` clause handling specific types differently from generic ones
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

// 12.5 Capture and print full stack traces
void levelThree() => throw StateError('Something broke deep inside');
void levelTwo() => levelThree();
void levelOne() => levelTwo();

// 12.6 Rethrow mechanism
Map<String, dynamic> loadConfig(String raw) {
  try {
    if (!raw.startsWith('{')) throw FormatException('Invalid config', raw);
    return {'loaded': true};
  } on FormatException catch (e) {
    print('loadConfig: logging error -> ${e.message}');
    rethrow; // pass the same exception (and stack trace) up to the caller
  }
}

void main() {
  // Test 12.2
  print('10 / 2 = ${safeDivide(10, 2)}');
  print('10 / 0 = ${safeDivide(10, 0)}');

  // Test 12.3
  print(greet('Samadjon'));
  for (final bad in [null, '   ']) {
    try {
      greet(bad);
    } on ArgumentError catch (e) {
      print('ArgumentError: ${e.message} (got: ${e.invalidValue})');
    }
  }

  // Test 12.4
  parseAge('20');
  parseAge('abc');
  parseAge('-5');

  // Test 12.5
  try {
    levelOne();
  } catch (e, stackTrace) {
    print('Caught: $e');
    print('Stack trace:\n$stackTrace');
  }

  // Test 12.6
  try {
    loadConfig('not json');
  } on FormatException catch (e) {
    print('main: caught rethrown exception -> ${e.message}');
  }
}
