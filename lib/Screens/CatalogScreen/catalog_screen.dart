import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:my_catalog/Api/api.dart';
import 'package:my_catalog/Model/Basket.dart';
import 'package:my_catalog/Model/AppState.dart';
import 'package:my_catalog/Redux/index.dart';
import 'package:my_catalog/Screens/CatalogScreen/catalog_detail_screen.dart';
import 'package:my_catalog/Screens/CatalogScreen/item_card.dart';
import 'package:my_catalog/Screens/LanguageScreen/language_screen.dart';
import 'package:my_catalog/Shared/app_bar.dart';
import 'package:my_catalog/Shared/tab_bottom_navigation_bar.dart';
import 'package:my_catalog/Styles/styles.dart';
import 'package:my_catalog/Utils/language_constants.dart';
import 'package:redux/redux.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:universal_translator/universal_translator.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({Key? key}) : super(key: key);

  @override
  _CatalogScreenState createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {

  List productsItems = [];
  int selectedIndex = 0;
  bool loading = false;

  /*---AwsTranslate---*/
 /// late AwsTranslate awsTranslate;


  void _fetchData() async {
    setState(() => loading = true);
    try{
      final response = await Api().fetchProducts();
      setState(() {
        loading = false;
        productsItems = response.payload;
      });
    }catch(e) {
      setState(() => loading = false);
    }

  }

  @override
  void initState() {
    final store = StoreProvider.of<AppState>(context, listen: false);
    print('catalog_screen: ${store.state.isConnectivity}');
    _fetchData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Store <AppState> store = StoreProvider.of(context);
    //print('store ${store.state.basket[0].id}');
    return Scaffold(
      appBar: headerAppBar(
          context,
          titleAppBar: translation(context).catalog, isBasket: true,
          onChange: (status) {}
      ),
      body: Padding(
        //padding: const EdgeInsets.symmetric(horizontal: 20.0),
        padding: const EdgeInsets.only(bottom: 20.0, top: 20.0, left: defaultPadding, right: defaultPadding ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

              // Text("Este texto mostra um placeholder diferente").translate(),
            const SizedBox(height: 10,),
            const SizedBox(height: 10,),
            //  Text(translate('app_bar.title')),
            Text(translation(context).helloWorld),
            // description
            Container(
                padding: const EdgeInsets.only(bottom: 20.0, top: 5.0),
                child: StoreConnector<AppState, AppState>(
                  converter: (store) => store.state,
                  builder: (context, state) {
                    if(state.user?.id != 0) {
                      return Text('User: ${state.user?.name}').translate();
                    }else{
                      return const Text('User: Загрузка 10 сек').translate();
                    }
                  },
                )
            ),
            Flexible(child: loading ? const Center(child: CircularProgressIndicator()) :
            productsItems.isNotEmpty ?
            GridView.builder(
                itemCount: productsItems.length,
                primary: false,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: defaultPadding,
                  crossAxisSpacing: defaultPadding,
                  childAspectRatio: 0.75,

                ),
                itemBuilder: (context, index) => ItemCard(
                  product: productsItems[index],
                  press: () => {
                    //  print('products: ${products[index].id}'),product
                    // Navigator.push(context, CupertinoPageRoute(builder: (context) =>CatalogDetailScreen(id: products[index].id)))
                    Navigator.push(context, CupertinoPageRoute(builder: (context) => CatalogDetailScreen(
                      product: productsItems[index],

                    )))
                  },
                  onAddClick: () {
                    var product = productsItems[index];
                    store.dispatch(
                      AddBasketAction(Basket(
                          id: product.id,
                          title: product.title,
                          image: product.image
                      )),
                    );
                  },
                )) : const Text('Нет данных').translate())
          ],
        ),
      ),

      bottomNavigationBar: TabBottomNavigationBar(onTab: (int index) {
       // print(index);
      // if(index == 1) Navigator.push(context, CupertinoPageRoute(builder: (context) => const ProfileScreen()));
      },indexTab: 0),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const LanguageScreen()));
        },
        child: const Icon(Icons.language_sharp),
      ),
    );
  }
}
