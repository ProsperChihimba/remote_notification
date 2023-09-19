import 'package:awesome_notifications/awesome_notifications.dart';

class LocalNotification {
  static Future<void> createLiveScoreNotification({
    required int id,
    required String title,
    required body,
    String? largeIcon,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: "navigation_notification",
        title: title,
        body: body,
        largeIcon: largeIcon,
      ),
    );
  }
}
