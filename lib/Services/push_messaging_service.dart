import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../firebase_options.dart';

class PushMessagingService {

  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static String? name = 'my_catalog';
  static final onMessage = FirebaseMessaging.onMessage;
  static final onMessageOpenedApp = FirebaseMessaging.onMessageOpenedApp;
  // Init FB;
  static Future _initializeApp() async{
    WidgetsFlutterBinding.ensureInitialized();
    return await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
        name: name
    );
  }

  //
  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.', // description
    importance: Importance.max,
  );

  // flutter local notification
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // firebase background message handler
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await _initializeApp();

    print('A Background message just showed up : ${message.messageId}');
  }

  static initPush() async {

    await _initializeApp();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);


    //Firebase messaging
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // 3. On iOS, this helps to take the user permissions
    Future<NotificationSettings> settings = _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if(Platform.isIOS) {
      _messaging.requestPermission();
    }
  }

  static Future getTokenApns() async {
    return await _messaging.getAPNSToken();
  }

  static Future getTokenFcm() async {
    return await _messaging.getToken();
  }

}