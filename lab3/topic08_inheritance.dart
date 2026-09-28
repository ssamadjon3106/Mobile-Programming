// Topic 8: Inheritance (Problems 8.2 - 8.6)

// 8.2 Base class Animal, derived Dog overriding makeSound()
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

// 8.3 Super-initializer parameters syntax
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

// 8.4 Multi-level hierarchy: Shape -> Polygon -> Triangle
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

// 8.5 Abstract base class with concrete and abstract methods
abstract class Employee {
  final String name;
  Employee(this.name);

  // Abstract: every subclass must implement
  double calculateSalary();

  // Concrete: shared by all subclasses
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

// 8.6 Dart 3 final and base class modifiers
// `final class` cannot be extended or implemented outside this library.
final class SecureToken {
  final String value;
  SecureToken(this.value);
}

// `base class` can be extended, but not implemented outside this library.
// Subclasses must themselves be base, final or sealed.
base class Account {
  double balance = 0;
  void deposit(double amount) => balance += amount;
}

final class SavingsAccount extends Account {
  final double interestRate;
  SavingsAccount(this.interestRate);

  void addInterest() => balance += balance * interestRate;
}

// In another file these would be compile errors:
// class FakeToken extends SecureToken {}        // final: cannot extend
// class MyAccount implements Account {}          // base: cannot implement
// class MoreSavings extends SavingsAccount {}    // final: cannot extend

void main() {
  // Test 8.2
  Animal pet = Dog('Rex');
  pet.makeSound();

  // Test 8.3
  print(ElectricCar('Tesla', 75));

  // Test 8.4
  Triangle(3, 4, 5).describe();

  // Test 8.5
  final staff = <Employee>[
    FullTimeEmployee('Ali', 3000),
    PartTimeEmployee('Vali', 15, 80),
  ];
  for (final e in staff) {
    e.printPayslip();
  }

  // Test 8.6
  final token = SecureToken('abc123');
  final savings = SavingsAccount(0.05)..deposit(1000);
  savings.addInterest();
  print('Token: ${token.value}, savings balance: ${savings.balance}');
}
