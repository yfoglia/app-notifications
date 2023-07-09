import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../colors/color_extensions.dart';
import '../../services/firebase_service.dart';

class ListProductPage extends StatefulWidget {
  const ListProductPage({Key? key}) : super(key: key);

  @override
  State<ListProductPage> createState() => _ListProductPageState();
}

class _ListProductPageState extends State<ListProductPage> {
  bool _isModalVisible = false;
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
            _buildModal(),
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
                      // await Navigator.pushNamed(context, '/update-product',
                      //     arguments: {"data-firebase": _productData[index]});
                      // setState(() {});
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
                              _isModalVisible = true;
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
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _buildModal() {
    if (_isModalVisible) {
      return GestureDetector(
        onTap: () {
          setState(() {
            _isModalVisible = false;
          });
        },
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
                                onPressed: () {
                                  setState(() {
                                    _isModalVisible = false;
                                  });
                                },
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
                                onPressed: () {
                                  setState(() {
                                    _isModalVisible = false;
                                  });
                                  deleteProduct(
                                    _productData[_selectedProductIndex]
                                        ['firebaseId'],
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorExtensions.orangeMenu,
                                ),
                                child: const Text('Borrar'),
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
    } else {
      return const SizedBox.shrink();
    }
  }
}


// Center(
      //   child: ElevatedButton(
      //     onPressed: (){
      //       print("notification");
      //       mostrarNotificacion();
      //     },
      //     child: const Text("Mostrar Notificacion"),
      //     )
      // )