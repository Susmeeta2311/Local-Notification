import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationAndroidSettings =
        AndroidInitializationSettings("@mipmap/ic_launcher");

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationAndroidSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void sendInstanceNotification({
    required String title,
    required String description,
  }) {
    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        "instant_channel",
        "Instant Notification",
        channelDescription: "Notification that appears instantly.",
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
      ),
    );
    flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      description,
      notificationDetails,
    );
  }

  void sendScheduleNotification({
    required String title,
    required String body,
    required DateTime dateTime,
  }) async {
    final tz.TZDateTime scheduledDate = tz.TZDateTime.from(dateTime, tz.local);
    print("📅 Scheduled Date & Time: $scheduledDate");

    NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        "schedule_channel",
        "schedule_notification",
        channelDescription: "Notification that appears after some time..!",
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      title,
      body,
      scheduledDate,
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
    print("✅ Scheduled notification set!");
  }
}
