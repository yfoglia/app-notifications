import 'package:flutter/material.dart';

//importaciones de firebase
import 'package:firebase_core/firebase_core.dart';
import 'services/firebase_options.dart';

import 'package:flutter_notifications/pages/home/home_page.dart';
import 'package:flutter_notifications/services/notifications_services.dart';


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
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const Home()
      },
    );
  }
}