import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = 
  FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('notification_icon');

  const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings();

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

}

Future<void> showNotification(String message) async {
  const AndroidNotificationDetails androidNotificationDetails = 
    AndroidNotificationDetails('channelId', 'channelName');
  
  const NotificationDetails notificationDetails = NotificationDetails(
    android:  androidNotificationDetails,
  );

  await flutterLocalNotificationsPlugin.show(1, 'Expiracion de Producto', message, notificationDetails);
  
}