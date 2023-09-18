import 'package:flutter/material.dart';
import 'package:remote_notification/home.dart';
import 'package:remote_notification/services/notification_contoller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationController.initializeRemoteNotifications(debug: true);
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
