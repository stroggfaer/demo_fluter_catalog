import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:my_catalog/Api/api.dart';
import 'package:my_catalog/Model/AppState.dart';
import 'package:my_catalog/Model/LanguageModel.dart';
import 'package:my_catalog/Redux/index.dart';
import 'package:my_catalog/Shared/network_error.dart';
import 'package:my_catalog/Utils/language_constants.dart';
import 'package:my_catalog/main.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

// API запрос вместо Middleware Вариант 1;
ThunkAction loadUserThunkAction() {
  return (Store store) async {
    Future(() async{
      print('AppState Start');
      var res = await Api().fetchUser();
      print('ThunkAction _fetchUser ${res.payload.id}');
      store.dispatch(LoadUserAction(res.payload));
    });
  };
}

// API запрос вместо Middleware Вариант 2;;
// ThunkAction <AppState>loadUserThunkAction = (Store<AppState> store) async {
//   print('AppState Start');
//   var res = await Api().fetchUser();
//   print('ThunkAction _fetchUser ${res.payload.id}');
//   store.dispatch(LoadUserAction(res.payload));
// };

/*---TEST НАГРУЗКИ НА ВЫЧЕСЛЕНИЕ---*/
ThunkAction loadTestThunkAction = (Store store) async {
  store.dispatch(LoadedSpinnerAction(true));
  print('start loadTestThunkAction 900000000');
  // Отложка;
  await compute(listCalc, 1999999990).then((value) => store.dispatch(SetLoadTestAction(value)));

  // Без него;
  //await listCalc(1999999990).then((value) => store.dispatch(SetLoadTestAction(value)));
  //print('end loadTestThunkAction 900000000');
  store.dispatch(LoadedSpinnerAction(false));
};


Future<int> listCalc(int count) async {
  int result = 0;
  for (var i = 0; i < count; ++i) {
    result++;
  }
  return result;
}

Future setLanguageAction(Store store, lang) async {
  print('++ setLanguageAction: $lang');
  Locale locale = await setLocale(lang);
  MyApp.setLocale(navigatorKey.currentContext!, locale);
  store.dispatch(SetLanguageAction(LanguageModel(lang: lang)));
}
