import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<String?> initPush() async {
  await Firebase.initializeApp();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  var notificationSettings =
      await messaging.requestPermission(alert: true, sound: true);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  var t = await messaging.getToken();
  FirebaseMessaging.onMessage.listen(_onForegroundMessage);
  return t;
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  playSound: true,
  importance: Importance.high,
);

_onForegroundMessage(RemoteMessage message) {
  var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null) {
    flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            color: Colors.blue,
            icon: "@mipmap/ic_launcher",
          ),
        ));
  }
}
