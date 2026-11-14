import 'package:cart_four_ways/models/cart.dart';
import 'package:cart_four_ways/setstate/cart_page_setstate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('add two Keyboards and apply SAVE10 — total shows 88.20',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: SetStateCartPage()),
    );

    // Add Keyboard twice via catalog chips.
    await tester.tap(find.widgetWithText(ActionChip, 'Keyboard \$49'));
    await tester.pump();
    await tester.tap(find.widgetWithText(ActionChip, 'Keyboard \$49'));
    await tester.pump();

    // Enter coupon and apply.
    await tester.enterText(find.byType(TextField), 'SAVE10');
    await tester.tap(find.widgetWithText(FilledButton, 'Apply'));
    await tester.pump();

    // 2 × 49 = 98; 10% off = 9.80; total = 88.20
    expect(find.text('\$88.20'), findsOneWidget);
  });

  testWidgets('undo removes last cart change', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: SetStateCartPage()),
    );

    // Add Mouse.
    await tester.tap(find.widgetWithText(ActionChip, 'Mouse \$25'));
    await tester.pump();

    expect(find.text('Mouse'), findsOneWidget);

    // Undo — cart should be empty again.
    await tester.tap(find.byTooltip('Undo'));
    await tester.pump();

    expect(find.text('Mouse'), findsNothing);
    expect(find.text('Your cart is empty'), findsOneWidget);
  });
}
