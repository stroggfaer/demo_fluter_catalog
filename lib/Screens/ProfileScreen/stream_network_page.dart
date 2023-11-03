import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_catalog/Api/api.dart';
import 'package:my_catalog/Shared/Loading.dart';
import 'package:my_catalog/Shared/app_bar.dart';
import 'package:my_catalog/Styles/styles.dart';
import 'package:my_catalog/Utils/language_constants.dart';

class StreamNetworkPage extends StatefulWidget {
  const StreamNetworkPage({Key? key}) : super(key: key);

  @override
  _StreamNetworkPageState createState() => _StreamNetworkPageState();
}

class _StreamNetworkPageState extends State<StreamNetworkPage> {

  late Stream<double> streamPrice;
  late StreamSubscription<double> subscription;

  late double prices = 0.00;
  late bool loading = false;

  _prices() async {
    try{
      var price = await Api().getPrices();
      print('price: $price');
      setState(() {
        loading = false;
        prices = price;
      });
    }catch(e) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
      // init;
     _prices();
      // пуск
      streamPrice = Stream.periodic(const Duration(seconds: 5)).asyncMap((_) => Api().getPrices());
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: headerAppBar(context, titleAppBar:translation(context).stream_network),
        body:StreamBuilder<double>(
          initialData: prices,
          stream: streamPrice,
          builder: (context, snapshot) {
            print(snapshot.data);
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(child: Loading(fullHeight: true, size: 50.0));
              default:
                if (snapshot.hasError) {
                  return Container(
                    padding: const EdgeInsets.only(bottom: 10.0, top: 20.0, left: defaultPadding, right: defaultPadding ),
                    child: const Text('Some error occurred!'),
                  );
                } else {
                  final price = snapshot.data?.toStringAsFixed(2);
                  return   Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(bottom: 10.0, top: 20.0, left: defaultPadding, right: defaultPadding ),
                        child: Text('Обновляться каждые 10 секунд',style: ThemeText.textFontSize(color: Styles.black,fontSize: 16)),
                      ),
                      Container(
                        padding: const EdgeInsets.only(bottom: 10.0, top: 20.0, left: defaultPadding, right: defaultPadding ),
                        child: Text('Поток биржа курс: $price р.',style: ThemeText.textFontSize(color: Styles.black,fontSize: 16)),
                      ),
                    ],
                  );
                }
            }
          },
        ),
    );
  }

  Widget controlContent() {
    return Container(
      padding: const EdgeInsets.only(bottom: 10.0, top: 10.0, left: defaultPadding, right: defaultPadding ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ElevatedButton(onPressed: () => subscription.pause(), child: const Text("Пауза")),
                const SizedBox(width: 10,),
                ElevatedButton(onPressed: () => subscription.resume(), child: const Text("Пуск")),
              ],
            )
          ]
      ),
    );
  }
}
