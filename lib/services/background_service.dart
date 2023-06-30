import 'dart:async';
import 'dart:ui';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer/services/overlay_service.dart';

class BackgroundService {
  static const int _period = 200;
  static Future<void> initilizeService() async {
    final service = FlutterBackgroundService();
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'my_foreground_notification', // id
      'MY FOREGROUND NOTIFICATION SERVICE', // title
      description: 'This channel is used for important notifications.',
      importance: Importance.low,
      playSound: false,
    );
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: true,
        isForegroundMode: false,
        notificationChannelId: 'my_foreground_notification',
        foregroundServiceNotificationId: 777,
        initialNotificationTitle: 'AWESOME SERVICE',
        initialNotificationContent: 'Initializing',
        autoStartOnBoot: true,
      ),
      iosConfiguration: IosConfiguration(
        // autoStart: true,
        onForeground: null,
        onBackground: null,
      ),
    );
  }

  @pragma('vm:entry-point')
  static void onStart(ServiceInstance service) async {
    DartPluginRegistrant.ensureInitialized();
    int duration = 0;
    String targetTime = 'null';
    bool isShow = false;
    bool setAsForeground = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    if (service is AndroidServiceInstance) {
      service.on('setAsForeground').listen((event) {
        service.setAsForegroundService();
      });
      service.on('setAsBackground').listen((event) {
        service.setAsBackgroundService();
      });
    }
    service.on('stopService').listen((event) {
      service.stopSelf();
    });

    Timer.periodic(const Duration(milliseconds: _period), (timer) async {
      await prefs.reload();

      if (service is AndroidServiceInstance) {
        if (prefs.getBool('isShow') != null) {
          isShow = prefs.getBool('isShow')!;
        }
        if (prefs.getInt('duration') != null && prefs.getInt('duration')! > 0) {
          duration = prefs.getInt('duration')!;
          prefs.setInt('duration', 0);
        }
        if (prefs.getString('targetTime') != null) {
          targetTime = prefs.getString('targetTime')!;
        }
        if (prefs.getBool('setAsForeground') != null) {
          setAsForeground = prefs.getBool('setAsForeground')!;
          prefs.remove('setAsForeground');
          if (!setAsForeground) {
            service.setAsBackgroundService();
          }
        }

        if (await service.isForegroundService()) {
          if (isShow) {
            flutterLocalNotificationsPlugin.show(
              777,
              'Timer',
              targetTime != 'null'
                  ? duration <= 0
                      ? 'Timer done'
                      : 'Timer will end at $targetTime'
                  : 'Timer paused',
              const NotificationDetails(
                  android: AndroidNotificationDetails(
                'my_foreground_notification',
                'MY FOREGROUND NOTIFICATION SERVICE',
                ongoing: true,
                playSound: false,
              )),
            );

            if (targetTime != 'null') {
              if (duration <= 0) {
                OverlayService.show();
                OverlayService.play();
                isShow = false;
                await prefs.setBool('isShow', false);
              }

              duration -= _period;
            }
          }
        } else {
          OverlayService.stop();
          targetTime = 'null';
          prefs.remove('targetTime');
        }
      }
      service.invoke('update');
    });
  }
}
