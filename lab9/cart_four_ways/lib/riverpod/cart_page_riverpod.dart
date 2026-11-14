import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart.dart';
import '../widgets/cart_body.dart';
import 'cart_notifier.dart';

class RiverpodCartPage extends ConsumerWidget {
  const RiverpodCartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cartProvider);
    final canUndo = ref.watch(canUndoProvider);
    final notifier = ref.read(cartProvider.notifier);

    // Side-effect: show SnackBar / MaterialBanner when checkout status changes.
    ref.listen<CheckoutStatus>(
      cartProvider.select((s) => s.status),
      (_, next) {
        if (next == CheckoutStatus.success) {
          final orderId = ref.read(cartProvider).orderId ?? '';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Order placed! ID: $orderId'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (next == CheckoutStatus.failure) {
          final error = ref.read(cartProvider).checkoutError ?? 'Unknown error';
          ScaffoldMessenger.of(context).showMaterialBanner(
            MaterialBanner(
              content: Text(error),
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
      },
    );

    // Build a view state that exposes canUndo through the history field
    // so CartBody can read state.canUndo without extra parameters.
    final viewState = state.copyWith(
      history: canUndo ? [const CartState()] : [],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Riverpod Cart (${state.itemCount})'),
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      ),
      body: CartBody(
        state: viewState,
        onAdd: notifier.add,
        onRemove: notifier.remove,
        onQtyChanged: notifier.changeQty,
        onApplyCoupon: notifier.applyCoupon,
        onCheckout: notifier.checkout,
        onUndo: notifier.undo,
      ),
    );
  }
}
