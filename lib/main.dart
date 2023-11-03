import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:my_catalog/Api/api.dart';
import 'package:my_catalog/Model/AppState.dart';
import 'package:my_catalog/Model/LanguageModel.dart';
import 'package:my_catalog/Redux/ThunkActionApi.dart';
import 'package:my_catalog/Screens/SplashScreen/splash_screen.dart';
import 'package:my_catalog/Services/push_messaging_service.dart';
import 'package:my_catalog/Shared/network_error.dart';
import 'package:my_catalog/Utils/language_constants.dart';
import 'package:my_catalog/Utils/translate_preferences.dart';
import 'package:my_catalog/config.dart';
import 'package:my_catalog/l10n/l10n.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:universal_translator/universal_translator.dart';
import 'Redux/index.dart';
import 'Services/db.dart';
import 'Styles/styles.dart';

void main() async {
  // https://github.com/Jesway/Flutter-Translate/blob/master/example/lib/main.dart
  var delegate = await LocalizationDelegate.create(
      fallbackLocale: 'ru',
      supportedLocales: ['ru','en','zh','ar'],
      preferences: TranslatePreferences()
  );

  WidgetsFlutterBinding.ensureInitialized();
  await DB.initiateDatabase();

  final store = Store(
    reducers,
    initialState: AppState(language: LanguageModel.defaultLang()),
    middleware: [
      thunkMiddleware,
     // ApiMiddleware()
    ],
  );
  runApp(LocalizedApp(delegate, MyApp(store:store)));
}

class MyApp extends StatefulWidget {
  final Store<AppState> store;
  const MyApp({Key? key, required this.store}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  late LocalizationDelegate delegate;

  // Формат перевода;
  Map<String,dynamic> bodyPattern(String text, Locale to) {
      return  {
        "q": text,
        "source": "auto",  // to.toLanguageTag(),
        "target": to.toLanguageTag()
      };
  }

/*------ End Dynamic Translit--------*/

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) => {setLocale(locale)});
    super.didChangeDependencies();
  }

  @override
  void initState(){

    //TODO: Пуш уведомления только андроид;
    if(Platform.isAndroid) {
      initPushServer();

      // Получаем сообщения;
      PushMessagingService.onMessage.listen((RemoteMessage message) {
        String id = message.data['id'];
        String text = message.data['text'];
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;

        if (notification != null && android != null) {
          print('onMessage notification ${message.data}');
          PushMessagingService.flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                PushMessagingService.channel.id,
                PushMessagingService.channel.name,
                channelDescription: PushMessagingService.channel.description,
                color: Colors.orange,
                playSound: true,
                icon: '@mipmap/ic_launcher',
                fullScreenIntent: true,
                largeIcon: const DrawableResourceAndroidBitmap(
                    '@mipmap/ic_launcher'),
                //  ticker: 'ticker',
                //   channelAction: AndroidNotificationChannelAction.update
                //   actions: <AndroidNotificationAction>[
                //     const AndroidNotificationAction(
                //     'text_id_1',
                //     'Написать',
                //      inputs: <AndroidNotificationActionInput>[
                //         AndroidNotificationActionInput(
                //           label: 'Enter a message',
                //         ),
                //       ],
                //    ),
                //
                // ],
              ),
            ),
            payload: 'payload',
          );
        }
      });

      // открываем
      PushMessagingService.onMessageOpenedApp.listen((RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        print('onMessageOpenedApp');
        print(message.data);
        //
        String id = message.data['id'];
        String text = message.data['text'];
        if (notification != null && android != null) {
          showDialog(
              context: navigatorKey.currentContext!,
              builder: (_) {
                return AlertDialog(
                  title: Text("${notification.title}"),
                  content: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${notification.body}"),
                        Text("id: $id"),
                        Text("text: $text"),
                      ],
                    ),
                  ),
                );
              });
        }
      });
    }

  //  widget.store.dispatch(FetchUserAction()); // mid
    widget.store.dispatch(loadUserThunkAction());
    // TODO: implement initState
    super.initState();
  }

  Future<void> initPushServer() async {
     await PushMessagingService.initPush();
     var tokenFcm = await PushMessagingService.getTokenFcm();
     if(tokenFcm != null) {
       print('tokenFcm: $tokenFcm');
     }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var localizationDelegate = LocalizedApp.of(context).delegate;
    print(localizationDelegate.supportedLocales);

    return UniversalTranslatorInit(Config.pathApiTranslate,
      headers: Config.pathApiTranslateHeader,
      method: HttpMethod.post,
      responsePattern: responsePattern,
      bodyPattern: bodyPattern,
      translateTo: _locale ?? const Locale('ru'),
      // automaticDetection: true, // In case you don't know the user language
     // cacheDuration: const Duration(days: 13),
      // forceRefresh: true, // to ignore the cache data
       builder: () =>  StoreProvider(
        store: widget.store,
        child: MaterialApp(
            localeResolutionCallback: ( locale, supportedLocales ) {
              print('____locale___: $locale');
              return locale;
            },
            supportedLocales: L10n.all,
            locale: _locale, //Locale(widget.store.state.language.lang),
            debugShowCheckedModeBanner: false,
            title: 'Каталог онфлан демо',
            theme: ThemeData(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                primaryColor: Colors.orange,
                appBarTheme: const AppBarTheme(
                  color:  Styles.red,
                )
            ),
            home: const SplashScreen(),
            navigatorKey: navigatorKey,
            navigatorObservers: [MyRouteObserver()],
            localizationsDelegates:   [
              localizationDelegate,
              AppLocalizations.delegate,
              DefaultMaterialLocalizations.delegate,
              DefaultCupertinoLocalizations.delegate,
              DefaultWidgetsLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ]
        ),
      )
    );
  }
}


