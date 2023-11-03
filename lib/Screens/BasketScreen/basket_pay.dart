import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_catalog/Shared/app_bar.dart';
import 'package:my_catalog/Styles/styles.dart';
import 'package:my_catalog/Utils/language_constants.dart';

class BasketPay extends StatefulWidget {
  const BasketPay({Key? key}) : super(key: key);

  @override
  _BasketPayState createState() => _BasketPayState();
}

class _BasketPayState extends State<BasketPay> {

  late Stream<double> stream;
  late StreamSubscription<double> subscription;

  late double prices = 0.00;
  late bool loading = false;

  @override
  void initState()  {
     _initStream();
    // TODO: implement initState
    super.initState();
  }

  // Стрим цены ;
  getPrice() => Stream<double>.periodic(const Duration(seconds: 1), (count) => prices + count * 5);

  _initStream() {
    stream = getPrice();
    subscription = stream.listen((price) {
      setState(()=> prices = price);
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final price = prices.toStringAsFixed(2);
    return Scaffold(
        appBar: headerAppBar(context, titleAppBar:translation(context).stream_local),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 10.0, top: 20.0, left: defaultPadding, right: defaultPadding ),
              child: Text('${translation(context).flow_exchange_rate}: $price р.',style: ThemeText.textFontSize(color: Styles.black,fontSize: 16)),
            ),
            controlContent()
          ],
        )
    );
  }

  //Stream<double> getPrice() => Stream<double>.periodic(const Duration(seconds: 1), (count) => prices + count * 5);

   //stream
  Widget findContent(snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.waiting:
        return const Center(child: CircularProgressIndicator());
      default:
        if (snapshot.hasError) {
          print('hasError: ${snapshot.hasError}');
          return const Center(child: Text('Произошла какая-то ошибка!'));
        } else {
          final price = snapshot.data?.toStringAsFixed(2);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 10.0, top: 20.0, left: defaultPadding, right: defaultPadding ),
                child: Text('Поток биржа курс: $price р.',style: ThemeText.textFontSize(color: Styles.black,fontSize: 16)),
              ),
              controlContent()
            ],
          );
        }
    }
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
                const SizedBox(width: 10,),
                ElevatedButton(onPressed: () {
                  subscription.cancel();
                  setState(() => prices = 0.00);
                }, child: const Text("Завершить")),
              ],
            ),
            ElevatedButton(onPressed: () {
              subscription.cancel();
              setState(() => prices = 0.00);
              _initStream();
            }, child: const Text("Запуск")),
          ]
      ),
    );
  }

}


// Stream<int> _stData() async* {
//   yield* Stream.periodic(const Duration(seconds: 1), (int a) {
//     return a++;
//   });
// }