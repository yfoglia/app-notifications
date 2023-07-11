import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notifications/colors/color_extensions.dart';
import 'package:flutter_notifications/pages/product/add_product.dart';
import 'package:flutter_notifications/pages/product/list_product.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  late int _page = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorExtensions.dark,
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: ColorExtensions.dark,
        color: ColorExtensions.orangeMenu,
		animationDuration: Duration(milliseconds: 400),
        items: [
          Icon(Icons.wallet, size: 30, color: ColorExtensions.dark),
          Icon(Icons.add, size: 30, color: ColorExtensions.dark),
          Icon(Icons.settings, size: 30, color: ColorExtensions.dark),
        ],
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
      ),
      body: IndexedStack(
        index: _page,
        children: [
          const Center(
            child: ListProductPage(),
          ),
          const Center(
            child: AddProductPage(),
          ),
          Container(
            color: ColorExtensions.dark,
            child: const Center(
              child: Text('Vista 3'),
            ),
          ),
        ],
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