import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_catalog/Api/api.dart';
import 'package:my_catalog/Shared/Loading.dart';
import 'package:my_catalog/Shared/app_bar.dart';
import 'package:my_catalog/Styles/styles.dart';
import 'package:my_catalog/Utils/language_constants.dart';

class StreamControlPage extends StatefulWidget {
  const StreamControlPage({Key? key}) : super(key: key);

  @override
  _StreamControlPageState createState() => _StreamControlPageState();
}

class _StreamControlPageState extends State<StreamControlPage> {
  final controller = StreamController<double>();

  late double prices = 0.00;
  late bool loading = false;
  late bool btnLoading = false;

  _prices() async {
    try{
      var price = await Api().getPrices();
      print('price: $price');
      controller.sink.add(price);
      setState(() {
        btnLoading = false;
        loading = false;
        prices = price;
      });
    }catch(e) {
      setState(() {
        loading = false;
        btnLoading = false;
      });
    }
  }


  @override
  void initState() {
    setState(() => loading = true);
    _prices();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    controller.close();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: headerAppBar(context, titleAppBar:translation(context).stream_control),
      body:loading ? const Loading() : StreamBuilder<double>(
        initialData: prices,
        stream: controller.stream,
        builder: (context, snapshot) {
          print(snapshot.data);
          final price = snapshot.data?.toStringAsFixed(2);
          var valueText = btnLoading ? 'Подождите...' :'Поток биржа курс: $price р.';
         // btnLoading
          return  Container(
            padding: const EdgeInsets.only(bottom: 10.0, top: 20.0, left: defaultPadding, right: defaultPadding ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(valueText, style: ThemeText.textFontSize(color: Styles.black,fontSize: 16)),
                const SizedBox(height: 30.0),
                ElevatedButton(onPressed: () {
                  prices = prices + 500;
                  controller.sink.add(prices);
                }, child: const Text("Добавить +500 р")),
                ElevatedButton(onPressed: () {
                  setState(() => btnLoading = true);
                  _prices();
                }, child: const Text("Обновить")),
              ],
            ),
          );
        },
      ),
    );
  }


}
