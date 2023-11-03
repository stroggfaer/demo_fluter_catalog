import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_catalog/Model/Basket.dart';
import 'package:my_catalog/Model/AppState.dart';
import 'package:my_catalog/Model/LanguageModel.dart';
import 'package:my_catalog/Model/User.dart';
import 'package:my_catalog/Shared/Loading.dart';
import 'package:redux/redux.dart';
import 'Action.dart';

AppState reducers(AppState state, action) {
  // Можно продолжить несколько сторис
  return AppState(
      basket: _basketReducer(state.basket, action),
      user: _userReducer(state, action),
      isConnectivity: _connectivity(state, action),
      counts: _test_load(state, action),
      isSpinner: _spinnerReducer(state, action),
      language: _languageReducer(state, action),
      error: null
  );
}

// Добавыить/Удалить (кмбинировать 1 способ)
final _basketReducer = combineReducers<List<Basket>>([
  TypedReducer<List<Basket>, AddBasketAction>(_toggleReducer),
  TypedReducer<List<Basket>, DeleteBasketAction>(_deleteReducer),
  TypedReducer<List<Basket>, RemoveBasketAction>(_removeReducer),
]);

// Добавить или удалить
List<Basket> _toggleReducer(List<Basket> baskets, AddBasketAction action) {
  var basket = baskets.firstWhere((item) => item.id == action.basket.id, orElse: () => Basket.empty());
  List<Basket> tempList = [...baskets];

  if(basket.id != 0) {
    tempList.removeWhere((element) => element.id == basket.id);
  }else{
    tempList.add(action.basket);
  }
 return tempList;
}

//Удалить
List<Basket> _deleteReducer(List<Basket> baskets, DeleteBasketAction action) {
  List<Basket> tempList = [...baskets];
  tempList.removeWhere((element) => element.id == action.id);
  return tempList;
}

// Очистить корзина;
List<Basket> _removeReducer(List<Basket> baskets, RemoveBasketAction action) {
  return [];
}

// Комбинировать 2 способ;
User _userReducer(AppState state, dynamic action) {
  if (action is FetchUserAction) {
    return User.empty();
  } else if (action is LoadUserAction) {
    return action.user;
  } else {
    return state.user ?? User.empty();
  }
}

bool? _connectivity(AppState state, dynamic action) {
  if (action is LoadConnectivityAction) {
    return action.isConnectivity;
  }else{
    return state.isConnectivity;
  }
}

int _test_load(AppState state, dynamic action) {
  if (action is SetLoadTestAction) {
    return action.counts;
  }else if(action is ResetLoadTestThunkAction) {
    return 0;
  }else{
    return state.counts;
  }
}

bool _spinnerReducer (AppState state, dynamic action) {
  if (action is LoadedSpinnerAction) {
    return action.isSpinner;
  }else{
    return state.isSpinner;
  }
}
// Reducer<Widget> _spinnerReducer = combineReducers([
//     TypedReducer(_getSpinnerReducer),
//     TypedReducer(_loadedSpinnerReducer)
// ]);
LanguageModel _languageReducer(AppState state, dynamic action) {
  if (action is FetchLanguageAction) {
    return LanguageModel.defaultLang();
  } else if (action is SetLanguageAction) {
    return action.language;
  } else {
    return state.language;
  }
}
