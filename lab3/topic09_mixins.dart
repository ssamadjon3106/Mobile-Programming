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

mixin Flyable {
  void fly() => print('$runtimeType is flying');
}

class Bird with Flyable {}

mixin Walker {
  void walk() => print('$runtimeType is walking');
}

mixin Swimmer {
  void swim() => print('$runtimeType is swimming');
}

class Duck with Walker, Swimmer, Flyable {}

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

abstract class Logger {
  void log(String msg) => print('[LOG] $msg');
}

class ConsoleLogger implements Logger {
  @override
  void log(String msg) => print('[CONSOLE] $msg');
}

mixin LoggerMixin {
  void log(String msg) => print('[MIXIN LOG] $msg');
}

class OrderService with LoggerMixin {
  void placeOrder(String item) => log('Order placed: $item');
}

void main() {
  DBConnector db = MySQLConnector();
  db.connect('mysql://localhost:3306/shop');
  print(db.query('SELECT * FROM users'));
  db.close();

  Bird().fly();

  final duck = Duck();
  duck.walk();
  duck.swim();
  duck.fly();

  RockStar('Freddie').playGuitar();

  ConsoleLogger().log('Implemented from scratch');
  OrderService().placeOrder('Laptop');
}
