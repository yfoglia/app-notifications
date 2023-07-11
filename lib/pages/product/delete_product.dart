import 'package:flutter/material.dart';
import '../../colors/color_extensions.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ModalDeleteWidget extends StatefulWidget {
  final Function onCancel;
  final Function onConfirm;

  const ModalDeleteWidget({super.key, 
    required this.onCancel,
    required this.onConfirm,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ModalDeleteWidgetState createState() => _ModalDeleteWidgetState();
}

class _ModalDeleteWidgetState extends State<ModalDeleteWidget> {
  bool _isDeleting = false;

  void _deleteProduct() async {
    setState(() {
      _isDeleting = true;
    });
    await widget.onConfirm();
    setState(() {
      _isDeleting = false;
    });
    Fluttertoast.showToast(
      msg: '¡Elemento eliminado correctamente!',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey[700],
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onCancel as void Function()?,
      child: Card(
        color: ColorExtensions.input,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: ColorExtensions.dark,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Confirmar borrado',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ColorExtensions.orangeMenu,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      '¿Estás seguro de que deseas borrar este elemento?',
                      style: TextStyle(
                        fontSize: 16,
                        color: ColorExtensions.orangeMenu,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ElevatedButton(
                              onPressed: widget.onCancel as void Function()?,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorExtensions.input,
                              ),
                              child: const Text('Cancelar'),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: ElevatedButton(
                              onPressed: _isDeleting ? null : _deleteProduct,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorExtensions.orangeMenu,
                              ),
                              child: _isDeleting
                                  ? CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          ColorExtensions.orangeMenu),
                                    )
                                  : const Text('Borrar'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
