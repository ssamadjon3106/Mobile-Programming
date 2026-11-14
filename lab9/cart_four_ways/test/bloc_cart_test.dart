import 'package:bloc_test/bloc_test.dart';
import 'package:cart_four_ways/bloc/cart_bloc.dart';
import 'package:cart_four_ways/bloc/cart_event.dart';
import 'package:cart_four_ways/models/cart.dart';
import 'package:cart_four_ways/services/checkout_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockCheckoutApi extends Mock implements CheckoutApi {}

void main() {
  group('CartBloc', () {
    late _MockCheckoutApi mockApi;

    setUp(() {
      mockApi = _MockCheckoutApi();
    });

    blocTest<CartBloc, CartState>(
      'CartProductAdded adds item to cart',
      build: () => CartBloc(mockApi),
      act: (b) => b.add(CartProductAdded(catalog[0])),
      expect: () => [
        isA<CartState>().having((s) => s.itemCount, 'itemCount', 1),
      ],
    );

    blocTest<CartBloc, CartState>(
      'CartQtyChanged increments then decrements quantity',
      build: () => CartBloc(mockApi),
      act: (b) {
        b.add(CartProductAdded(catalog[0]));
        b.add(CartQtyChanged(catalog[0].id, 2));
        b.add(CartQtyChanged(catalog[0].id, -1));
      },
      verify: (b) {
        expect(b.state.lines.first.qty, 2); // 1 (add) + 2 - 1 = 2
      },
    );

    blocTest<CartBloc, CartState>(
      'CartUndone reverts to previous state',
      build: () => CartBloc(mockApi),
      act: (b) {
        b.add(CartProductAdded(catalog[0]));
        b.add(CartProductAdded(catalog[1]));
        b.add(const CartUndone());
      },
      verify: (b) {
        expect(b.state.lines.length, 1);
      },
    );

    blocTest<CartBloc, CartState>(
      'triple-tap checkout with droppable: only one submitting emitted',
      build: () {
        when(() => mockApi.submit(any()))
            .thenAnswer((_) async => 'ORD-1');
        return CartBloc(mockApi);
      },
      act: (b) async {
        b.add(CartProductAdded(catalog[0]));
        // Fire three times in quick succession — droppable drops the extras.
        b.add(const CartCheckoutRequested());
        b.add(const CartCheckoutRequested());
        b.add(const CartCheckoutRequested());
        // Allow async to complete.
        await Future<void>.delayed(const Duration(seconds: 2));
      },
      expect: () => [
        isA<CartState>().having((s) => s.itemCount, 'itemCount', 1),
        isA<CartState>()
            .having((s) => s.status, 'status', CheckoutStatus.submitting),
        isA<CartState>()
            .having((s) => s.status, 'status', CheckoutStatus.success),
      ],
    );

    blocTest<CartBloc, CartState>(
      'CartCouponApplied with SAVE10 applies discount',
      build: () => CartBloc(mockApi),
      act: (b) {
        b.add(CartProductAdded(catalog[0])); // $49
        b.add(const CartCouponApplied('SAVE10'));
      },
      verify: (b) {
        expect(b.state.discount, closeTo(4.9, 0.001));
        expect(b.state.coupon, 'SAVE10');
      },
    );
  });
}
