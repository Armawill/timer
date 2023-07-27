import 'dart:typed_data';

// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzl;

class NotificationService {
  // static Future<void> initializeNotification() async {
  //   await AwesomeNotifications().initialize(
  //       'resource://mipmap/app_icon',
  //       [
  //         NotificationChannel(
  //           channelKey: 'high_importance_channel',
  //           channelGroupKey: 'high_importance_channel',
  //           channelName: 'Basic notifications',
  //           channelDescription: 'Notification channel for basic test',
  //           defaultColor: Colors.amber,
  //           importance: NotificationImportance.Max,
  //           channelShowBadge: true,
  //           playSound: true,
  //           criticalAlerts: true,
  //         ),
  //       ],
  //       channelGroups: [
  //         NotificationChannelGroup(
  //             channelGroupKey: 'high_importance_channel_group',
  //             channelGroupName: 'Group 1')
  //       ],
  //       debug: true);

  //   await AwesomeNotifications()
  //       .isNotificationAllowed()
  //       .then((isAllowed) async {
  //     if (!isAllowed) {
  //       await AwesomeNotifications().requestPermissionToSendNotifications();
  //     }
  //   });

  //   await AwesomeNotifications().setListeners(
  //     onActionReceivedMethod: onActionReceivedMethod,
  //     onDismissActionReceivedMethod: onDismissActionReceivedMethod,
  //     onNotificationCreatedMethod: onNotificationCreatedMethod,
  //     onNotificationDisplayedMethod: onNotificationDisplayedMethod,
  //   );
  // }

  // /// Use this method to detect when a new notification or a schedule is created
  // static Future<void> onNotificationCreatedMethod(
  //     ReceivedNotification receivedNotification) async {
  //   debugPrint('onNotificationCreatedMethod');
  // }

  // /// Use this method to detect every time that a new notification displayed
  // static Future<void> onNotificationDisplayedMethod(
  //     ReceivedNotification receivedNotification) async {
  //   debugPrint('onNotificationDisplayedMethod');
  // }

  // /// Use this method to detect if the user dismiss a notification
  // static Future<void> onDismissActionReceivedMethod(
  //     ReceivedNotification receivedNotification) async {
  //   debugPrint('onDismissActionReceivedMethod');
  // }

  // /// Use this method to detect when the user taps on notification or action button
  // static Future<void> onActionReceivedMethod(
  //     ReceivedNotification receivedNotification) async {
  //   debugPrint('onActionReceivedMethod');
  // }

  // static Future<void> showNotification({
  //   required final String title,
  //   required final String body,
  //   final String? summary,
  //   Map<String, String>? payload,
  //   final ActionType actionType = ActionType.Default,
  //   final NotificationLayout notificationLayout = NotificationLayout.Default,
  //   final NotificationCategory? category,
  //   final String? bigPicture,
  //   final List<NotificationActionButton>? actionButtons,
  //   bool scheduled = false,
  //   final int? interval,
  // }) async {
  //   assert(!scheduled || (scheduled && interval != null));

  //   await AwesomeNotifications().createNotification(
  //     content: NotificationContent(
  //       id: 1,
  //       channelKey: 'high_importance_channel',
  //       title: title,
  //       body: body,
  //       fullScreenIntent: true,
  //       autoDismissible: false,
  //       locked: true,
  //       actionType: ActionType.KeepOnTop,
  //       category: NotificationCategory.Alarm,
  //       criticalAlert: true,
  //       wakeUpScreen: true,
  //       // notificationLayout: notificationLayout,
  //       // summary: summary,
  //       // category: category,
  //       // payload: payload,
  //       // bigPicture: bigPicture,
  //       // locked: true,
  //     ),
  //     actionButtons: [
  //       NotificationActionButton(
  //         key: 'stop',
  //         label: 'Stop 1',
  //         actionType: ActionType.SilentAction,
  //       )
  //     ],
  //     schedule: scheduled
  //         ? NotificationInterval(
  //             interval: interval,
  //             timeZone:
  //                 await AwesomeNotifications().getLocalTimeZoneIdentifier(),
  //             preciseAlarm: true,
  //           )
  //         : null,
  //   );
  // }

  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  @pragma('vm:entry-point')
  static void backgroundHandler(NotificationResponse notificationResponse) {
    onNotifications.add(notificationResponse.payload);
  }

  static Future initialize() async {
    if (_notifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>() !=
        null) {
      _notifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestPermission();
    }

    // tzl.initializeTimeZones();
    // var locationName = await FlutterNativeTimezone.getLocalTimezone();
    // if (locationName == 'Europe/Kiev') {
    //   locationName = 'Europe/Zaporozhye';
    // }
    // tz.setLocalLocation(tz.getLocation(locationName));

    var androidInitialize = AndroidInitializationSettings('mipmap/app_icon');
    var initializationSettings =
        new InitializationSettings(android: androidInitialize);
    await _notifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        onNotifications.add(notificationResponse.payload);
      },
      onDidReceiveBackgroundNotificationResponse: backgroundHandler,
    );
  }

  static Future _notificationDetails() async {}

  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  static Future showNotification({
    var id = 0,
    required String title,
    required String body,
    var payload,
  }) async {
    final Int64List vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;
    const int insistentFlag = 4;

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      playSound: true,
      ongoing: true,
      category: AndroidNotificationCategory.status,
    );

    final NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await _notifications.show(
      id++,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }
}
