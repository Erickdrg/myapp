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
      title: 'Formulario Flutter',
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidoController = TextEditingController();
  final TextEditingController edadController = TextEditingController();

  String nombreCompleto = '';
  bool mostrarImagen = false;

  void enviarFormulario() {
    setState(() {
      nombreCompleto = '${nombreController.text} ${apellidoController.text}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Formulario con resultados')),
      body: Column(
        children: [
          // Primera parte: Formulario
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: nombreController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: apellidoController,
                  decoration: const InputDecoration(labelText: 'Apellido'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: edadController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Edad'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: enviarFormulario,
                  child: const Text('Enviar'),
                ),
              ],
            ),
          ),

          const Divider(),

          // Área interactiva y resultado
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                //arreglo de hijos
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        mostrarImagen = true;
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      color: Colors.grey.shade300,
                      child: const Text(
                        'Haz clic aquí para mostrar la imagen',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  if (mostrarImagen)
                    Image.network(
                      'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
                      height: 120,
                    ),
                  const SizedBox(height: 20),
                  Text(
                    'Nombre completo:',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    nombreCompleto,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
