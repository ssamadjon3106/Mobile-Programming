class Person {
  String name;
  int age;

  Person(this.name, this.age);

  void introduce() => print("Hi, I'm $name and I'm $age years old.");
}

class Temperature {
  final double celsius;

  Temperature(double value)
      : assert(value <= 1000, 'Unrealistically hot'),
        celsius = _validate(value);

  static double _validate(double value) {
    if (value < -273.15) throw ArgumentError('Below absolute zero: $value');
    return value;
  }
}

class AppConfig {
  static final AppConfig _instance = AppConfig._internal();

  String theme = 'light';

  AppConfig._internal();

  factory AppConfig() => _instance;
}

class Student {
  final String name;
  double _gpa = 0;

  Student(this.name);

  double get gpa => _gpa;

  set gpa(double value) {
    if (value < 0 || value > 4.0) {
      throw RangeError('GPA must be between 0.0 and 4.0');
    }
    _gpa = value;
  }

  bool get isHonors => _gpa >= 3.5;
}

class UserDto {
  final int id;
  final String username;
  final String email;

  const UserDto({required this.id, required this.username, required this.email});

  UserDto copyWith({int? id, String? username, String? email}) => UserDto(
        id: id ?? this.id,
        username: username ?? this.username,
        email: email ?? this.email,
      );

  @override
  String toString() => 'UserDto(id: $id, username: $username, email: $email)';
}

void main() {
  Person('Samadjon', 20).introduce();

  print('Temperature: ${Temperature(25).celsius} C');
  try {
    Temperature(-300);
  } catch (e) {
    print('Invalid temperature: $e');
  }

  final config1 = AppConfig();
  final config2 = AppConfig();
  config1.theme = 'dark';
  print('Same instance? ${identical(config1, config2)}, theme: ${config2.theme}');

  final student = Student('Samadjon');
  student.gpa = 3.7;
  print('GPA: ${student.gpa}, honors: ${student.isHonors}');
  try {
    student.gpa = 5.0;
  } catch (e) {
    print('Error: $e');
  }

  const user = UserDto(id: 1, username: 'samadjon', email: 'samadjon@nu.uz');
  final updated = user.copyWith(email: 'new@nu.uz');
  print(user);
  print(updated);
}
