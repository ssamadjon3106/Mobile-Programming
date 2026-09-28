// Topic 7: Enums (Problems 7.2 - 7.6)

// 7.2 Basic enum Day, iterate using Day.values
enum Day { monday, tuesday, wednesday, thursday, friday, saturday, sunday }

// 7.3 Map enum value to a UI display string using a switch expression
String dayLabel(Day day) => switch (day) {
      Day.monday => 'Mon',
      Day.tuesday => 'Tue',
      Day.wednesday => 'Wed',
      Day.thursday => 'Thu',
      Day.friday => 'Fri',
      Day.saturday || Day.sunday => 'Weekend',
    };

// 7.4 Enhanced enum implementing an abstract interface with computed methods
abstract interface class Priced {
  double get price;
  double priceWithTax(double taxRate);
}

enum CoffeeSize implements Priced {
  small(price: 2.0, ml: 250),
  medium(price: 3.0, ml: 350),
  large(price: 4.0, ml: 500);

  @override
  final double price;
  final int ml;

  const CoffeeSize({required this.price, required this.ml});

  @override
  double priceWithTax(double taxRate) => price * (1 + taxRate);

  double get pricePerMl => price / ml;
}

// 7.5 Safely parse raw strings into enum values with values.byName()
enum Role { admin, editor, viewer }

Role parseRole(String raw) {
  try {
    return Role.values.byName(raw.trim().toLowerCase());
  } on ArgumentError {
    print('Unknown role "$raw", using viewer');
    return Role.viewer;
  }
}

// 7.6 Enhanced enum with generic parameter and static helper methods
enum Setting<T> {
  volume<int>(50),
  darkMode<bool>(false),
  language<String>('uz');

  final T defaultValue;

  const Setting(this.defaultValue);

  static Setting? fromName(String name) {
    for (final s in Setting.values) {
      if (s.name == name) return s;
    }
    return null;
  }

  static Map<String, Object?> defaults() =>
      {for (final s in Setting.values) s.name: s.defaultValue};
}

void main() {
  // Test 7.2
  for (final day in Day.values) {
    print('${day.index}: ${day.name}');
  }

  // Test 7.3
  print('Saturday label: ${dayLabel(Day.saturday)}');
  print('Monday label: ${dayLabel(Day.monday)}');

  // Test 7.4
  for (final size in CoffeeSize.values) {
    print('${size.name}: \$${size.priceWithTax(0.12).toStringAsFixed(2)} '
        '(${size.pricePerMl.toStringAsFixed(4)} \$/ml)');
  }

  // Test 7.5
  print('Parsed: ${parseRole(' Admin ')}');
  print('Parsed: ${parseRole('hacker')}');

  // Test 7.6
  int volume = Setting.volume.defaultValue;
  print('Default volume: $volume');
  print('Found: ${Setting.fromName('darkMode')}');
  print('All defaults: ${Setting.defaults()}');
}
