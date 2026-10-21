# Riverpod AsyncValue lab notes

## Part 2

- `tickFeedProvider` is separate so the feed can be overridden in tests and in the error demo without changing the provider that consumes it.
- `autoDispose` releases the ticker subscription when no widget watches it, so navigating away stops the stream.
- During the feed's initial 800 ms delay, `tickerProvider` is `AsyncLoading` and `hasValue` is false.

## Part 3

- Removing the `AsyncLoading()` arm makes the analyzer report a non-exhaustive switch, because `AsyncValue` can still be `AsyncLoading`.
- The empty-list and single-symbol arms must come before the general `AsyncData(:final value)` arm because the general pattern would match them first.

## Part 4

- `ref.refresh(tickerProvider.future)` recreates the stream and returns a `Future` for its next value, so `RefreshIndicator` can await it. `ref.invalidate(tickerProvider)` marks the provider stale and lets Riverpod recreate it when it is next read.
- `isRefreshing` means an existing provider is fetching again while retaining its value; `isReloading` means a dependency changed and caused the provider to recompute.
- The loading-with-value pattern must be above the general data pattern so a refresh is rendered as a refresh instead of a normal completed state.

## Checkpoint questions

1. The three sealed `AsyncValue` subtypes are `AsyncData`, `AsyncLoading`, and `AsyncError`. A switch that misses one produces a non-exhaustive switch diagnostic.
2. `AsyncError.value` is non-null when an error happens after at least one successful emission. It is null when the first load fails before any data exists.
3. `ref.refresh(provider)` immediately disposes and recreates a provider and returns its new state. `ref.refresh(provider.future)` does the same through the provider's awaitable future. `ref.invalidate(provider)` marks it stale and defers recomputation until it is needed.
4. `AsyncValue(:final value?, isLoading: true)` must precede `AsyncData(:final value)` because a loading state with old data is more specific than ordinary data and needs the refresh UI.
5. Switch expressions are exhaustive and use Dart pattern matching, so the analyzer catches a forgotten state. `.when` can still be convenient for a short callback-based rendering decision.
