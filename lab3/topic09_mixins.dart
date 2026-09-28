// Topic 9: Mixins & Interfaces (Problems 9.2 - 9.6)

// 9.2 Interface class DBConnector implemented by MySQLConnector
interface class DBConnector {
  void connect(String url) {}
  List<Map<String, Object>> query(String sql) => [];
  void close() {}
}

class MySQLConnector implements DBConnector {
  bool _connected = false;

  @override
  void connect(String url) {
    _connected = true;
    print('MySQL connected to $url');
  }

  @override
  List<Map<String, Object>> query(String sql) {
    if (!_connected) throw StateError('Not connected');
    print('MySQL executing: $sql');
    return [
      {'id': 1, 'name': 'Samadjon'}
    ];
  }

  @override
  void close() {
    _connected = false;
    print('MySQL connection closed');
  }
}

// 9.3 Mixin Flyable applied to a Bird class
mixin Flyable {
  void fly() => print('$runtimeType is flying');
}

class Bird with Flyable {}

// 9.4 Multiple mixins on a single Duck class
mixin Walker {
  void walk() => print('$runtimeType is walking');
}

mixin Swimmer {
  void swim() => print('$runtimeType is swimming');
}

class Duck with Walker, Swimmer, Flyable {}

// 9.5 Restrict mixin application using the `on` keyword
class Musician {
  final String name;
  Musician(this.name);
}

mixin Guitarist on Musician {
  void playGuitar() => print('$name is playing guitar');
}

class RockStar extends Musician with Guitarist {
  RockStar(super.name);
}

// class Robot with Guitarist {} // Error: Robot does not extend Musician

// 9.6 implements vs with
abstract class Logger {
  void log(String msg) => print('[LOG] $msg');
}

// implements: gets only the contract, must rewrite every member
class ConsoleLogger implements Logger {
  @override
  void log(String msg) => print('[CONSOLE] $msg');
}

// with: reuses the existing implementation for free
mixin LoggerMixin {
  void log(String msg) => print('[MIXIN LOG] $msg');
}

class OrderService with LoggerMixin {
  void placeOrder(String item) => log('Order placed: $item');
}

void main() {
  // Test 9.2
  DBConnector db = MySQLConnector();
  db.connect('mysql://localhost:3306/shop');
  print(db.query('SELECT * FROM users'));
  db.close();

  // Test 9.3
  Bird().fly();

  // Test 9.4
  final duck = Duck();
  duck.walk();
  duck.swim();
  duck.fly();

  // Test 9.5
  RockStar('Freddie').playGuitar();

  // Test 9.6
  ConsoleLogger().log('Implemented from scratch');
  OrderService().placeOrder('Laptop');
}
