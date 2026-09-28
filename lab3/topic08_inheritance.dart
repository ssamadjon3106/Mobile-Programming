class Animal {
  final String name;
  Animal(this.name);

  void makeSound() => print('$name makes a sound');
}

class Dog extends Animal {
  Dog(super.name);

  @override
  void makeSound() => print('$name says: Woof!');
}

class Vehicle {
  final String brand;
  Vehicle(this.brand);
}

class ElectricCar extends Vehicle {
  final int batteryCapacity;

  ElectricCar(super.brand, this.batteryCapacity);

  @override
  String toString() => '$brand with $batteryCapacity kWh battery';
}

class Shape {
  final String name;
  Shape(this.name);

  void describe() => print('I am a $name');
}

class Polygon extends Shape {
  final int sides;
  Polygon(super.name, this.sides);

  @override
  void describe() {
    super.describe();
    print('I have $sides sides');
  }
}

class Triangle extends Polygon {
  final double a, b, c;
  Triangle(this.a, this.b, this.c) : super('Triangle', 3);

  double get perimeter => a + b + c;

  @override
  void describe() {
    super.describe();
    print('My perimeter is $perimeter');
  }
}

abstract class Employee {
  final String name;
  Employee(this.name);

  double calculateSalary();

  void printPayslip() =>
      print('$name earns \$${calculateSalary().toStringAsFixed(2)}');
}

class FullTimeEmployee extends Employee {
  final double monthlySalary;
  FullTimeEmployee(super.name, this.monthlySalary);

  @override
  double calculateSalary() => monthlySalary;
}

class PartTimeEmployee extends Employee {
  final double hourlyRate;
  final int hours;
  PartTimeEmployee(super.name, this.hourlyRate, this.hours);

  @override
  double calculateSalary() => hourlyRate * hours;
}

final class SecureToken {
  final String value;
  SecureToken(this.value);
}

base class Account {
  double balance = 0;
  void deposit(double amount) => balance += amount;
}

final class SavingsAccount extends Account {
  final double interestRate;
  SavingsAccount(this.interestRate);

  void addInterest() => balance += balance * interestRate;
}

void main() {
  Animal pet = Dog('Rex');
  pet.makeSound();

  print(ElectricCar('Tesla', 75));

  Triangle(3, 4, 5).describe();

  final staff = <Employee>[
    FullTimeEmployee('Ali', 3000),
    PartTimeEmployee('Vali', 15, 80),
  ];
  for (final e in staff) {
    e.printPayslip();
  }

  final token = SecureToken('abc123');
  final savings = SavingsAccount(0.05)..deposit(1000);
  savings.addInterest();
  print('Token: ${token.value}, savings balance: ${savings.balance}');
}
