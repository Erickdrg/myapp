import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 13, 32, 72),
        ),
        useMaterial3: true,
      ),
      home: const Calculadora(),
    );
  }
}

class Calculadora extends StatefulWidget {
  const Calculadora({super.key});

  @override
  State<Calculadora> createState() => _CalculadoraState();
}

class _CalculadoraState extends State<Calculadora> {
  String display = '';

  void onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        display = '';
      } else if (value == '=') {
        try {
          const evaluator = ExpressionEvaluator();
          String formula = display.replaceAll('x', '*');
          final expression = Expression.parse(formula);
          final result = evaluator.eval(expression, {});

          display = result.toString().endsWith('.0')
              ? result.toInt().toString()
              : result.toString();
        } catch (e) {
          display = 'Error';
        }
      } else {
        if (display == 'Error') display = '';
        display += value;
      }
    });
  }

  // Widget para botones normales
  Widget botonNormal(String text) {
    return ElevatedButton(
      onPressed: () => onButtonPressed(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 187, 209, 220),
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        padding: EdgeInsets.zero,
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Widget para el botón de igual grande
  Widget botonIgual({required bool esHorizontal}) {
    return SizedBox(
      width: esHorizontal ? 120 : double.infinity,
      height: esHorizontal ? double.infinity : 80,
      child: ElevatedButton(
        onPressed: () => onButtonPressed('='),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Text(
          "=",
          style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final botones = [
      "(",
      ")",
      "C",
      "/",
      "7",
      "8",
      "9",
      "x",
      "4",
      "5",
      "6",
      "-",
      "1",
      "2",
      "3",
      "+",
      "0",
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Calculadora Erick"), centerTitle: true),
      body: OrientationBuilder(
        builder: (context, orientation) {
          bool esH = orientation == Orientation.landscape;

          return Column(
            children: [
              // Pantalla
              Expanded(
                flex: esH ? 2 : 3,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.bottomRight,
                  child: Text(
                    display.isEmpty ? '0' : display,
                    style: TextStyle(
                      fontSize: esH ? 45 : 60,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // Botonera adaptable
              Expanded(
                flex: 7,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: esH
                      ? Row(
                          // Layout Horizontal
                          children: [
                            Expanded(
                              child: GridView.count(
                                crossAxisCount: 6,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                children: botones
                                    .map((b) => botonNormal(b))
                                    .toList(),
                              ),
                            ),
                            const SizedBox(width: 10),
                            botonIgual(esHorizontal: true),
                          ],
                        )
                      : Column(
                          // Layout Vertical
                          children: [
                            Expanded(
                              child: GridView.count(
                                crossAxisCount: 4,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                children: botones
                                    .map((b) => botonNormal(b))
                                    .toList(),
                              ),
                            ),
                            const SizedBox(height: 10),
                            botonIgual(esHorizontal: false),
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
