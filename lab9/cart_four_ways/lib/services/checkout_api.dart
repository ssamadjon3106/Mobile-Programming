class CheckoutException implements Exception {
  const CheckoutException(this.message);
  final String message;
  @override
  String toString() => 'CheckoutException: $message';
}

class CheckoutApi {
  Future<String> submit(double total) async {
    await Future<void>.delayed(const Duration(milliseconds: 1500));
    if (total > 500) throw const CheckoutException('Card declined: total exceeds limit');
    return 'ORD-${DateTime.now().millisecondsSinceEpoch % 10000}';
  }
}
