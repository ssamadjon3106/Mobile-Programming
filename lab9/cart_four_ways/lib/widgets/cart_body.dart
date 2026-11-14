import 'package:flutter/material.dart';
import '../models/cart.dart';

class CartBody extends StatelessWidget {
  const CartBody({
    super.key,
    required this.state,
    required this.onAdd,
    required this.onRemove,
    required this.onQtyChanged,
    required this.onApplyCoupon,
    required this.onCheckout,
    required this.onUndo,
  });

  final CartState state;
  final void Function(Product) onAdd;
  final void Function(String) onRemove;
  final void Function(String id, int delta) onQtyChanged;
  final void Function(String) onApplyCoupon;
  final VoidCallback onCheckout;
  final VoidCallback onUndo;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _CatalogSection(onAdd: onAdd),
        const Divider(),
        Expanded(
          child: state.lines.isEmpty
              ? const Center(child: Text('Your cart is empty'))
              : ListView.builder(
                  itemCount: state.lines.length,
                  itemBuilder: (_, i) {
                    final line = state.lines[i];
                    return ListTile(
                      title: Text(line.product.name),
                      subtitle: Text('\$${line.product.price.toStringAsFixed(2)} each'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () => onQtyChanged(line.product.id, -1),
                          ),
                          Text('${line.qty}',
                              style: Theme.of(context).textTheme.titleMedium),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () => onQtyChanged(line.product.id, 1),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => onRemove(line.product.id),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
        const Divider(),
        _CouponRow(onApply: onApplyCoupon, couponError: state.couponError),
        _SummaryCard(
          state: state,
          onCheckout: onCheckout,
          onUndo: onUndo,
        ),
      ],
    );
  }
}

class _CatalogSection extends StatelessWidget {
  const _CatalogSection({required this.onAdd});
  final void Function(Product) onAdd;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Catalog', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            children: [
              for (final p in catalog)
                ActionChip(
                  label: Text('${p.name} \$${p.price.toStringAsFixed(0)}'),
                  onPressed: () => onAdd(p),
                  avatar: const Icon(Icons.add_shopping_cart, size: 16),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CouponRow extends StatefulWidget {
  const _CouponRow({required this.onApply, this.couponError});
  final void Function(String) onApply;
  final String? couponError;

  @override
  State<_CouponRow> createState() => _CouponRowState();
}

class _CouponRowState extends State<_CouponRow> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _ctrl,
              decoration: InputDecoration(
                labelText: 'Coupon code',
                errorText: widget.couponError,
                border: const OutlineInputBorder(),
                isDense: true,
              ),
              textCapitalization: TextCapitalization.characters,
            ),
          ),
          const SizedBox(width: 8),
          FilledButton(
            onPressed: () {
              widget.onApply(_ctrl.text.trim().toUpperCase());
              _ctrl.clear();
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.state,
    required this.onCheckout,
    required this.onUndo,
  });
  final CartState state;
  final VoidCallback onCheckout;
  final VoidCallback onUndo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Subtotal'),
                Text('\$${state.subtotal.toStringAsFixed(2)}'),
              ],
            ),
            if (state.discount > 0) ...[
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Discount (${state.coupon})',
                      style: const TextStyle(color: Colors.green)),
                  Text('-\$${state.discount.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.green)),
                ],
              ),
            ],
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total', style: theme.textTheme.titleMedium),
                Text('\$${state.total.toStringAsFixed(2)}',
                    style: theme.textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 8),
            if (state.status == CheckoutStatus.success)
              Text('Order placed! ID: ${state.orderId}',
                  style: const TextStyle(color: Colors.green),
                  textAlign: TextAlign.center),
            if (state.status == CheckoutStatus.failure)
              Text('Error: ${state.checkoutError}',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: state.isSubmitting || state.lines.isEmpty
                        ? null
                        : onCheckout,
                    child: state.isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Checkout'),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.outlined(
                  icon: const Icon(Icons.undo),
                  onPressed: state.canUndo ? onUndo : null,
                  tooltip: 'Undo',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
