import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:todoapp/shared/components/components.dart';

class NotificationServices {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


  static initSettingNotification() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings('@drawable/todo');
    const IOSInitializationSettings iosInitializationSettings = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings );
  }

  Future<void> displayNotification({required int id, required  String title, required  DateTime dateTime}) async {
    AndroidNotificationDetails androidNotificationDetails = const AndroidNotificationDetails(
        "Ahmed_Salah_Todo_id" , "Ahmed_Salah_Todo_Channel",
        playSound: true,
        enableVibration: true,
        largeIcon: DrawableResourceAndroidBitmap('todo'),
      enableLights: true,

    );
    IOSNotificationDetails iosNotificationDetails = const IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true
    );
    if(dateTime.isAfter(DateTime.now())){
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id ,
        getGreeting(dateTime),
        title,
        tz.TZDateTime.from(dateTime, tz.local),
         NotificationDetails(
          android: androidNotificationDetails,
           iOS: iosNotificationDetails
        ),
        uiLocalNotificationDateInterpretation:UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
      );
    }

  }
}
