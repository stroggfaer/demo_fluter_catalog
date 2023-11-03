import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_catalog/Model/Product.dart';
import 'package:my_catalog/Services/db.dart';
import 'package:my_catalog/Shared/Item_card_compact.dart';
import 'package:my_catalog/Shared/app_bar.dart';
import 'package:my_catalog/Shared/tab_bottom_navigation_bar.dart';
import 'package:my_catalog/Styles/styles.dart';
import 'package:my_catalog/Utils/language_constants.dart';
import 'package:sqflite/sqflite.dart';
import 'package:universal_translator/universal_translator.dart';


class SettingsProductsScreen extends StatefulWidget {
  const SettingsProductsScreen({Key? key}) : super(key: key);

  @override
  _SettingsProductsScreenState createState() => _SettingsProductsScreenState();
}

class _SettingsProductsScreenState extends State<SettingsProductsScreen> {
  List productsItems = [];
  late int productsCounts = 0;

  @override
  void initState() {

    _productsAll();
    // TODO: implement initState
    super.initState();
  }

  Future _productsAll() async {
    try{
      var res = await DB.queryAll();
      print(res);
      var products = Product.listFromJson(res);
      // Получить все записей;
      var counts = Sqflite.firstIntValue(await DB.queryRaw(sql: 'SELECT COUNT(*) FROM ${DB.tablename}'));     //Sqflite.firstIntValue();
      setState(() {
        productsItems = products;
        productsCounts = counts ?? 0;
      });
    }catch(e) {}

    return products;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: headerAppBar(context, titleAppBar:translation(context).settings_products),
        body: Container(
          padding: const EdgeInsets.only(bottom: 10.0, top: 20.0, left: defaultPadding, right: defaultPadding ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ElevatedButton(onPressed: () async {
                var random = Random();
                int randomInt = random.nextInt(100000);
                int idRandom = ((random.nextDouble() * randomInt) ~/ 1);
                int price = random.nextInt(100);
                // Api().addProductPost(
                //      title: 'New product',
                //      price: 13.5,
                //      description: 'lorem ipsum set',
                //      image: 'https://i.pravatar.cc',
                //      category: 'electronic'
                //  );
                // id, title, category, price, description, image
                DateTime date = DateTime.now();
                // Формируем запись;
                Map<String, dynamic> product() {
                  return {
                    "id": idRandom,
                    "title": '$idRandom product',
                    "category":  'electronic',
                    "price": price,
                    "description": 'lorem ipsum set',
                    "date_time": date.toIso8601String(),
                    "is_sqf_lite": 1,
                    "image": 'https://i.pravatar.cc?u=$idRandom'
                  };
                }

                //print('toJson ${product()}');
                await DB.insert(product());
                _productsAll();
                //
              }, child: const Text("+ Добавить товар").translate()),
              const SizedBox(height: 10,),
              productsItems.isNotEmpty ?
              Text('Список товаров ($productsCounts)',style: ThemeText.textFontSize(color: Styles.black,fontSize: 16)).translate() :
              const Text(''),
              const SizedBox(height: 10,),
              Expanded(child:  _products(),)
            ],
          ),
        ),
        bottomNavigationBar: TabBottomNavigationBar(onTab: (int index) {
          print(index);
          // Navigator.push(context, CupertinoPageRoute(builder: (context) => const SettingsProductsScreen()));
        },indexTab: 2)
    );
  }

  Widget _products() {
    return productsItems.isNotEmpty ? GridView.builder(
        itemCount: productsItems.length,
        primary: false,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            mainAxisSpacing: defaultPadding,
            crossAxisSpacing: defaultPadding,
            childAspectRatio: 5
        ),
        itemBuilder: (context, index) => ItemCardCompact(
          product: productsItems[index],
          press: () async {
            var product = productsItems[index];
            await DB.delete(product.id);
            print('delete ${product.id}');
            _productsAll();
          },
          onEdit: (id) async {
             print('id: $id');
             var random = Random();
             var price = random.nextInt(100);
             showDialog(
               context: context,
               builder: (_) {
                 return AlertDialog(
                   title: const Text("Редактировать").translate(),
                   content: SingleChildScrollView(
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         const Text('Демо значение').translate(),
                         const SizedBox(height: 10),
                         Text('Update $id product').translate(),
                         Text('Цена: $price').translate()
                       ],
                     ),
                   ),
                   actions: [
                     TextButton(
                       child: const Text("Отмена").translate(),
                       onPressed: (){
                         Navigator.pop(context, false);
                       },
                     ),
                     TextButton(
                       child: const Text("Сохранить").translate(),
                       onPressed: () async{
                         // Формируем запись
                         Map<String, dynamic> product() => {
                           "id": id,
                           "title": 'Update $id product',
                           "price": price
                         };

                         await DB.update(product());
                         await _productsAll();
                         Navigator.pop(context, false);
                       },
                     ),
                   ],
                 );
               }
             );
          },
        )) : const Text('Нет данные').translate();
  }
}
