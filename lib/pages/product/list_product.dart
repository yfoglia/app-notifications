import 'package:flutter/material.dart';
import 'package:flutter_notifications/pages/product/update_product.dart';
import 'package:intl/intl.dart';
import '../../colors/color_extensions.dart';
import '../../models/product_model.dart';
import '../../services/firebase_service.dart';
import 'delete_product.dart';

class ListProductPage extends StatefulWidget {
  const ListProductPage({Key? key}) : super(key: key);

  @override
  State<ListProductPage> createState() => _ListProductPageState();
}

class _ListProductPageState extends State<ListProductPage> {
  bool _isModalDeleteVisible = false;
  bool _isModalUpdateVisible = false;
  int _selectedProductIndex = -1;
  List<Map<String, dynamic>> _productData = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        color: ColorExtensions.dark,
        child: Stack(
          children: [
            _buildContent(),
            _buildModalDelete(),
            _buildModalUpdate(),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return FutureBuilder(
      future: getProduct(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _productData = List<Map<String, dynamic>>.from(snapshot.data ?? []);
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.builder(
              itemCount: _productData.length,
              itemBuilder: (context, index) {
                String name = _productData[index]['name'];
                String code = _productData[index]['code'];
                DateTime expirationDate =
                    DateTime.parse(_productData[index]['expirationDate']);

                String formattedDate =
                    DateFormat('dd/MM/yyyy').format(expirationDate);

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () async {
                      setState(() {
                        _selectedProductIndex = index;
                        _isModalUpdateVisible = true;
                      });
                    },
                    child: Card(
                      color: ColorExtensions.input,
                      child: ListTile(
                        title: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Código: $code',
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'Fecha de vencimiento: $formattedDate',
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_forever_rounded),
                          color: ColorExtensions.orangeMenu,
                          onPressed: () {
                            setState(() {
                              _selectedProductIndex = index;
                              _isModalDeleteVisible = true;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(ColorExtensions.orangeMenu)),
          );
        }
      },
    );
  }

  Widget _buildModalDelete() {
    if (_isModalDeleteVisible) {
      return ModalDeleteWidget(
        onCancel: () {
          setState(() {
            _isModalDeleteVisible = false;
          });
        },
        onConfirm: () {
          setState(() {
            _isModalDeleteVisible = false;
          });
          deleteProduct(
            _productData[_selectedProductIndex]['firebaseId'],
          );
        },
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildModalUpdate() {
    if (_isModalUpdateVisible) {
      String firebaseId = _productData[_selectedProductIndex]['firebaseId'];
      String initialName = _productData[_selectedProductIndex]['name'];
      String initialCode = _productData[_selectedProductIndex]['code'];
      DateTime initialDate =
          DateTime.parse(_productData[_selectedProductIndex]['expirationDate']);

      return WillPopScope(
        onWillPop: () async {
          setState(() {
            _isModalUpdateVisible = false;
          });
          return true;
        },
        child: ModalUpdateWidget(
          firebaseId: firebaseId,
          initialName: initialName,
          initialCode: initialCode,
          initialDate: initialDate,
          onUpdate: (String firebaseId, String name, String code,
              DateTime selectedDate, BuildContext context) async {
            Product newProduct = Product(
              name: name,
              code: code,
              expirationDate: selectedDate,
            );

            await updateProduct(firebaseId, newProduct).then((_) {});
          },
          onClose: () {
            setState(() {
              _isModalUpdateVisible = false;
            });
          },
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
