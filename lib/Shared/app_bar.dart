import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:my_catalog/Model/AppState.dart';
import 'package:my_catalog/Screens/BasketScreen/basket_screen.dart';
import 'package:my_catalog/Shared/connections.dart';
import 'package:my_catalog/Styles/styles.dart';

AppBar headerAppBar(BuildContext context,{
  required String titleAppBar,
  bool isBasket = false,
  Function(String status)? onChange,
  TabBar? tabBar
}) {
  return AppBar(
    title: Text(titleAppBar),
    //   return  Text(titleAppBar);
    centerTitle: false,
    actions: [
      GestureDetector(
          onTap: () {
            if(isBasket == true) {
              Navigator.push(context, CupertinoPageRoute(builder: (context) => const BasketScreen()));
            }
          },
          child: SizedBox(
              width: 60,
              child: Stack(
                  alignment: Alignment.center,
                  children:  [
                    const Icon(Icons.shopping_cart,size: 30,),
                    Positioned(
                        top: 8.0,
                        left: 32.0,
                        child: Container(
                            width: 18,
                            height: 18,
                            padding: const EdgeInsets.only(bottom: 1.0),
                            decoration: BoxDecoration(
                              color: Styles.pageBackground,
                              borderRadius: BorderRadius.circular(100.0),
                            ),
                            child: Center(
                                child: StoreConnector<AppState, int>(
                                  converter: (store) => store.state.basket.length,
                                  builder: (context, count) {
                                    return Text('$count', style: ThemeText.textFontSize(color: Styles.white, fontSize: 10, fontStyle: 'bold'),);
                                  },
                                )
                            )
                        )
                    ),
                  ]
              )
          )
      ),
    ],
    flexibleSpace: Connections(onChange: (status) {
       if(onChange != null) onChange!(status);
    }),
    bottom: tabBar
  );
}