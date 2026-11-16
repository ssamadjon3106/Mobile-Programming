import 'package:flutter_test/flutter_test.dart';
import 'package:tm_classifier/services/classifier.dart';

void main() {
  group('parseLabels', () {
    test('normal case with Unix line endings', () {
      const input = '0 Mug\n1 Bottle\n';
      final result = parseLabels(input);
      expect(result, ['Mug', 'Bottle']);
    });

    test('awkward case with Windows line endings, trailing blank line and spaces', () {
      const input = '0 Mug\r\n1 Bottle\r\n2 Car keys\r\n\r\n';
      final result = parseLabels(input);
      expect(result, ['Mug', 'Bottle', 'Car keys']);
    });
  });
}
