import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Calculadora de Samarretes')),
        body: const TShirtCalculatorScreen(),
      ),
    );
  }
}

class TShirtCalculatorLogic {
  static const double small = 10.0;
  static const double medium = 12.0;
  static const double large = 15.0;

  static double calculatePrice(String size, int numTShirts) {
    double pricePerShirt;
    switch (size) {
      case 'small':
        pricePerShirt = small;
        break;
      case 'medium':
        pricePerShirt = medium;
        break;
      case 'large':
        pricePerShirt = large;
        break;
      default:
        throw ArgumentError('Talla no vàlida');
    }
    return numTShirts * pricePerShirt;
  }

  static double calculateDiscount(double price, String offer) {
    if (offer == '10%') {
      return price * 0.10; // 10% discount
    } else if (offer == '20€' && price > 100) {
      return 20.0; // 20€ discount
    }
    return 0.0; // No discount
  }

  static double calculatePriceWithDiscount(String size, int numTShirts, String offer) {
    double price = calculatePrice(size, numTShirts);
    double discount = calculateDiscount(price, offer);
    return price - discount;
  }
}

class TShirtCalculatorScreen extends StatefulWidget {
  const TShirtCalculatorScreen({super.key});

  @override
  _TShirtCalculatorScreenState createState() => _TShirtCalculatorScreenState();
}

class _TShirtCalculatorScreenState extends State<TShirtCalculatorScreen> {
  static const double smallPrice = TShirtCalculatorLogic.small;
  static const double mediumPrice = TShirtCalculatorLogic.medium;
  static const double largePrice = TShirtCalculatorLogic.large;

  int? _numTShirts;
  String? _size;
  String _offer = 'Sense descompte'; // Cambiado a String
  double _price = 0.0;
  double _originalPrice = 0.0; // Precio original sin descuento
  double _discount = 0.0;
  String _discountWarning = '';

  void _calculatePrice() {
    if (_numTShirts == null || _size == null || _numTShirts! <= 0) {
      setState(() {
        _price = 0.0;
        _originalPrice = 0.0;
        _discount = 0.0;
        _discountWarning = '';
      });
      return;
    }

    double originalPrice = TShirtCalculatorLogic.calculatePrice(_size!, _numTShirts!);
    double discount = TShirtCalculatorLogic.calculateDiscount(originalPrice, _offer);

    setState(() {
      // Verificación de la cantidad mínima para aplicar el descuento de 20€
      if (_offer == '20€' && originalPrice <= 100) {
        _discountWarning = 'El descompte de 20€ només s\'aplica a comandes superiors a 100€';
        discount = 0.0;  // No aplicamos el descuento de 20€ si no es válido
      } else {
        _discountWarning = '';
      }

      _originalPrice = originalPrice; // Guardar el precio original
      _price = originalPrice - discount;
      _discount = discount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 20),
          MyTextInput(
            labelText: 'Samarretes',
            hintText: 'Número de samarretes',
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                _numTShirts = int.tryParse(value);
                _calculatePrice();
              });
            },
          ),
          const Text('Talla'),
          RadioListTile(
            title: Text('Petita ($smallPrice €)'),
            value: 'small',
            groupValue: _size,
            onChanged: (value) {
              setState(() {
                _size = value;
                _calculatePrice();
              });
            },
          ),
          RadioListTile(
            title: Text('Mitjana ($mediumPrice €)'),
            value: 'medium',
            groupValue: _size,
            onChanged: (value) {
              setState(() {
                _size = value;
                _calculatePrice();
              });
            },
          ),
          RadioListTile(
            title: Text('Gran ($largePrice €)'),
            value: 'large',
            groupValue: _size,
            onChanged: (value) {
              setState(() {
                _size = value;
                _calculatePrice();
              });
            },
          ),
          const SizedBox(height: 20),
          const Text('Oferta'),
          DropdownButton<String>(
            value: _offer,
            items: const [
              DropdownMenuItem(
                value: 'Sense descompte',
                child: Text('Sense descompte'),
              ),
              DropdownMenuItem(
                value: '10%',
                child: Text('Descompte del 10%'),
              ),
              DropdownMenuItem(
                value: '20€',
                child: Text('Descompte per quantitat'),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _offer = value!;
                _calculatePrice();
              });
            },
            hint: const Text('Selecciona una oferta'),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Text(
                'Preu original: $_originalPrice €',
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(width: 20),
              Text(
                'Preu amb descompte: $_price €',
                style: const TextStyle(fontSize: 32),
              ),
            ],
          ),
          if (_discountWarning.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                _discountWarning,
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
        ],
      ),
    );
  }
}

class MyTextInput extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextInputType keyboardType;
  final Function(String) onChanged;

  const MyTextInput({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.keyboardType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(),
      ),
      keyboardType: keyboardType,
      onChanged: onChanged,
    );
  }
}
