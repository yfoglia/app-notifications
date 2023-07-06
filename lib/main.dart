import 'package:flutter/material.dart';

//importaciones de firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_notifications/services/firebase_service.dart';
import 'package:flutter_notifications/services/notifications_services.dart';
//import 'package:flutter_notifications/api/firebase_api.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.android,
  );

  await initNotifications();


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: FutureBuilder(future: getProduct(), builder: ((context, snapshot){
        if( snapshot.hasData){
          return ListView.builder(
            itemCount: snapshot.data?.length,
            itemBuilder: (context, index) {
              return Text(snapshot.data?[index]['name']);
            },
          );
        }
        else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      }))
      
      
      // Center(
      //   child: ElevatedButton(
      //     onPressed: (){
      //       print("notification");
      //       mostrarNotificacion();
      //     },
      //     child: const Text("Mostrar Notificacion"),
      //     )
      // )
    );
  }
}
