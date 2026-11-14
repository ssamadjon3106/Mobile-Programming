import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/cart.dart';
import '../services/checkout_api.dart';
import 'cart_event.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc(this._api) : super(const CartState()) {
    on<CartProductAdded>(_onProductAdded);
    on<CartProductRemoved>(_onProductRemoved);
    on<CartQtyChanged>(_onQtyChanged);
    on<CartCouponApplied>(_onCouponApplied);
    on<CartUndone>(_onUndone);
    // droppable: ignore concurrent checkout taps — only the first goes through.
    on<CartCheckoutRequested>(_onCheckoutRequested, transformer: droppable());
  }

  final CheckoutApi _api;

  // Build the history list for the NEXT state.
  // For Bloc, history is embedded in CartState so BlocBuilder can observe
  // canUndo without an extra local field outside the stream.
  List<CartState> _withHistory() => [...state.history, state.copyWith(history: const [])];

  static bool _isUndoable(CartEvent event) => switch (event) {
        CartProductAdded() ||
        CartProductRemoved() ||
        CartQtyChanged() ||
        CartCouponApplied() =>
          true,
        CartCheckoutRequested() || CartUndone() => false,
      };

  void _onProductAdded(CartProductAdded event, Emitter<CartState> emit) {
    emit(state.copyWith(
      lines: state.lines.withProduct(event.product),
      history: _withHistory(),
    ));
  }

  void _onProductRemoved(CartProductRemoved event, Emitter<CartState> emit) {
    emit(state.copyWith(
      lines: state.lines.without(event.productId),
      history: _withHistory(),
    ));
  }

  void _onQtyChanged(CartQtyChanged event, Emitter<CartState> emit) {
    emit(state.copyWith(
      lines: state.lines.changeQty(event.productId, event.delta),
      history: _withHistory(),
    ));
  }

  void _onCouponApplied(CartCouponApplied event, Emitter<CartState> emit) {
    if (event.code.isEmpty) return;
    if (event.code == 'SAVE10') {
      emit(state.copyWith(
        coupon: event.code,
        couponError: null,
        history: _withHistory(),
      ));
    } else {
      emit(state.copyWith(
        coupon: null,
        couponError: 'Invalid coupon',
        history: _withHistory(),
      ));
    }
  }

  void _onUndone(CartUndone event, Emitter<CartState> emit) {
    if (state.history.isEmpty) return;
    final prev = state.history.last;
    emit(prev.copyWith(history: state.history.sublist(0, state.history.length - 1)));
  }

  Future<void> _onCheckoutRequested(
    CartCheckoutRequested event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(status: CheckoutStatus.submitting));
    try {
      final orderId = await _api.submit(state.total);
      if (emit.isDone) return;
      emit(state.copyWith(
        status: CheckoutStatus.success,
        orderId: orderId,
        checkoutError: null,
      ));
    } on CheckoutException catch (e) {
      if (emit.isDone) return;
      emit(state.copyWith(
        status: CheckoutStatus.failure,
        checkoutError: e.message,
      ));
    }
  }
}
