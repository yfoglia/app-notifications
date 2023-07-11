import 'package:flutter/material.dart';
import 'package:flutter_notifications/colors/color_extensions.dart';
import 'package:flutter_notifications/pages/home/home_page.dart';
import 'package:flutter_notifications/services/firebase_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart'; // Importar el paquete intl para formatear la fecha

import '../../models/product_model.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({Key? key}) : super(key: key);

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  TextEditingController nameController = TextEditingController(text: "");
  TextEditingController codeController = TextEditingController(text: "");
  TextEditingController dateController = TextEditingController();
  DateTime? selectedDate;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    dateController.text = '';
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.light().copyWith(
              primary: ColorExtensions
                  .orangeMenu, // Cambia el color del selector de fecha
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        dateController.text = DateFormat('dd/MM/yyyy')
            .format(selectedDate!); // Formatear la fecha como "DD/MM/AAAA"
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: ColorExtensions.dark,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 10.0),
                decoration: BoxDecoration(
                  color: ColorExtensions.input,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextField(
                  controller: nameController,
                  style: TextStyle(color: ColorExtensions.inputText),
                  decoration: const InputDecoration(
                    hintText: 'Ingresar nombre',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(10.0),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10.0),
                decoration: BoxDecoration(
                  color: ColorExtensions.input,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextField(
                  controller: codeController,
                  style: TextStyle(color: ColorExtensions.inputText),
                  decoration: const InputDecoration(
                    hintText: 'Ingresar código',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(10.0),
                  ),
                ),
              ),
              InkWell(
                onTap: () => _selectDate(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorExtensions.input,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: IgnorePointer(
                    child: TextField(
                      controller: dateController,
                      style: TextStyle(
                          color: ColorExtensions
                              .inputText), // Cambia el color del texto en el campo de entrada
                      decoration: InputDecoration(
                        hintText: 'Fecha seleccionada',
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        suffixIcon: Icon(
                          Icons.calendar_today,
                          color: ColorExtensions
                              .orangeMenu, // Cambia el color del icono del calendario
                        ),
                      ),
                      textAlignVertical: TextAlignVertical.center,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              IgnorePointer(
                ignoring: isLoading,
                child: ElevatedButton(
                  onPressed: () async {
                    await addProductEvent(nameController.text, codeController.text, selectedDate, context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: isLoading ? Colors.grey : ColorExtensions.orangeMenu,
                    textStyle: TextStyle(color: isLoading ? Colors.black54 : ColorExtensions.dark),
                  ),
                  child: Text('Agregar'),
                ),
              ),
              if (isLoading)
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(ColorExtensions.orangeMenu),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addProductEvent(String name, String code, DateTime? selectedDate, BuildContext context) async {
    if (selectedDate == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Fecha no seleccionada'),
            content: const Text('Por favor, seleccione una fecha antes de guardar.'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cerrar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    Product newProduct = Product(
      name: name,
      code: code,
      expirationDate: selectedDate,
    );

    await addProduct(newProduct).then((_) {
      // Producto agregado exitosamente
      Fluttertoast.showToast(
        msg: 'Producto agregado',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
      );

      setState(() {
        isLoading = false;
      });

      // Redirigir al usuario al Home
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Home()),
        (Route<dynamic> route) => false,
      );
    });
  }
}
