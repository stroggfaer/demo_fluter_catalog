import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:my_catalog/Model/AppState.dart';
import 'package:my_catalog/Redux/Action.dart';
import 'package:my_catalog/Screens/BasketScreen/item_card_basket.dart';
import 'package:my_catalog/Shared/app_bar.dart';
import 'package:my_catalog/Styles/styles.dart';
import 'package:my_catalog/Utils/helpers.dart';
import 'package:my_catalog/Utils/language_constants.dart';
import 'package:redux/redux.dart';
import 'package:universal_translator/universal_translator.dart';

class BasketScreen extends StatelessWidget {
  const BasketScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: headerAppBar(context, titleAppBar: translation(context).basket),
      body: const Content()
    );
  }
}

class Content extends StatefulWidget {
  const Content({Key? key}) : super(key: key);

  @override
  _ContentState createState() => _ContentState();
}

class _ContentState extends State<Content> {

  // Стрим;
  StreamController<int> controller = StreamController<int>();

  late Stream<int> stream;
  late StreamSubscription<int> subscription;

  late int _timer = 30;

  @override
  void initState() {
    //Stream stream = controller.stream;
      final store = StoreProvider.of<AppState>(context, listen: false);
      stream = Stream.periodic(const Duration(seconds: 1), (tick) => tick);
      subscription = stream.listen((event) {
        setState(() => _timer = _timer - 1);
        // Таймер;
        if(_timer <= 0) {
          store.dispatch(RemoveBasketAction());
          subscription.cancel();
          print('CANCEL');
        }
        // print('_timer: $_timer');
      });
      if(store.state.basket.isEmpty) {
         subscription.cancel();
      }
     // TODO: implement initState
     super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // Если покидаем то отключаем стрим;
    _disposeSub();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final Store <AppState> store = StoreProvider.of(context);
    return Padding(
      //padding: const EdgeInsets.symmetric(horizontal: 20.0),
        padding: const EdgeInsets.only(bottom: 20.0, top: 20.0, left: defaultPadding, right: defaultPadding ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _message(),
            Flexible(
              child: StoreConnector<AppState, AppState>(
                  converter: (store) => store.state,
                  builder: (context, state) {
                    if(state.basket.isEmpty) {
                      _disposeSub();
                    }
                    return state.basket.isNotEmpty ? GridView.builder(
                           itemCount: state.basket.length,
                           primary: false,
                           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            mainAxisSpacing: defaultPadding,
                            crossAxisSpacing: defaultPadding,
                            childAspectRatio: 4

                        ),
                           itemBuilder: (context, index) => ItemCardBasket(
                          basket: state.basket[index],
                          press: () {
                            var basket = state.basket[index];
                            store.dispatch(DeleteBasketAction(basket.id));
                            print('delete');
                          },
                        )) : const Text('Ваша корзина пуста').translate();
                   }
              ),
            ),
          ],
        )
    );
  }

  Widget _message() {
    var sec = Helpers.numberNull(_timer);
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        if(state.basket.isNotEmpty) {
          return Container(
              padding: const EdgeInsets.only(bottom: 20.0, top: 5.0),
              child: _timer > 0 ? Text('Через $sec очиститься корзина').translate() : const Text('Очистился это у нас сработал stream').translate()
          );
        }else{
          return Container(child: null);
        }
      }
    );
  }

  _disposeSub() {
    try{
     subscription.cancel();
    }catch(e){
      print('subscription e $e');
    }
  }
}

