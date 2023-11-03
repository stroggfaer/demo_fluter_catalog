import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:my_catalog/Api/api.dart';
import 'package:my_catalog/Model/Basket.dart';
import 'package:my_catalog/Model/Product.dart';
import 'package:my_catalog/Model/AppState.dart';
import 'package:my_catalog/Redux/index.dart';
import 'package:my_catalog/Services/db.dart';
import 'package:my_catalog/Shared/WebImage.dart';
import 'package:my_catalog/Shared/app_bar.dart';
import 'package:my_catalog/Styles/styles.dart';
import 'package:my_catalog/Utils/helpers.dart';
import 'package:my_catalog/Utils/translate_preferences.dart';
import 'package:redux/redux.dart';
import 'package:translator/translator.dart';

class CatalogDetailScreen extends StatefulWidget {
  final Product product;


  const CatalogDetailScreen({Key? key, required this.product}) : super(key: key);

  @override
  _CatalogDetailScreenState createState() => _CatalogDetailScreenState();
}

class _CatalogDetailScreenState extends State<CatalogDetailScreen> {
  late  Product productFind = Product.empty();
  late  bool loading = false;
  late  String translation = '';


  void _fetchFind() async {
    setState(() => loading = true);
    try{
      final res = await Api().viewProducts(id: widget.product.id);
      var text = "Практический опыт показывает, что новая модель организационной деятельности в значительной степени обуславливает создание системы масштабного изменения ряда параметров";
      var textTr = await Helpers.translateGoogle(text: text);

      setState(() {
        translation = textTr; //translationRes;
        loading = false;
        productFind = res.payload;
      });
    }catch(e) {
      print('error view $e');
      setState(() => loading = false);
    }

  }

  @override
  void initState() {
    //TODO Задача sqflite
    //queryRow


    _fetchFind();
    // setState(() {
    //   productFind = widget.product;
    // });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final Store <AppState> store = StoreProvider.of(context);

    print(translation);
    return Scaffold(
      appBar: headerAppBar(context, titleAppBar:  productFind.title != '' ? productFind.title :'Загрузка...' ,isBasket: true),
      body: Container(
        padding: const EdgeInsets.only(bottom: 10.0, top: 10.0, left: defaultPadding, right: defaultPadding ),
        child: loading ?
        const Center(child: CircularProgressIndicator()) :
        productFind.id == 0 ? const Center(child: Text('нет данных')) :
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: size.width,
              height: 250,
              decoration: BoxDecoration(
                color: productFind.color,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Hero(
                tag: "${productFind.id}",
                child: WebImage(url: productFind.image),
              ),
            ),
            Container(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\$ ${productFind.price}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    store.dispatch(
                      AddBasketAction(Basket(
                          id: productFind.id,
                          title: productFind.title,
                          image: productFind.image
                      )),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: StoreConnector<AppState, bool>(
                        converter: (store) {
                          return store.state.basket.any((basket) => basket.id == productFind.id); // some аналог;
                        },
                        builder: (context, isActive) {
                          return Icon(Icons.add_shopping_cart,size: 20, color: isActive == true ? Styles.red: Styles.black);
                        }
                    ),
                  ),
                ),
              ],
            ),
            Container(height: 15,),
             Text(translation, style: const TextStyle(fontWeight: FontWeight.normal),
            ),
          ],
        ),
      )
    );
  }
}
