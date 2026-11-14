import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/cart.dart';
import '../services/checkout_api.dart';
import '../widgets/cart_body.dart';
import 'cart_bloc.dart';
import 'cart_event.dart';

class BlocCartPage extends StatelessWidget {
  const BlocCartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CartBloc(CheckoutApi()),
      child: const _BlocCartView(),
    );
  }
}

class _BlocCartView extends StatelessWidget {
  const _BlocCartView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartBloc, CartState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (ctx, state) {
        if (state.status == CheckoutStatus.success) {
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(
              content: Text('Order placed! ID: ${state.orderId}'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state.status == CheckoutStatus.failure) {
          ScaffoldMessenger.of(ctx).showMaterialBanner(
            MaterialBanner(
              content: Text(state.checkoutError ?? 'Checkout failed'),
              backgroundColor: Colors.red.shade100,
              actions: [
                TextButton(
                  onPressed: () =>
                      ScaffoldMessenger.of(ctx).hideCurrentMaterialBanner(),
                  child: const Text('Dismiss'),
                ),
              ],
            ),
          );
        }
      },
      builder: (ctx, state) {
        final bloc = ctx.read<CartBloc>();
        return Scaffold(
          appBar: AppBar(
            title: Text('Bloc Cart (${state.itemCount})'),
            backgroundColor: Theme.of(ctx).colorScheme.errorContainer,
          ),
          body: CartBody(
            state: state, // history embedded in state → canUndo just works
            onAdd: (p) => bloc.add(CartProductAdded(p)),
            onRemove: (id) => bloc.add(CartProductRemoved(id)),
            onQtyChanged: (id, delta) => bloc.add(CartQtyChanged(id, delta)),
            onApplyCoupon: (code) => bloc.add(CartCouponApplied(code)),
            onCheckout: () => bloc.add(const CartCheckoutRequested()),
            onUndo: () => bloc.add(const CartUndone()),
          ),
        );
      },
    );
  }
}
