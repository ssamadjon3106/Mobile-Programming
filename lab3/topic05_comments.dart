double circleArea(double radius) {
  // Area of a circle: A = pi * r^2
  const pi = 3.14159;

  /*
    We square the radius first (r * r),
    then multiply by pi to get the final area.
    Radius must be non-negative, otherwise the result is meaningless.
  */
  return pi * radius * radius;
}

/// Utility class with static helpers for validating user input.
class Validator {
  /// Checks whether [email] has a valid email format.
  ///
  /// Returns `true` if [email] contains a name, `@` and a domain.
  ///
  /// Throws an [ArgumentError] if [email] is empty.
  static bool isValidEmail(String email) {
    if (email.isEmpty) throw ArgumentError('Email cannot be empty');
    return RegExp(r'^[\w.]+@[\w]+\.[a-z]+$').hasMatch(email);
  }

  /// Checks whether [age] is within the allowed range.
  ///
  /// Returns `true` if [age] is between [min] and [max] (inclusive).
  ///
  /// Throws a [RangeError] if [min] is greater than [max].
  static bool isValidAge(int age, {int min = 0, int max = 120}) {
    if (min > max) throw RangeError('min must be <= max');
    return age >= min && age <= max;
  }
}

/// Calculates the **arithmetic mean** of a list of numbers.
///
/// Rules:
/// * The list must **not** be empty.
/// * Both `int` and `double` values are accepted.
/// * The result is always a `double`.
///
/// Example:
/// ```dart
/// final avg = mean([1, 2, 3]);
/// print(avg); // 2.0
/// ```
double mean(List<num> values) {
  if (values.isEmpty) throw ArgumentError('List cannot be empty');
  return values.reduce((a, b) => a + b) / values.length;
}

/// Base class for anything that can greet a user.
class Greeter {
  /// Old greeting method.
  ///
  /// Use [greet] instead, it supports custom names.
  @Deprecated('Use greet(name) instead')
  void sayHello() => print('Hello!');

  /// Greets a user by [name].
  void greet(String name) => print('Hello, $name!');
}

/// A greeter that greets in Uzbek.
class UzbekGreeter extends Greeter {
  /// Overrides [Greeter.greet] to use an Uzbek greeting.
  @override
  void greet(String name) => print('Assalomu alaykum, $name!');
}

/// A simple library book management API.
///
/// Use [Library] to add, find and borrow [Book]s.
class Library {
  final List<Book> _books = [];

  /// Number of books currently in the library.
  int get count => _books.length;

  /// Adds a [book] to the library.
  void addBook(Book book) => _books.add(book);

  /// Finds a book by its [isbn].
  ///
  /// Returns `null` if no book matches.
  Book? findByIsbn(String isbn) {
    for (final book in _books) {
      if (book.isbn == isbn) return book;
    }
    return null;
  }

  /// Marks the book with [isbn] as borrowed.
  ///
  /// Throws a [StateError] if the book is missing or already borrowed.
  void borrow(String isbn) {
    final book = findByIsbn(isbn);
    if (book == null) throw StateError('Book $isbn not found');
    if (book.isBorrowed) throw StateError('Book $isbn is already borrowed');
    book.isBorrowed = true;
  }
}

/// A single book stored in a [Library].
class Book {
  /// Unique book identifier.
  final String isbn;

  /// Title of the book.
  final String title;

  /// Whether the book is currently borrowed.
  bool isBorrowed = false;

  /// Creates a book with the given [isbn] and [title].
  Book(this.isbn, this.title);

  @override
  String toString() => '$title ($isbn)${isBorrowed ? ' - borrowed' : ''}';
}

void main() {
  print('Circle area (r=2): ${circleArea(2)}');

  print('Valid email? ${Validator.isValidEmail('samadjon@nu.uz')}');
  print('Valid age 150? ${Validator.isValidAge(150)}');

  print('Mean: ${mean([1, 2, 3, 4])}');

  Greeter g = UzbekGreeter();
  g.greet('Samadjon');

  final library = Library();
  library.addBook(Book('111', 'Clean Code'));
  library.borrow('111');
  print('Library: ${library.findByIsbn('111')}, total: ${library.count}');
}
