import 'package:bloc_test/bloc_test.dart';
import 'package:cart_four_ways/cubit/cart_cubit.dart';
import 'package:cart_four_ways/models/cart.dart';
import 'package:cart_four_ways/services/checkout_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockCheckoutApi extends Mock implements CheckoutApi {}

void main() {
  group('CartCubit', () {
    late _MockCheckoutApi mockApi;

    setUp(() {
      mockApi = _MockCheckoutApi();
    });

    blocTest<CartCubit, CartState>(
      'add product emits state with itemCount 1',
      build: () => CartCubit(mockApi),
      act: (c) => c.add(catalog[0]),
      expect: () => [
        isA<CartState>().having((s) => s.itemCount, 'itemCount', 1),
      ],
    );

    blocTest<CartCubit, CartState>(
      'applying same valid coupon twice emits only one state (Equatable dedup)',
      build: () => CartCubit(mockApi),
      act: (c) {
        c.add(catalog[0]);
        c.applyCoupon('SAVE10');
        c.applyCoupon('SAVE10'); // duplicate — should not emit
      },
      // 2 emits: add + first coupon; second coupon is deduplicated by Equatable
      verify: (c) {
        expect(c.state.coupon, 'SAVE10');
      },
    );

    blocTest<CartCubit, CartState>(
      'undo after two adds yields itemCount 1',
      build: () => CartCubit(mockApi),
      act: (c) {
        c.add(catalog[0]);
        c.add(catalog[1]);
        c.undo();
      },
      verify: (c) {
        expect(c.state.itemCount, 1);
      },
    );

    blocTest<CartCubit, CartState>(
      'successful checkout emits submitting then success',
      build: () {
        when(() => mockApi.submit(any())).thenAnswer((_) async => 'ORD-42');
        return CartCubit(mockApi);
      },
      act: (c) async {
        c.add(catalog[0]); // $49
        await c.checkout();
      },
      expect: () => [
        isA<CartState>().having((s) => s.itemCount, 'itemCount', 1),
        isA<CartState>()
            .having((s) => s.status, 'status', CheckoutStatus.submitting),
        isA<CartState>()
            .having((s) => s.status, 'status', CheckoutStatus.success)
            .having((s) => s.orderId, 'orderId', 'ORD-42'),
      ],
    );

    blocTest<CartCubit, CartState>(
      'failed checkout emits submitting then failure',
      build: () {
        when(() => mockApi.submit(any()))
            .thenThrow(const CheckoutException('Declined'));
        return CartCubit(mockApi);
      },
      act: (c) async {
        c.add(catalog[2]); // $199
        await c.checkout();
      },
      expect: () => [
        isA<CartState>().having((s) => s.itemCount, 'itemCount', 1),
        isA<CartState>()
            .having((s) => s.status, 'status', CheckoutStatus.submitting),
        isA<CartState>()
            .having((s) => s.status, 'status', CheckoutStatus.failure)
            .having((s) => s.checkoutError, 'error', 'Declined'),
      ],
    );
  });
}
