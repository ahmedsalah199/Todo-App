import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todoapp/modules/splash_screan.dart';
import 'package:todoapp/shared/network/local/local_notification.dart';
import 'package:todoapp/shared/bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationServices.initSettingNotification();
  BlocOverrides.runZoned(() {
      runApp( MyApp());
    },
    blocObserver: MyBlocObserver(),
  );
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent,statusBarIconBrightness: Brightness.dark));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        timePickerTheme: TimePickerThemeData(
          backgroundColor: Colors.amberAccent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScrean(),
    );
  }
}
