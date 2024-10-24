import 'dart:io';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationRepository {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static final onClickNotification = BehaviorSubject<String>();
  static final _androidFlutterLocalNotificationsPlugin =
      AndroidFlutterLocalNotificationsPlugin();

  // on tap on any notification
  static void onNotificationTap(NotificationResponse notificationResponse) {
    onClickNotification.add(notificationResponse.payload!);
  }

  static Future init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) {},
    );
    const LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
            linux: initializationSettingsLinux);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onNotificationTap,
        onDidReceiveBackgroundNotificationResponse: onNotificationTap);
  }

  //show a simple notification
  static Future showSimpleNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    print("showSimpleNotification() called");
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('simple channel', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin
        .show(1, title, body, notificationDetails, payload: payload);
  }

  static Future showPeriodicNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    print("showPeriodicNotification() called");
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('your channel 2', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );
    if (Platform.isAndroid) {
      await _androidFlutterLocalNotificationsPlugin
          .requestExactAlarmsPermission();
      print(await _androidFlutterLocalNotificationsPlugin
          .canScheduleExactNotifications());
    }
    await _flutterLocalNotificationsPlugin.periodicallyShow(
        2, title, body, RepeatInterval.everyMinute, notificationDetails,
        androidAllowWhileIdle: true);
  }

  static Future showScheduledNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    tz.initializeTimeZones();
    var localTime = tz.local;

    print("showScheduledNotification() called");
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('channel 3', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );
    await _flutterLocalNotificationsPlugin.zonedSchedule(
        2,
        title,
        body,
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle);
  }

  static Future cancel(int id) async {
    print("cancel Notification() called");
    await _flutterLocalNotificationsPlugin.cancel(2);
  }

  static Future cancelAll() async {
    print("cancel All Notification() called");
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
