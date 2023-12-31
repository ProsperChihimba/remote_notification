import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:remote_notification/services/notification_contoller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) {
        if (!isAllowed) {
          AwesomeNotifications().requestPermissionToSendNotifications();
        }
      },
    );

    NotificationController.requestFirebaseToken();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: ElevatedButton(
              child: Text("Subscribe"),
              onPressed: () {
                NotificationController.subscribeToTopics("Anime");
              },
            ),
          ),
          Center(
            child: ElevatedButton(
              child: Text("Unsubscribe"),
              onPressed: () {
                NotificationController.unSubscribeToTopics("Anime");
              },
            ),
          ),
        ],
      ),
    ));
  }
}
