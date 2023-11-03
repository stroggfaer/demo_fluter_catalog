import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:my_catalog/Model/AppState.dart';
import 'package:my_catalog/Model/Product.dart';
import 'package:my_catalog/Shared/WebImage.dart';
import 'package:my_catalog/Shared/checkbox_ui.dart';
import 'package:my_catalog/Styles/styles.dart';
import 'package:my_catalog/Utils/helpers.dart';
import 'package:redux/redux.dart';
import 'package:universal_translator/universal_translator.dart';
class ItemCard extends StatefulWidget {
  final Product product;
  final Function()? press;
  final Function()? onAddClick;
  const ItemCard({
    Key? key,
    required this.product,
    this.press,
    this.onAddClick,
  }) : super(key: key);

  @override
  _ItemCardState createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {

  var productTitle = '';

  @override
  void initState() {
    setState(() {
      productTitle = widget.product.title;
    });
    //_translate();
    // TODO: implement initState
    super.initState();
  }

  _translate() async {
    var textTr =  await Helpers.translateGoogle(text: widget.product.title);
    setState(() {
      productTitle = textTr;
    });
    print('textTr++: $textTr');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    //   final Store <AppState> store = StoreProvider.of(context);
    //bool isActive = store.state.basket.any((basket) => basket.id == product.id);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
            child:  GestureDetector(
              onTap: widget.press,
              child: Container(
                width: size.width,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Styles.grey,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Hero(
                  tag: "${widget.product.id}",
                  child: WebImage(url: widget.product.image),   // Image.network(product.image),
                  //child: Image.asset(product.image),
                ),
              ),
            )
        ),
        // translateGoogle
        //  Text("Este texto mostra um placeholder diferente").translate(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: defaultPadding / 4),
          child: Text(
            // products is out demo list
            productTitle,
            style: const TextStyle(color: Styles.black),
          ).translate(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                "\$${widget.product.price}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            GestureDetector(
              onTap: widget.onAddClick,
              child: Container(
                padding: const EdgeInsets.only(right: 10.0),
                child: StoreConnector<AppState, bool>(
                    converter: (store) {
                      return store.state.basket.any((basket) => basket.id == widget.product.id); // some аналог;
                    },
                    builder: (context, isActive) {
                      return Icon(Icons.add_shopping_cart,size: 20, color: isActive == true ? Styles.red: Styles.black);
                    }
                ),
              ),
            ),

          ],
        )
      ],
    );
  }
}
