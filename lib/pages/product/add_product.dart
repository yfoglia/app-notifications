import 'package:flutter/material.dart';
import 'package:flutter_notifications/services/firebase_service.dart';

import '../../models/product_model.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  TextEditingController nameController = TextEditingController(text: "");
  TextEditingController codeController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Product'),
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
              ElevatedButton(
                  onPressed: () async {
                    String name = nameController.text;
                    String code = codeController.text;
                    DateTime expirationDate = DateTime
                        .now(); // Asigna aquí la fecha de expiración correcta

                    Product newProduct = Product(
                      name: name,
                      code: code,
                      expirationDate: expirationDate,
                    );
					
                    await addProduct(newProduct).then((_) {
                      Navigator.pop(context);
                    });
                  },
                  child: const Text('Guardar'))
            ],
          ),
        ));
  }
}
