import 'dart:async';

Future<Map<String, Object>> findUser(int id) async {
  await Future.delayed(const Duration(seconds: 2));
  return {'id': id, 'name': 'Samadjon', 'major': 'Software Engineering'};
}

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

Stream<int> numberStream() => Stream.fromIterable([1, 2, 2, 3, 4, 4, 4, 5, 6, 6]);

Stream<int> sensorReadings() async* {
  for (var i = 1; i <= 5; i++) {
    await Future.delayed(const Duration(milliseconds: 100));
    if (i == 3) throw FormatException('Sensor $i returned bad data');
    yield i * 10;
  }
}

Future<void> main() async {
  print('Looking up user...');
  final user = await findUser(1024);
  print('User found: $user');

  final stopwatch = Stopwatch()..start();
  final results = await Future.wait([fetchLikes(), fetchComments(), fetchShares()]);
  final total = results.reduce((a, b) => a + b);
  print('Results: $results, total: $total (took ${stopwatch.elapsedMilliseconds} ms)');

  await listenToTicks();

  final transformed = await numberStream()
      .distinct()
      .where((n) => n.isEven)
      .map((n) => n * n)
      .toList();
  print('Transformed stream: $transformed');

  await sensorReadings()
      .map((value) => 'Reading: $value')
      .handleError((e) => print('Handled error: $e'))
      .forEach(print);
  print('Stream pipeline finished');
}
