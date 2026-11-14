import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart.dart';
import '../services/checkout_api.dart';

final checkoutApiProvider = Provider<CheckoutApi>((_) => CheckoutApi());

final cartProvider = NotifierProvider<CartNotifier, CartState>(CartNotifier.new);

/// Derived provider — avoids rebuilding the whole page just to toggle the
/// undo button; widgets that only care about canUndo watch this.
final canUndoProvider = Provider<bool>((ref) {
  // We expose canUndo via the notifier's public getter because _history
  // lives in the notifier, not in CartState for the Riverpod variant.
  return ref.watch(cartProvider.notifier).canUndo;
});

class CartNotifier extends Notifier<CartState> {
  final List<CartState> _history = [];

  @override
  CartState build() => const CartState();

  bool get canUndo => _history.isNotEmpty;

  void _push(CartState next) {
    _history.add(state);
    state = next;
  }

  void add(Product p) =>
      _push(state.copyWith(lines: state.lines.withProduct(p)));

  void remove(String id) =>
      _push(state.copyWith(lines: state.lines.without(id)));

  void changeQty(String id, int delta) =>
      _push(state.copyWith(lines: state.lines.changeQty(id, delta)));

  void applyCoupon(String code) {
    if (code.isEmpty) return;
    if (code == 'SAVE10') {
      _push(state.copyWith(coupon: code, couponError: null));
    } else {
      _push(state.copyWith(coupon: null, couponError: 'Invalid coupon'));
    }
  }

  void undo() {
    if (_history.isEmpty) return;
    state = _history.removeLast();
  }

  Future<void> checkout() async {
    final api = ref.read(checkoutApiProvider);
    _push(state.copyWith(status: CheckoutStatus.submitting));
    try {
      final orderId = await api.submit(state.total);
      state = state.copyWith(
        status: CheckoutStatus.success,
        orderId: orderId,
        checkoutError: null,
      );
    } on CheckoutException catch (e) {
      state = state.copyWith(
        status: CheckoutStatus.failure,
        checkoutError: e.message,
      );
    }
  }
}
