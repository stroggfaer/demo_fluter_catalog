import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_catalog/Model/Basket.dart';
import 'package:my_catalog/Shared/WebImage.dart';
import 'package:my_catalog/Styles/styles.dart';
import 'package:universal_translator/universal_translator.dart';

class ItemCardBasket extends StatelessWidget {
  final Basket basket;
  final Function()? press;
  const ItemCardBasket({Key? key, required this.basket, this.press}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width:70, //size.width,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Styles.grey,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Hero(
            tag: "${basket.id}",
            child: WebImage(url: basket.image),
          ),
        ),
        Expanded(
            child: Padding(
              padding:  const EdgeInsets.only(left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    // products is out demo list
                    basket.title,
                    style: const TextStyle(color: Styles.black),
                  ).translate(),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: press,
                    child: Container(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Text('Удалить', style: ThemeText.textFontSize(color: Styles.red, fontSize: 14)).translate(),
                    ),
                  )
                ],
              ),
            )
        )
      ],
    );
  }
}
