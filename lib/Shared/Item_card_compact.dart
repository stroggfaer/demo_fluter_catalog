import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_catalog/Model/Product.dart';
import 'package:my_catalog/Shared/WebImage.dart';
import 'package:my_catalog/Styles/styles.dart';

class ItemCardCompact extends StatelessWidget {
  final Product product;
  final Function()? press;
  final Function(int value)? onEdit;
  const ItemCardCompact({Key? key, required this.product, this.press, this.onEdit}) : super(key: key);
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
            tag: "${product.id}",
            child: WebImage(url: product.image),
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
                    product.title,
                    style: const TextStyle(color: Styles.black),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    // products is out demo list
                    'Цена: ${product.price}',
                    style: const TextStyle(color: Styles.black),
                  ),
                  const SizedBox(height: 5),
                  GestureDetector(
                    onTap: press,
                    child: Container(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Text('Удалить', style: ThemeText.textFontSize(color: Styles.red, fontSize: 14)),
                    ),
                  ),
                ],
              ),
            )
        ),
        GestureDetector(
          onTap: () {
           if(onEdit != null) onEdit!(product.id);
          },
          child: Container(
            padding: const EdgeInsets.only(right: 10.0),
            child: const Icon(Icons.edit, color: Styles.red,), //Text('Редактировать', style: ThemeText.textFontSize(color: Styles.blue, fontSize: 14)),
          ),
        )
      ],
    );
  }
}
