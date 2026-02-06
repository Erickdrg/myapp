import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart'; // La librería para que la mate funcione bien

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculadora de Erick',
      theme: ThemeData(
        // El color azul que ya teníamos desde el inicio
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 13, 32, 72)),
        useMaterial3: true,
      ),
      home: const Calculadora(),
    );
  }
}

// 
class Calculadora extends StatefulWidget {
  const Calculadora({super.key});

  @override
  State<Calculadora> createState() => _CalculadoraState();
}

class _CalculadoraState extends State<Calculadora> {
  String display = '';

  // Función para cuando picamos los botones
  void onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        display = ''; // Limpiar pantalla
      } else if (value == '=') {
        if (display.isEmpty) return;
        try {
          const evaluator = ExpressionEvaluator();
          String formula = display.replaceAll('x', '*');
          final expression = Expression.parse(formula);
          final result = evaluator.eval(expression, {});

          // Validación de errores: división por cero 
          if (result is num && (result.isInfinite || result.isNaN)) {
            display = 'Error: Div/0';
          } else {
            // Quitamos el .0 si es entero
            display = result.toString().endsWith('.0') 
                ? result.toInt().toString() 
                : result.toString();
          }
        } catch (e) {
          display = 'Error'; // Si la operación está mal escrita
        }
      } else {
        // Si hay un error y picamos algo nuevo, borramos el mensaje de error
        if (display == 'Error' || display == 'Error: Div/0') display = '';
        display += value;
      }
    });
  }

  // Molde para botones que se ajustan si el cel está acostado
  Widget buildButton(String text, {Color? color, int flex = 1, required bool esH}) {
    return Expanded(
      flex: flex,
      child: Container(
        // En horizontal (esH) los hacemos más bajitos para que quepan en la pantalla
        height: esH ? 42 : 75, 
        padding: const EdgeInsets.all(2),
        child: ElevatedButton(
          onPressed: () => onButtonPressed(text),
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? const Color.fromARGB(255, 187, 209, 220),
            foregroundColor: color != null ? Colors.white : Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: EdgeInsets.zero,
            elevation: 3,
          ),
          child: Text(text, style: TextStyle(fontSize: esH ? 18 : 24, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Calculadora Erick"),
        // AppBar más chiquito en horizontal para ganar espacio
        toolbarHeight: MediaQuery.of(context).orientation == Orientation.landscape ? 35 : 56,
      ),
      body: OrientationBuilder( // Detección de orientación
        builder: (context, orientation) {
          bool esH = orientation == Orientation.landscape;

          return Column(
            children: [
              // Pantalla de resultados (se achica en horizontal para que quepa todo)
              Expanded(
                flex: esH ? 1 : 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  alignment: Alignment.bottomRight,
                  child: SingleChildScrollView(
                    reverse: true,
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      display.isEmpty ? '0' : display,
                      style: TextStyle(fontSize: esH ? 30 : 50, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),

              // Botonera organizada para que no se mueva nada al girar
              Expanded(
                flex: esH ? 6 : 7,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      Row(children: [
                        buildButton("(", esH: esH),
                        buildButton(")", esH: esH),
                        buildButton("C", esH: esH),
                        buildButton("/", color: Colors.blueGrey, esH: esH),
                      ]),
                      Row(children: [
                        buildButton("7", esH: esH),
                        buildButton("8", esH: esH),
                        buildButton("9", esH: esH),
                        buildButton("x", color: Colors.blueGrey, esH: esH),
                      ]),
                      Row(children: [
                        buildButton("4", esH: esH),
                        buildButton("5", esH: esH),
                        buildButton("6", esH: esH),
                        buildButton("-", color: Colors.blueGrey, esH: esH),
                      ]),
                      Row(children: [
                        buildButton("1", esH: esH),
                        buildButton("2", esH: esH),
                        buildButton("3", esH: esH),
                        buildButton("+", color: Colors.blueGrey, esH: esH),
                      ]),
                      Row(children: [
                        buildButton("0", esH: esH),
                        // Criterio: Botón con "span" (ocupa el espacio de 3 botones)
                        buildButton("=", color: Colors.orange, flex: 3, esH: esH),
                      ]),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
