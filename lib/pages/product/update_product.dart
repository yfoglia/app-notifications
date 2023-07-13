import 'package:flutter/material.dart';
import 'package:flutter_notifications/colors/color_extensions.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class ModalUpdateWidget extends StatefulWidget {
  final String firebaseId;
  final String initialName;
  final String initialCode;
  final DateTime initialDate;
  final Function onUpdate;
  final Function onClose;

  const ModalUpdateWidget({
    Key? key,
    required this.firebaseId,
    required this.initialName,
    required this.initialCode,
    required this.initialDate,
    required this.onUpdate,
    required this.onClose,
  }) : super(key: key);

  @override
  _ModalUpdateWidgetState createState() => _ModalUpdateWidgetState();
}

class _ModalUpdateWidgetState extends State<ModalUpdateWidget> {
  TextEditingController nameController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  DateTime? selectedDate;
  bool _isUpdating = false;
  DateTime firstDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.initialName;
    codeController.text = widget.initialCode;
    dateController.text =
        DateFormat('dd/MM/yyyy').format(widget.initialDate);
    selectedDate = widget.initialDate;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().isBefore(firstDate)
          ? firstDate
          : DateTime.now(),
      firstDate: firstDate,
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.light().copyWith(
              primary: ColorExtensions.orangeMenu,
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        dateController.text = DateFormat('dd/MM/yyyy').format(selectedDate!);
      });
    }
  }

  void _updateProductEvent(BuildContext context) async {
    setState(() {
      _isUpdating = true;
    });

    try {
      await widget.onUpdate(
        widget.firebaseId,
        nameController.text,
        codeController.text,
        selectedDate!,
        context,
      );

      Fluttertoast.showToast(
        msg: '¡Elemento actualizado correctamente!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey[700],
        textColor: Colors.white,
      );

      widget.onClose();
    } catch (error) {
      Fluttertoast.showToast(
        msg: 'Error al actualizar el elemento',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      setState(() {
        _isUpdating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ColorExtensions.dark,
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.95,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                      style: TextStyle(color: ColorExtensions.inputText),
                      decoration: InputDecoration(
                        hintText: 'Fecha seleccionada',
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        suffixIcon: Icon(
                          Icons.calendar_today,
                          color: ColorExtensions.orangeMenu,
                        ),
                      ),
                      textAlignVertical: TextAlignVertical.center,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isUpdating
                          ? null
                          : () {
                              widget.onClose();
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorExtensions.input,
                      ),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isUpdating
                          ? null
                          : () {
                              _updateProductEvent(context);
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isUpdating
                            ? Colors.black
                            : ColorExtensions.orangeMenu,
                      ),
                      child: const Text('Actualizar'),
                    ),
                  ),
                ],
              ),
              if (_isUpdating)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: LinearProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        ColorExtensions.orangeMenu),
                    backgroundColor: Colors.grey[300],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
