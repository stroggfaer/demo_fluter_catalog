import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
bool isOpenErrorNetwork = false;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  void _sendScreenView(PageRoute<dynamic> route) {
    var screenName = route.settings.name;
    print('screenName $screenName');
    // do something with it, ie. send it to your analytics service collector
    isOpenErrorNetwork = false;
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route is PageRoute) {
      _sendScreenView(route);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute is PageRoute) {
      _sendScreenView(newRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute is PageRoute && route is PageRoute) {
      _sendScreenView(previousRoute);
    }
  }
}


String? getErrorText(dynamic err) {
  if (err == null) return null;
  if (err == '') return null;
  if (err is String) return err;
  if (err is DioError) {
    if (err.response != null && err.response!.data != null) {
      return err.response!.data['message'];
    }
  }
  // ApiResponse
  if (err) {
    return getErrorText(err.error);
  }
}

// Показываем текст сеть;
alertShowErrorNetwork({BuildContext? context}) {
  return ScaffoldMessenger.of(context ?? navigatorKey.currentContext!).showSnackBar(

      SnackBar(
        key: const Key("current_snack_bar"),
        content: const Text('Нет соединение с интернетом'),
        duration: const Duration(hours: 5),
        elevation: 0,
        action: SnackBarAction(
          label:'Закрыть',
          onPressed: () {
             clearSnackBar();
             print('alertShowErrorNetwork:  ${navigatorKey.currentContext!.widget.key}');
             print('Action is clicked');
          },
          textColor: Colors.white,
          disabledTextColor: Colors.grey,
        ),
      )
  );
}

hideSnackBar({BuildContext? context}) {
  ScaffoldMessenger.of(context ?? navigatorKey.currentContext!).hideCurrentSnackBar();
}
clearSnackBar({BuildContext? context}) {
  ScaffoldMessenger.of(context ?? navigatorKey.currentContext!).clearSnackBars();
}


showErrorNetwork(
    BuildContext context, {
      isOffline = false,
      isSnackBar = false,
      String? message,
      String? title,
      String? btnCancel,
    }) {
  var _message = "Не удалось выполнить запрос. Повторите позднее.";
  if (isOffline) {
    _message = "Для работы приложения необходимо подключение к интернету.";
  }
  if (message != null) _message = message;

  if (!isOpenErrorNetwork) {
    isOpenErrorNetwork = true;

    return showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title ?? "Ошибка"),
          content: Text(_message),
          actions: [
            TextButton(
              child: Text(btnCancel ?? "Понятно"),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        );
      },
    ).then((val) {
      isOpenErrorNetwork = false;
    });
  }
}