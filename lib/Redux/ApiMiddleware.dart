import 'package:my_catalog/Api/api.dart';
import 'package:my_catalog/Model/AppState.dart';
import 'package:redux/redux.dart';
import 'index.dart';

// Запрос Апи через  Middleware пропускаем для того чтобы приложение не завись
class ApiMiddleware extends MiddlewareClass<AppState> {

  @override
  Future call(Store<AppState> store, action, NextDispatcher next) async {
    // Загрузка юзер;
    if (action is FetchUserAction) {
       _fetchUser(store, action);
    }
    next(action);
  }
}
// Получаем пользователь;
Future _fetchUser(Store<AppState> store, FetchUserAction action) async{
  var res = await Api().fetchUser();
  print('_fetchUser ${res.payload.id}');
  store.dispatch(LoadUserAction(res.payload));
}

