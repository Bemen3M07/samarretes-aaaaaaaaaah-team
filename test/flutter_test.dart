import 'package:empty/main.dart'; // Asegúrate de que la ruta sea correcta
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TShirtCalculatorLogic', () {
    test('calculatePrice without discount', () {
      expect(TShirtCalculatorLogic.calculatePrice('small', 15), 150.0); // 15 * 10
      expect(TShirtCalculatorLogic.calculatePrice('medium', 15), 180.0); // 15 * 12
      expect(TShirtCalculatorLogic.calculatePrice('large', 15), 225.0); // 15 * 15
    });

    test('calculatePrice with discount', () {
      // No discount
      expect(TShirtCalculatorLogic.calculatePriceWithDiscount('small', 15, 'Sense descompte'), 150.0);
      // 10% discount
      expect(TShirtCalculatorLogic.calculatePriceWithDiscount('small', 15, '10%'), 135.0); // 150 - 15
      // 20€ discount, total > 100€
      expect(TShirtCalculatorLogic.calculatePriceWithDiscount('large', 15, '20€'), 205.0); // 225 - 20
      // 20€ discount, total < 100€
      expect(TShirtCalculatorLogic.calculatePriceWithDiscount('small', 5, '20€'), 50.0); // 5 * 10 - 0
    });
  });
}