import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp()); // Inicia la aplicación con el widget MyApp
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Desactiva el banner de debug
      home: Scaffold(
        appBar: AppBar(title: const Text('Calculadora de Samarretes')), // Título de la AppBar
        body: const TShirtCalculatorScreen(), // Cuerpo de la aplicación que muestra la pantalla de cálculo
      ),
    );
  }
}

// Clase que contiene la lógica de cálculo de precios de camisetas
class TShirtCalculatorLogic {
  static const double small = 10.0; // Precio de camiseta pequeña
  static const double medium = 12.0; // Precio de camiseta mediana
  static const double large = 15.0; // Precio de camiseta grande

  // Método para calcular el precio total según la talla y cantidad
  static double calculatePrice(String size, int numTShirts) {
    double pricePerShirt; // Variable para almacenar el precio por camiseta
    switch (size) {
      case 'small':
        pricePerShirt = small; // Asigna el precio de la talla pequeña
        break;
      case 'medium':
        pricePerShirt = medium; // Asigna el precio de la talla mediana
        break;
      case 'large':
        pricePerShirt = large; // Asigna el precio de la talla grande
        break;
      default:
        throw ArgumentError('Talla no vàlida'); // Lanza un error si la talla no es válida
    }
    return numTShirts * pricePerShirt; // Retorna el precio total
  }

  // Método para calcular el descuento según la oferta seleccionada
  static double calculateDiscount(double price, String offer) {
    if (offer == '10%') {
      return price * 0.10; // Descuento del 10%
    } else if (offer == '20€' && price > 100) {
      return 20.0; // Descuento de 20€ si el precio es mayor a 100€
    }
    return 0.0; // Sin descuento
  }

  // Método que calcula el precio final con descuento
  static double calculatePriceWithDiscount(String size, int numTShirts, String offer) {
    double price = calculatePrice(size, numTShirts); // Calcula el precio original
    double discount = calculateDiscount(price, offer); // Calcula el descuento
    return price - discount; // Retorna el precio final después del descuento
  }
}

// Pantalla principal de la calculadora de camisetas
class TShirtCalculatorScreen extends StatefulWidget {
  const TShirtCalculatorScreen({super.key});

  @override
  _TShirtCalculatorScreenState createState() => _TShirtCalculatorScreenState();
}

class _TShirtCalculatorScreenState extends State<TShirtCalculatorScreen> {
  // Precios de las camisetas
  static const double smallPrice = TShirtCalculatorLogic.small;
  static const double mediumPrice = TShirtCalculatorLogic.medium;
  static const double largePrice = TShirtCalculatorLogic.large;

  int? _numTShirts; // Número de camisetas
  String? _size; // Talla seleccionada
  String _offer = 'Sense descompte'; // Oferta seleccionada
  double _price = 0.0; // Precio final
  double _originalPrice = 0.0; // Precio original sin descuento
  double _discount = 0.0; // Monto del descuento
  String _discountWarning = ''; // Mensaje de advertencia sobre descuentos

  // Método para calcular el precio basado en la entrada del usuario
  void _calculatePrice() {
    // Verifica que los datos de entrada sean válidos
    if (_numTShirts == null || _size == null || _numTShirts! <= 0) {
      setState(() {
        _price = 0.0; // Reinicia el precio
        _originalPrice = 0.0; // Reinicia el precio original
        _discount = 0.0; // Reinicia el descuento
        _discountWarning = ''; // Reinicia la advertencia
      });
      return; // Sale del método si los datos no son válidos
    }

    // Calcula el precio original
    double originalPrice = TShirtCalculatorLogic.calculatePrice(_size!, _numTShirts!);
    double discount = TShirtCalculatorLogic.calculateDiscount(originalPrice, _offer);

    setState(() {
      // Verifica si se puede aplicar el descuento de 20€
      if (_offer == '20€' && originalPrice <= 100) {
        _discountWarning = 'El descompte de 20€ només s\'aplica a comandes superiors a 100€';
        discount = 0.0; // No aplica el descuento si no es válido
      } else {
        _discountWarning = ''; // Resetea la advertencia si es válido
      }

      _originalPrice = originalPrice; // Guarda el precio original
      _price = originalPrice - discount; // Calcula el precio final
      _discount = discount; // Guarda el monto del descuento
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0), // Espaciado alrededor del contenido
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 20), // Espacio vertical
          MyTextInput(
            labelText: 'Samarretes', // Etiqueta del campo
            hintText: 'Número de samarretes', // Texto de sugerencia
            keyboardType: TextInputType.number, // Tipo de teclado numérico
            onChanged: (value) {
              setState(() {
                _numTShirts = int.tryParse(value); // Intenta convertir el valor a entero
                _calculatePrice(); // Recalcula el precio
              });
            },
          ),
          const Text('Talla'), // Título para la selección de talla
          RadioListTile(
            title: Text('Petita ($smallPrice €)'), // Opción para talla pequeña
            value: 'small', // Valor asociado
            groupValue: _size, // Valor del grupo
            onChanged: (value) {
              setState(() {
                _size = value; // Actualiza la talla seleccionada
                _calculatePrice(); // Recalcula el precio
              });
            },
          ),
          RadioListTile(
            title: Text('Mitjana ($mediumPrice €)'), // Opción para talla mediana
            value: 'medium', // Valor asociado
            groupValue: _size, // Valor del grupo
            onChanged: (value) {
              setState(() {
                _size = value; // Actualiza la talla seleccionada
                _calculatePrice(); // Recalcula el precio
              });
            },
          ),
          RadioListTile(
            title: Text('Gran ($largePrice €)'), // Opción para talla grande
            value: 'large', // Valor asociado
            groupValue: _size, // Valor del grupo
            onChanged: (value) {
              setState(() {
                _size = value; // Actualiza la talla seleccionada
                _calculatePrice(); // Recalcula el precio
              });
            },
          ),
          const SizedBox(height: 20), // Espacio vertical
          const Text('Oferta'), // Título para la selección de oferta
          DropdownButton<String>(
            value: _offer, // Valor actual de la oferta
            items: const [
              DropdownMenuItem(
                value: 'Sense descompte', // Opción sin descuento
                child: Text('Sense descompte'),
              ),
              DropdownMenuItem(
                value: '10%', // Opción de descuento del 10%
                child: Text('Descompte del 10%'),
              ),
              DropdownMenuItem(
                value: '20€', // Opción de descuento de 20€
                child: Text('Descompte per quantitat'),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _offer = value!; // Actualiza la oferta seleccionada
                _calculatePrice(); // Recalcula el precio
              });
            },
            hint: const Text('Selecciona una oferta'), // Texto de sugerencia
          ),
          const SizedBox(height: 20), // Espacio vertical
          Row(
            children: [
              Text(
                'Preu original: $_originalPrice €', // Muestra el precio original
                style: const TextStyle(fontSize: 18, color: Colors.grey), // Estilo del texto
              ),
              const SizedBox(width: 20), // Espacio horizontal
              Text(
                'Preu amb descompte: $_price €', // Muestra el precio con descuento
                style: const TextStyle(fontSize: 32), // Estilo del texto
              ),
            ],
          ),
          // Muestra advertencia si existe
          if (_discountWarning.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0), // Espacio superior
              child: Text(
                _discountWarning, // Mensaje de advertencia
                style: TextStyle(color: Colors.red, fontSize: 16), // Estilo del texto
              ),
            ),
        ],
      ),
    );
  }
}

// Widget personalizado para entrada de texto
class MyTextInput extends StatelessWidget {
  final String labelText; // Texto de la etiqueta
  final String hintText; // Texto de sugerencia
  final TextInputType keyboardType; // Tipo de teclado
  final Function(String) onChanged; // Callback para cambios en el texto

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
        labelText: labelText, // Etiqueta del campo
        hintText: hintText, // Texto de sugerencia
        border: OutlineInputBorder(), // Borde del campo
      ),
      keyboardType: keyboardType, // Tipo de teclado
      onChanged: onChanged, // Callback para cambios
    );
  }
}