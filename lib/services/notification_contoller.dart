import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NotificationController extends ChangeNotifier {
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
}
