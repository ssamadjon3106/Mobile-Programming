import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/cart.dart';
import '../services/checkout_api.dart';
import '../widgets/cart_body.dart';
import 'cart_cubit.dart';

class CubitCartPage extends StatelessWidget {
  const CubitCartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CartCubit(CheckoutApi()),
      child: const _CubitCartView(),
    );
  }
}

class _CubitCartView extends StatelessWidget {
  const _CubitCartView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartCubit, CartState>(
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
        final cubit = ctx.read<CartCubit>();
        // Expose canUndo via history field so CartBody works without changes.
        final viewState = state.copyWith(
          history: cubit.canUndo ? [const CartState()] : [],
        );
        return Scaffold(
          appBar: AppBar(
            title: Text('Cubit Cart (${state.itemCount})'),
            backgroundColor: Theme.of(ctx).colorScheme.tertiaryContainer,
          ),
          body: CartBody(
            state: viewState,
            onAdd: cubit.add,
            onRemove: cubit.remove,
            onQtyChanged: cubit.changeQty,
            onApplyCoupon: cubit.applyCoupon,
            onCheckout: cubit.checkout,
            onUndo: cubit.undo,
          ),
        );
      },
    );
  }
}
