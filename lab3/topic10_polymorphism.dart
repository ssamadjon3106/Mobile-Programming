import 'dart:math';

abstract class Shape {
  double area();
}

class Circle extends Shape {
  final double radius;
  Circle(this.radius);

  @override
  double area() => pi * radius * radius;
}

class Rectangle extends Shape {
  final double width, height;
  Rectangle(this.width, this.height);

  @override
  double area() => width * height;
}

void describe(Object value) {
  if (value is Circle) {
    print('Circle with radius ${value.radius}');
  } else if (value is Rectangle) {
    print('Rectangle ${value.width}x${value.height}');
  } else {
    print('Unknown: ${value.runtimeType}');
  }
}

class Repository<T> {
  final Map<int, T> _items = {};
  int _nextId = 1;

  int add(T item) {
    _items[_nextId] = item;
    return _nextId++;
  }

  T? getById(int id) => _items[id];
  List<T> getAll() => _items.values.toList();
  bool remove(int id) => _items.remove(id) != null;
}

sealed class Result {}

class Success extends Result {
  final String data;
  Success(this.data);
}

class Failure extends Result {
  final String error;
  Failure(this.error);
}

class Loading extends Result {}

String render(Result result) => switch (result) {
      Success(:final data) => 'Data: $data',
      Failure(:final error) => 'Error: $error',
      Loading() => 'Loading...',
    };

abstract interface class SortStrategy {
  List<int> sort(List<int> data);
}

class AscendingSort implements SortStrategy {
  @override
  List<int> sort(List<int> data) => [...data]..sort();
}

class DescendingSort implements SortStrategy {
  @override
  List<int> sort(List<int> data) => [...data]..sort((a, b) => b.compareTo(a));
}

class Sorter {
  SortStrategy strategy;
  Sorter(this.strategy);

  List<int> run(List<int> data) => strategy.sort(data);
}

void main() {
  final shapes = <Shape>[Circle(2), Rectangle(3, 4), Circle(1)];
  for (final s in shapes) {
    print('${s.runtimeType} area: ${s.area().toStringAsFixed(2)}');
  }

  Object item = Rectangle(2, 5);
  describe(item);
  describe('text');
  final rect = item as Rectangle;
  print('Cast area: ${rect.area()}');

  final names = Repository<String>();
  final id = names.add('Samadjon');
  names.add('Ali');
  print('Found: ${names.getById(id)}, all: ${names.getAll()}');
  final scores = Repository<int>()..add(95);
  print('Scores: ${scores.getAll()}');

  final results = <Result>[Loading(), Success('User #1'), Failure('Timeout')];
  for (final r in results) {
    print(render(r));
  }

  final data = [5, 2, 9, 1];
  final sorter = Sorter(AscendingSort());
  print('Ascending: ${sorter.run(data)}');
  sorter.strategy = DescendingSort();
  print('Descending: ${sorter.run(data)}');
}
