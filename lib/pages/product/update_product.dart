import 'package:flutter/material.dart';
import 'package:flutter_notifications/services/firebase_service.dart';

import '../../models/product_model.dart';

class UpdateProductPage extends StatefulWidget {
  const UpdateProductPage({super.key});

  @override
  State<UpdateProductPage> createState() => _UpdateProductPageState();
}

class _UpdateProductPageState extends State<UpdateProductPage> {
  TextEditingController nameController = TextEditingController(text: "");
  TextEditingController codeController = TextEditingController(text: "");
  String firebaseId = '';
  bool isUpdating = false;

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;

    nameController.text = arguments['data-firebase']['name'];
    codeController.text = arguments['data-firebase']['code'];
    firebaseId = arguments['data-firebase']['firebaseId'];

    return Scaffold(
        appBar: AppBar(
          title: const Text('Update Product'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: 'Igresar nombre',
                ),
              ),
              TextField(
                controller: codeController,
                decoration: const InputDecoration(
                  hintText: 'Ingresar código',
                ),
              ),
              const SizedBox(
                  height: 20.0), // Espacio vertical para separar los widgets

              // Mostrar el ElevatedButton o el CircularProgressIndicator según el estado
              isUpdating
                  ? const CircularProgressIndicator() // Spinner mientras se actualiza el producto
                  : ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          isUpdating =
                              true; // Establecer isUpdating en true antes de comenzar la actualización
                        });
                        await updateProductEvent(firebaseId,
                            nameController.text, codeController.text, context);
                        setState(() {
                          isUpdating =
                              false; // Establecer isUpdating en false una vez completada la actualización
                        });
                      },
                      child: const Text('Actualizar'),
                    ),
            ],
          ),
        ));
  }
}

Future<void> updateProductEvent(
    String firebaseId, String name, String code, BuildContext context) async {
  Product newProduct = Product(
    name: name,
    code: code,
    expirationDate: DateTime.now(),
  );

  await updateProduct(firebaseId, newProduct).then((_) {
    Navigator.pop(context);
  });
}
