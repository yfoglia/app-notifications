import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/firebase_service.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> productData = snapshot.data?[index];

                  String name = productData['name'];
                  String code = productData['code'];
                  DateTime expirationDate =
                      DateTime.parse(productData['expirationDate']);

                  String formattedDate =
                      DateFormat('dd/MM/yyyy').format(expirationDate);

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () async {
                        await Navigator.pushNamed(context, '/update-product',
                            arguments: {
                              "data-firebase": snapshot.data?[index]
                            });
                        // Para actualizar el widget
                        setState(() {});
                      },
                      child: Card(
                        color: const Color.fromARGB(17, 12, 12, 12),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/add-product');
          // Para actualizar el widget
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
    );
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