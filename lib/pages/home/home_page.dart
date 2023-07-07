import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/firebase_service.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isModalVisible = false;
  int _selectedProductIndex = -1;
  List<Map<String, dynamic>> _productData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Title app notifications'),
      ),
      body: FutureBuilder(
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
                        await Navigator.pushNamed(context, '/update-product',
                            arguments: {
                              "data-firebase": _productData[index]
                            });
                        setState(() {});
                      },
                      child: Card(
                        color: Theme.of(context).cardColor,
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
                            color: const Color.fromARGB(255, 210, 96, 96),
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
      ),
      floatingActionButton: !_isModalVisible
          ? FloatingActionButton(
              onPressed: () async {
                await Navigator.pushNamed(context, '/add-product');
                setState(() {});
              },
              child: const Icon(Icons.add),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomSheet: _buildModal(),
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
        child: Container(
          color: Colors.black54,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Confirmar borrado',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        '¿Estás seguro de que deseas borrar este elemento?',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isModalVisible = false;
                            });
                            deleteProduct(_productData[_selectedProductIndex]['firebaseId']);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text('Borrar'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isModalVisible = false;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                          ),
                          child: const Text('Cancelar'),
                        ),
                      ],
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