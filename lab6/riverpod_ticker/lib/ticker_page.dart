import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/ticker_providers.dart';
import 'widgets/tick_row.dart';

class TickerPage extends ConsumerWidget {
  const TickerPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ticks = ref.watch(tickerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live ticker'),
        actions: [
          IconButton(
            tooltip: 'Simulate feed error',
            onPressed: () => ref.read(failAfterProvider.notifier).state = 5,
            icon: const Icon(Icons.cloud_off),
          ),
          IconButton(
            tooltip: 'Restore live feed',
            onPressed: () => ref.read(failAfterProvider.notifier).state = null,
            icon: const Icon(Icons.cloud_done),
          ),
        ],
      ),
      body: switch (ticks) {
        AsyncError(:final error, :final value?) => Column(
          children: [
            MaterialBanner(
              content: Text('Feed error: $error — showing last prices'),
              actions: [
                TextButton(
                  onPressed: () => ref.invalidate(tickerProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
            Expanded(
              child: Opacity(
                opacity: 0.5,
                child: ListView(
                  children: [
                    for (final t in value)
                      TickRow(t, key: ValueKey(t.symbol)),
                  ],
                ),
              ),
            ),
          ],
        ),
        AsyncError(:final error) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Could not load ticker\n$error', textAlign: TextAlign.center),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () => ref.invalidate(tickerProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        AsyncValue(:final value?, isLoading: true) => Column(
          children: [
            const LinearProgressIndicator(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => ref.refresh(tickerProvider.future),
                child: ListView(
                  children: [
                    for (final t in value)
                      TickRow(t, key: ValueKey(t.symbol)),
                  ],
                ),
              ),
            ),
          ],
        ),
        AsyncData(value: []) => const Center(
          child: Text('No symbols subscribed'),
        ),
        AsyncData(value: [final only]) => Center(child: TickRow(only)),
        AsyncData(:final value) => RefreshIndicator(
          onRefresh: () => ref.refresh(tickerProvider.future),
          child: ListView(
            children: [
              for (final t in value) TickRow(t, key: ValueKey(t.symbol)),
            ],
          ),
        ),
        AsyncLoading() => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
