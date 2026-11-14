import 'package:cart_four_ways/models/cart.dart';
import 'package:cart_four_ways/riverpod/cart_notifier.dart';
import 'package:cart_four_ways/services/checkout_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockCheckoutApi extends Mock implements CheckoutApi {}

void main() {
  group('CartNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
      addTearDown(container.dispose);
    });

    test('add product increments itemCount', () {
      container.read(cartProvider.notifier).add(catalog[0]);
      expect(container.read(cartProvider).itemCount, 1);
    });

    test('SAVE10 applies 10% discount', () {
      container.read(cartProvider.notifier).add(catalog[0]); // $49
      container.read(cartProvider.notifier).applyCoupon('SAVE10');
      final state = container.read(cartProvider);
      expect(state.discount, closeTo(4.9, 0.001));
      expect(state.total, closeTo(44.1, 0.001));
    });

    test('invalid coupon sets couponError', () {
      container.read(cartProvider.notifier).applyCoupon('BADCODE');
      expect(container.read(cartProvider).couponError, isNotNull);
    });

    test('undo restores previous state', () {
      final notifier = container.read(cartProvider.notifier);
      notifier.add(catalog[0]);
      notifier.add(catalog[1]);
      notifier.undo();
      expect(container.read(cartProvider).itemCount, 1);
    });

    test('checkout success updates status and orderId', () async {
      final mock = _MockCheckoutApi();
      when(() => mock.submit(any())).thenAnswer((_) async => 'ORD-9999');

      final c = ProviderContainer(
        overrides: [checkoutApiProvider.overrideWithValue(mock)],
      );
      addTearDown(c.dispose);

      c.read(cartProvider.notifier).add(catalog[0]); // $49
      await c.read(cartProvider.notifier).checkout();

      final state = c.read(cartProvider);
      expect(state.status, CheckoutStatus.success);
      expect(state.orderId, 'ORD-9999');
    });

    test('checkout failure over \$500 sets failure status', () async {
      final mock = _MockCheckoutApi();
      when(() => mock.submit(any()))
          .thenThrow(const CheckoutException('Card declined'));

      final c = ProviderContainer(
        overrides: [checkoutApiProvider.overrideWithValue(mock)],
      );
      addTearDown(c.dispose);

      c.read(cartProvider.notifier).add(catalog[2]); // $199 × many
      await c.read(cartProvider.notifier).checkout();

      final state = c.read(cartProvider);
      expect(state.status, CheckoutStatus.failure);
      expect(state.checkoutError, 'Card declined');
    });
  });
}
