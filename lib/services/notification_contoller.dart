import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:remote_notification/services/local_notification.dart';

class NotificationController extends ChangeNotifier {
  static final NotificationController _instance =
      NotificationController._internal();

  factory NotificationController() {
    return _instance;
  }

  NotificationController._internal();

  // initialization method
  static Future<void> initializeLocalNotifications(
      {required bool debug}) async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: "navigation_notification",
          channelName: "Basic notifications",
          channelDescription: "Notification channel for basic tests",
          importance: NotificationImportance.Max,
          defaultPrivacy: NotificationPrivacy.Private,
          enableVibration: true,
          defaultColor: Colors.redAccent,
          channelShowBadge: true,
          enableLights: true,
          icon: null,
          // playSound: true,
          // soundSource: 'resource://raw/naruto_jutsu',
        ),
      ],
      debug: debug,
    );
  }

  // Event listeners
  static Future<void> initializeNotificationsEventListeners() async {
    //
    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onDismissActionReceivedMethod:
          NotificationController.onDismissActionReceivedMethod,
      onNotificationCreatedMethod:
          NotificationController.onNotificationCreatedMethod,
      // onNotificationDisplayedMethod: NotificationController.onNotificationDisplayedMethod,
    );
  }

  //
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    bool isSilentAction =
        receivedAction.actionType == ActionType.SilentAction ||
            receivedAction.actionType == ActionType.SilentBackgroundAction;

    // debugPrint(
    //   "${isSilentAction ? 'silentAction' : 'Action'} Notification received }",
    // );

    debugPrint("Received action ${receivedAction.toString()}");

    // if (receivedAction.buttonKeyPressed == 'SUBSCRIBE') {
    //   debugPrint("Subscribe action button pressed");
    // }

    Fluttertoast.showToast(
      msg:
          "${isSilentAction ? 'silentAction' : 'Action'} Notification received }",
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Colors.blue,
      gravity: ToastGravity.BOTTOM,
    );
  }

//
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedAction) async {
    debugPrint(
      "Notification created",
    );

    Fluttertoast.showToast(
      msg: "Notification created",
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Colors.blue,
      gravity: ToastGravity.BOTTOM,
    );
  }

  static Future<void> onNotificationDisplayedMethod(
      ReceivedAction receivedAction) async {
    debugPrint(
      "Notification displayed",
    );

    Fluttertoast.showToast(
      msg: "Notification displayed",
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Colors.blue,
      gravity: ToastGravity.BOTTOM,
    );
  }

  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint(
      "Notification dismiss",
    );

    Fluttertoast.showToast(
      msg: "Notification dismiss",
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Colors.blue,
      gravity: ToastGravity.BOTTOM,
    );
  }

  // this function is called when the app is terminatted
  static Future<void> getInitialNotificationAction() async {
    ReceivedAction? receivedAction = await AwesomeNotifications()
        .getInitialNotificationAction(removeFromActionEvents: true);

    if (receivedAction == null) return;
  }

// REMOTE NOTIFICATION INITIALIAZATION
  static Future<void> initializeRemoteNotifications({
    required bool debug,
  }) async {
    // Intialize plugins
    await Firebase.initializeApp();
    await AwesomeNotificationsFcm().initialize(
      onFcmTokenHandle: NotificationController.myFcmTokenHandle,
      onFcmSilentDataHandle: NotificationController.mySilentDataHandle,
      onNativeTokenHandle: NotificationController.myNativeTokenHandle,
      licenseKeys: [],
      debug: debug,
    );
  }

  // Remote Notification Event Listener

  // Use this method to execute on background when a silent data arrives
  // (Even when terminated)
  static Future<void> mySilentDataHandle(FcmSilentData silentData) async {
    Fluttertoast.showToast(
      msg: "Silent data received",
      backgroundColor: Colors.blueAccent,
      textColor: Colors.white,
      fontSize: 16,
    );
    debugPrint('"Silent Data": ${silentData.data}');

    //
    if (silentData.data!['IsLiveScore'] == "true") {
      LocalNotification.createLiveScoreNotification(
        id: 1,
        title: silentData.data!['title']!,
        body: silentData.data!['body']!,
        largeIcon: silentData.data!['largeIcon'],
      );
    }

    //
    if (silentData.createdLifeCycle == NotificationLifeCycle.Foreground) {
      debugPrint("FOREGROUND");
    } else {
      debugPrint("BACKGROUND");
    }
  }

  // use this method to detect when a new fcm token is received
  static Future<void> myFcmTokenHandle(String token) async {
    Fluttertoast.showToast(
      msg: "Fcm token received",
      backgroundColor: Colors.blueAccent,
      textColor: Colors.white,
      fontSize: 16,
    );
    debugPrint('"Firebase token": $token');
  }

  // Use this method to detect when a new native token is received
  static Future<void> myNativeTokenHandle(String token) async {
    Fluttertoast.showToast(
      msg: "Native token received",
      backgroundColor: Colors.blueAccent,
      textColor: Colors.white,
      fontSize: 16,
    );
    debugPrint('"Native token": $token');
  }

  // REQUEST FIREBASE TOKEN
  static Future<String> requestFirebaseToken() async {
    if (await AwesomeNotificationsFcm().isFirebaseAvailable) {
      try {
        return await AwesomeNotificationsFcm().requestFirebaseAppToken();
      } catch (exception) {
        debugPrint("$exception");
      }
    } else {
      debugPrint("Firebase is not available for this project");
    }
    return '';
  }

  // SUBSCRIBE OR UNSUBSCRIBE TO TOPICS
  static Future<void> subscribeToTopics(String topic) async {
    await AwesomeNotificationsFcm().subscribeToTopic(topic);
    debugPrint("Subscribe to $topic");
  }

  static Future<void> unSubscribeToTopics(String topic) async {
    await AwesomeNotificationsFcm().subscribeToTopic(topic);
    debugPrint("Unsubscribe to $topic");
  }
}
