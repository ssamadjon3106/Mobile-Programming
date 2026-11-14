import 'package:flutter/material.dart';
import '../models/cart.dart';
import '../services/checkout_api.dart';
import '../widgets/cart_body.dart';

class SetStateCartPage extends StatefulWidget {
  const SetStateCartPage({super.key});

  @override
  State<SetStateCartPage> createState() => _SetStateCartPageState();
}

class _SetStateCartPageState extends State<SetStateCartPage> {
  CartState _state = const CartState();
  final List<CartState> _history = [];
  final _api = CheckoutApi();

  // Push current state to history, then apply next.
  void _push(CartState next) {
    setState(() {
      _history.add(_state);
      _state = next;
    });
  }

  void _add(Product p) =>
      _push(_state.copyWith(lines: _state.lines.withProduct(p)));

  void _remove(String id) =>
      _push(_state.copyWith(lines: _state.lines.without(id)));

  void _changeQty(String id, int delta) =>
      _push(_state.copyWith(lines: _state.lines.changeQty(id, delta)));

  void _applyCoupon(String code) {
    if (code.isEmpty) return;
    if (code == 'SAVE10') {
      _push(_state.copyWith(coupon: code, couponError: null));
    } else {
      _push(_state.copyWith(coupon: null, couponError: 'Invalid coupon'));
    }
  }

  void _undo() {
    if (_history.isEmpty) return;
    setState(() {
      _state = _history.removeLast();
    });
  }

  Future<void> _checkout() async {
    _push(_state.copyWith(status: CheckoutStatus.submitting));
    try {
      final orderId = await _api.submit(_state.total);
      if (!mounted) return;
      setState(() {
        _state = _state.copyWith(
          status: CheckoutStatus.success,
          orderId: orderId,
          checkoutError: null,
        );
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order placed! ID: $orderId'),
          backgroundColor: Colors.green,
        ),
      );
    } on CheckoutException catch (e) {
      if (!mounted) return;
      setState(() {
        _state = _state.copyWith(
          status: CheckoutStatus.failure,
          checkoutError: e.message,
        );
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showMaterialBanner(
        MaterialBanner(
          content: Text(e.message),
          backgroundColor: Colors.red.shade100,
          actions: [
            TextButton(
              onPressed: () =>
                  ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
              child: const Text('Dismiss'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Pass a view of state that includes the history list so CartBody can
    // derive canUndo without needing a separate parameter.
    final viewState = _state.copyWith(history: _history);
    return Scaffold(
      appBar: AppBar(
        title: Text('setState Cart (${_state.itemCount})'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: CartBody(
        state: viewState,
        onAdd: _add,
        onRemove: _remove,
        onQtyChanged: _changeQty,
        onApplyCoupon: _applyCoupon,
        onCheckout: _checkout,
        onUndo: _undo,
      ),
    );
  }
}
