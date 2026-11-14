import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/cart.dart';
import '../services/checkout_api.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit(this._api) : super(const CartState());

  final CheckoutApi _api;
  final List<CartState> _history = [];

  bool get canUndo => _history.isNotEmpty;

  void _push(CartState next) {
    _history.add(state);
    emit(next);
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
    emit(_history.removeLast());
  }

  Future<void> checkout() async {
    _push(state.copyWith(status: CheckoutStatus.submitting));
    try {
      final orderId = await _api.submit(state.total);
      if (isClosed) return;
      emit(state.copyWith(
        status: CheckoutStatus.success,
        orderId: orderId,
        checkoutError: null,
      ));
    } on CheckoutException catch (e) {
      if (isClosed) return;
      emit(state.copyWith(
        status: CheckoutStatus.failure,
        checkoutError: e.message,
      ));
    }
  }
}
