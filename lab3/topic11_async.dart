import 'dart:async';

// Topic 11: Async Operations (Problems 11.2 - 11.6)

// 11.2 Simulated database lookup with a 2-second delay
Future<Map<String, Object>> findUser(int id) async {
  await Future.delayed(const Duration(seconds: 2));
  return {'id': id, 'name': 'Samadjon', 'major': 'Software Engineering'};
}

// 11.3 Future.wait() running three tasks concurrently
Future<int> fetchLikes() async {
  await Future.delayed(const Duration(milliseconds: 500));
  return 120;
}

Future<int> fetchComments() async {
  await Future.delayed(const Duration(milliseconds: 800));
  return 45;
}

Future<int> fetchShares() async {
  await Future.delayed(const Duration(milliseconds: 300));
  return 12;
}

// 11.4 Periodic timer stream, cancel after 5 emissions
Future<void> listenToTicks() {
  final done = Completer<void>();
  var count = 0;
  late StreamSubscription<int> subscription;

  subscription = Stream.periodic(const Duration(milliseconds: 200), (i) => i + 1)
      .listen((tick) {
    print('Tick $tick');
    count++;
    if (count == 5) {
      subscription.cancel();
      print('Subscription cancelled after 5 ticks');
      done.complete();
    }
  });

  return done.future;
}

// 11.5 Transform stream values with map(), where(), distinct()
Stream<int> numberStream() => Stream.fromIterable([1, 2, 2, 3, 4, 4, 4, 5, 6, 6]);

// 11.6 Error handling on a stream pipeline with handleError
Stream<int> sensorReadings() async* {
  for (var i = 1; i <= 5; i++) {
    await Future.delayed(const Duration(milliseconds: 100));
    if (i == 3) throw FormatException('Sensor $i returned bad data');
    yield i * 10;
  }
}

Future<void> main() async {
  // Test 11.2
  print('Looking up user...');
  final user = await findUser(1024);
  print('User found: $user');

  // Test 11.3
  final stopwatch = Stopwatch()..start();
  final results = await Future.wait([fetchLikes(), fetchComments(), fetchShares()]);
  final total = results.reduce((a, b) => a + b);
  print('Results: $results, total: $total (took ${stopwatch.elapsedMilliseconds} ms)');

  // Test 11.4
  await listenToTicks();

  // Test 11.5
  final transformed = await numberStream()
      .distinct() // 1, 2, 3, 4, 5, 6
      .where((n) => n.isEven) // 2, 4, 6
      .map((n) => n * n) // 4, 16, 36
      .toList();
  print('Transformed stream: $transformed');

  // Test 11.6
  // Note: an async* generator stops after it throws, so reading 4 and 5 are not emitted
  await sensorReadings()
      .map((value) => 'Reading: $value')
      .handleError((e) => print('Handled error: $e'))
      .forEach(print);
  print('Stream pipeline finished');
}
