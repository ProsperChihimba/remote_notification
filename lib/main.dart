import 'dart:async';

import 'package:flutter/material.dart';
import 'package:remote_notification/home.dart';
import 'package:remote_notification/services/notification_contoller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationController.initializeRemoteNotifications(debug: true);
  await NotificationController.initializeLocalNotifications(debug: true);
  await NotificationController.initializeNotificationsEventListeners();
  scheduleMicrotask(() async {
    await NotificationController.getInitialNotificationAction();
  });
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
      home: const HomePage(),
    );
  }
}
