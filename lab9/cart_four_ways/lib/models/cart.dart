import 'package:equatable/equatable.dart';

class Product extends Equatable {
  const Product({required this.id, required this.name, required this.price});
  final String id;
  final String name;
  final double price;
  @override
  List<Object?> get props => [id, name, price];
}

const catalog = [
  Product(id: 'p1', name: 'Keyboard', price: 49),
  Product(id: 'p2', name: 'Mouse', price: 25),
  Product(id: 'p3', name: 'Monitor', price: 199),
];

class CartLine extends Equatable {
  const CartLine({required this.product, required this.qty});
  final Product product;
  final int qty;
  double get subtotal => product.price * qty;
  CartLine copyWith({int? qty}) =>
      CartLine(product: product, qty: qty ?? this.qty);
  @override
  List<Object?> get props => [product, qty];
}

extension CartLines on List<CartLine> {
  List<CartLine> withProduct(Product p) {
    final i = indexWhere((l) => l.product.id == p.id);
    if (i == -1) return [...this, CartLine(product: p, qty: 1)];
    return [
      for (final l in this)
        l.product.id == p.id ? l.copyWith(qty: l.qty + 1) : l,
    ];
  }

  List<CartLine> without(String productId) =>
      [for (final l in this) if (l.product.id != productId) l];

  List<CartLine> changeQty(String productId, int delta) {
    final i = indexWhere((l) => l.product.id == productId);
    if (i == -1) return this;
    final updated = this[i].copyWith(qty: this[i].qty + delta);
    if (updated.qty <= 0) return without(productId);
    return [
      for (final l in this) l.product.id == productId ? updated : l,
    ];
  }

  double get subtotal => fold(0.0, (s, l) => s + l.subtotal);
  int get itemCount => fold(0, (s, l) => s + l.qty);
}

enum CheckoutStatus { idle, submitting, success, failure }

class CartState extends Equatable {
  const CartState({
    this.lines = const [],
    this.coupon,
    this.couponError,
    this.status = CheckoutStatus.idle,
    this.orderId,
    this.checkoutError,
    this.history = const [],
  });

  final List<CartLine> lines;
  final String? coupon;
  final String? couponError;
  final CheckoutStatus status;
  final String? orderId;
  final String? checkoutError;
  final List<CartState> history;

  double get subtotal => lines.subtotal;
  double get discount => coupon == 'SAVE10' ? subtotal * 0.1 : 0.0;
  double get total => subtotal - discount;
  int get itemCount => lines.itemCount;
  bool get isSubmitting => status == CheckoutStatus.submitting;
  bool get canUndo => history.isNotEmpty;

  CartState copyWith({
    List<CartLine>? lines,
    Object? coupon = _sentinel,
    Object? couponError = _sentinel,
    CheckoutStatus? status,
    Object? orderId = _sentinel,
    Object? checkoutError = _sentinel,
    List<CartState>? history,
  }) {
    return CartState(
      lines: lines ?? this.lines,
      coupon: coupon == _sentinel ? this.coupon : coupon as String?,
      couponError:
          couponError == _sentinel ? this.couponError : couponError as String?,
      status: status ?? this.status,
      orderId: orderId == _sentinel ? this.orderId : orderId as String?,
      checkoutError: checkoutError == _sentinel
          ? this.checkoutError
          : checkoutError as String?,
      history: history ?? this.history,
    );
  }

  @override
  List<Object?> get props =>
      [lines, coupon, couponError, status, orderId, checkoutError, history];
}

const _sentinel = Object();
