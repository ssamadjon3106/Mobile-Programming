# Lab 9 — One Cart, Four Ways: Notes & Answers

## Part 1: Shared Domain Model

**Q: Why make CartState immutable with copyWith instead of a mutable class?**

Immutable state guarantees that every change produces a new object.
State management tools (Riverpod, Bloc) rely on reference equality to
decide whether to rebuild widgets — mutating in place breaks that signal.
`copyWith` gives you an ergonomic way to derive a new state while keeping
the previous one intact, which is also what makes undo trivial.

**Q: What is the sentinel pattern and why is it needed in copyWith?**

Dart's optional named parameters conflate "not passed" with `null`, but
many fields legitimately hold `null` (e.g. `coupon`, `orderId`). Without
a sentinel, you can't distinguish `copyWith(coupon: null)` (explicitly
clear the coupon) from omitting `coupon` (keep existing value). Using a
private `const _sentinel = Object()` as the default lets you test
`if (coupon == _sentinel) this.coupon else coupon as String?` to decide.

---

## Part 2: setState

**Q: Where does undo history live in the setState approach?**

In a private `List<CartState> _history` field on the `State` subclass.
Only the widget's own `_push()` method writes to it.

**Q: Why check `mounted` after every `await` in `_checkout()`?**

After an `await`, the widget could have been disposed — the user
navigated away. Calling `setState` on an unmounted widget throws.
`mounted` is a property on `State<T>` that returns `false` after
`dispose()` has run.

**Q: What is the main downside of setState for this cart?**

State lives inside a single widget. Any descendant that needs it must
receive it as constructor arguments, and any sibling widget at a higher
level cannot access it at all without lifting state further up the tree.

---

## Part 3: Riverpod

**Q: Why use `Notifier` instead of `StateNotifier`?**

`Notifier<S>` (Riverpod 2.x) has access to `ref` as a field, so it can
read other providers synchronously in methods — here we `ref.read(checkoutApiProvider)`. `StateNotifier` predates this and requires
passing dependencies through the constructor.

**Q: What is the difference between `ref.watch` and `ref.read`?**

`ref.watch` subscribes to a provider and rebuilds the widget when the
value changes. `ref.read` reads the current value once without
subscribing — appropriate inside callbacks where you don't want a rebuild.

**Q: What does `ref.listen` add over `ref.watch`?**

`ref.listen` lets you react to state changes with a side effect (showing
a SnackBar, opening a dialog) without depending on that state to build
the widget tree. Its callback runs outside `build`, so it can call
`ScaffoldMessenger` safely.

**Q: Why is `canUndoProvider` a separate `Provider<bool>` rather than
a boolean derived inside the widget?**

Widgets that only need to know whether undo is possible shouldn't
rebuild every time an unrelated field (e.g. `itemCount`) changes.
A derived provider lets them subscribe to the boolean alone, so they
rebuild only when `canUndo` flips.

---

## Part 4: Cubit

**Q: What is the difference between Cubit and Bloc?**

`Cubit<S>` exposes `emit(S)` for you to call directly from public
methods. `Bloc<E, S>` takes typed events and routes them through
`on<E>` handlers, adding a seam between stimulus and response that
supports transformers (debounce, droppable, etc.). Cubits have less
boilerplate; Blocs give you a richer audit trail and concurrency control.

**Q: Why guard with `isClosed` after the `await` in `checkout()`?**

If the BlocProvider is removed from the tree while the network call is
in flight, the Cubit is closed. Calling `emit` on a closed Cubit throws.
`isClosed` lets you bail out gracefully.

---

## Part 5: Bloc

**Q: Why use `sealed class CartEvent` with `final class` subclasses?**

The `sealed` modifier makes the type closed for extension outside its
library. Combined with Dart's exhaustive `switch`, the compiler forces
you to handle every subtype. `final` subclasses additionally prevent
further extension, making the event hierarchy a true sum type.

**Q: What does `transformer: droppable()` do for checkout?**

`droppable()` (from `bloc_concurrency`) ignores any `CartCheckoutRequested` event that arrives while one is already being processed. This prevents double-submit bugs when the user taps the checkout button rapidly.

**Q: Why is undo history embedded in `CartState` for Bloc but stored
outside the state for setState/Riverpod/Cubit?**

`BlocBuilder` rebuilds only on `state` changes. If `canUndo` is derived
from a list outside the state, `BlocBuilder` has no way to observe it.
Embedding `history` in `CartState` means every undo-affecting action
emits a new state, which triggers the rebuild that re-evaluates `canUndo`.

---

## Part 6: Testing

**Q: What does `blocTest` check that a plain unit test can't?**

`blocTest` asserts the exact sequence of emitted states, not just the
final state. It also verifies that no extra states are emitted — catching
accidental side-effects like double-emits.

**Q: How does Equatable prevent duplicate emits in Cubit?**

`Cubit` skips calling listeners when the new state is equal to the
previous one. `Equatable` overrides `==` using `props`, so two
`CartState` objects with identical field values compare equal even if
they are different Dart object instances.
