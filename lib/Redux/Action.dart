import 'package:my_catalog/Model/Basket.dart';
import 'package:my_catalog/Model/LanguageModel.dart';
import 'package:my_catalog/Model/User.dart';


class AddBasketAction {
   final Basket basket;
   AddBasketAction(this.basket);
}
// Удалить;
class DeleteBasketAction {
   final int id;
   DeleteBasketAction(this.id);
}

class RemoveBasketAction {}

class FetchUserAction{}

class LoadUserAction {
   final User user;
   LoadUserAction(this.user);
}

// Статус связи;
class LoadConnectivityAction {
   final bool isConnectivity;
   LoadConnectivityAction(this.isConnectivity);
}

//Тест нагрузка на сервер
class SetLoadTestAction {
   final int counts;
   SetLoadTestAction(this.counts);
}
class ResetLoadTestThunkAction{}

class LoadedSpinnerAction{
   final bool isSpinner;
   LoadedSpinnerAction(this.isSpinner);
}

class FetchLanguageAction{}

class SetLanguageAction {
   final LanguageModel language;
   SetLanguageAction(this.language);
}