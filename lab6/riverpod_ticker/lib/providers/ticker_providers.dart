import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/legacy.dart';

import '../models/tick.dart';
import '../services/tick_feed.dart';

/// Overridable in tests and in the error demo.
final failAfterProvider = StateProvider<int?>((ref) => null);

final tickFeedProvider = Provider<TickFeed>(
  (ref) => TickFeed(failAfter: ref.watch(failAfterProvider)),
);

final tickerProvider = StreamProvider.autoDispose<List<Tick>>(
  (ref) => ref.watch(tickFeedProvider).watch(),
  retry: (_, _) => null,
);
