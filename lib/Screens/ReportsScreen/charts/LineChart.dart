import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_catalog/Model/ModelChar/ChartModel.dart';
import 'package:my_catalog/Model/ModelChar/SalesData.dart';
import 'package:my_catalog/Model/Orders.dart';
import 'package:my_catalog/Screens/ReportsScreen/filters/filter_range.dart';
import 'package:my_catalog/Styles/styles.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class LineChart extends StatefulWidget {
  const LineChart({Key? key}) : super(key: key);

  @override
  _LineChartState createState() => _LineChartState();
}

class _LineChartState extends State<LineChart> {

  late FilterChart dateRangeCurrent;

  late dynamic totalPrices = 0.00;

  List<Orders> ordersList = [];
  List<Orders> ordersReturnList = [];

  List<SalesData> data = [];

  List<SalesData> data1 = [];

  late List lineFilters = [];

  @override
  void initState() {

     // По умол загружаем;
     setState(() {
       dateRangeCurrent = FilterChart(
         startDate: '2022-11-01',
         endDate: '2022-11-14',
         isDiscount: null,
         isReturn: null,
         selectsCat: 0,
       );
     });
     _fetchOrders();

     //_orderFetchChart();
     _dateInt(dateRangeCurrent.startDate);

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

   _fetchOrders() {
       setState(() {
         data = [];
         data1 = [];
         totalPrices = 0.00;
         ordersList = [];
       });

       DateTime startDate = DateTime.parse(dateRangeCurrent.startDate);
       DateTime endDate = DateTime.parse(dateRangeCurrent.endDate);

       for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
             var random = Random();
             int price = random.nextInt(1000);
             int price1 = random.nextInt(999);
             var date = startDate.add(Duration(days: i));
             var dateStr = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

             var cat = 1001;
             var _isDiscount = false;
             var _isReturnGood = false;

             switch (i) {
               case 0:
                 cat = 1002;
                 _isDiscount = true;
                 _isReturnGood = true;
                 break;
               case 3:
                  cat = 1003;
                  _isDiscount = true;
                  _isReturnGood = true;
                  break;
               case 6:
                 cat = 1004;
                 _isDiscount = true;
                 _isReturnGood = true;
                 break;
               case 7:
                 cat = 1002;
                 _isDiscount = true;
                 _isReturnGood = true;
                 break;
               case 8:
                 cat = 1003;
                 _isDiscount = true;
                 _isReturnGood = true;
                 break;
               case 9:
                 cat = 1004;
                 _isDiscount = true;
                 _isReturnGood = true;
                 break;
               case 10:
                 cat = 1002;
                 _isDiscount = true;
                 _isReturnGood = true;
                 break;
             }
             // Генератор;
             ordersList.add(Orders(
                   id: i,
                   title: "$i Office Code",
                   price: price,
                   size: 12,
                   category: cat,
                   isDiscount: _isDiscount,
                   dateTime: dateStr,
                   description: '',
                   image: "assets/images/bag_1.png",
                   isReturnGood: _isReturnGood,
                   counts: 4,
                 ));
             ordersReturnList.add(Orders(
               id: i + 100,
               title: "$i Office Code",
               price: price1,
               size: 12,
               category: cat,
               isDiscount: _isDiscount,
               dateTime: dateStr,
               description: '',
               image: "assets/images/bag_1.png",
               isReturnGood: true,
               counts: 4,
             ));

             // var result = ordersList.where((order) =>
             //    order.dateTime == dateStr &&
             //    order.isDiscount == (dateRangeCurrent.isDiscount ?? false)
             // );
             // var order = result.isNotEmpty ? result.first : null;
           //  print('order+++  ${ordersList[i].isReturnGood}');
             if(dateRangeCurrent.selectsCat != null && dateRangeCurrent.selectsCat != 0) {
               if((dateRangeCurrent.isDiscount ?? false) == false && dateRangeCurrent.selectsCat == ordersList[i].category) {
                 totalPrices += ordersList[i].price;
                 data.add(SalesData('${date.day}/${date.month}', ordersList[i].price));
                 data1.add(SalesData('${date.day}/${date.month}', ordersReturnList[i].price));

               }
               if((dateRangeCurrent.isDiscount ?? false) == true && dateRangeCurrent.selectsCat == ordersList[i].category) {
                 totalPrices += ordersList[i].price;
                 data.add(SalesData('${date.day}/${date.month}', ordersList[i].price));
                 data1.add(SalesData('${date.day}/${date.month}', ordersReturnList[i].price));
               }
             }else{
               if((dateRangeCurrent.isDiscount ?? false) == false) {
                 totalPrices += ordersList[i].price;
                 data.add(SalesData('${date.day}/${date.month}', ordersList[i].price));
                 data1.add(SalesData('${date.day}/${date.month}', ordersReturnList[i].price));
               }
               if((dateRangeCurrent.isDiscount ?? false) == true) {
                 totalPrices += ordersList[i].price;
                 data.add(SalesData('${date.day}/${date.month}', ordersList[i].price));
                 data1.add(SalesData('${date.day}/${date.month}', ordersReturnList[i].price));
               }
             }
         }

         if(ordersList.isEmpty) totalPrices = 0.00;
   }


  _findByfilter(String date) {
    var findById = (Orders obj) =>
    obj.dateTime == date &&
    obj.isDiscount == (dateRangeCurrent.isDiscount ?? false);
    var result = ordersList.where(findById);
    return result.isNotEmpty ? result.first : null;
  }

  _orderFetchChart() {
    // lineFilters.clear();
    // data.clear();
    setState(() {
      lineFilters = [];
      data = [];
      data1 = [];
      totalPrices = 0.00;
    });

    // Прибыль
    if(dateRangeCurrent.selectsCat != null && dateRangeCurrent.selectsCat != 0) {
      print('lineFilters A ${dateRangeCurrent.selectsCat}');
      lineFilters.addAll(orders.where((order) =>
      _dateInt(order.dateTime) >= _dateInt(dateRangeCurrent.startDate) &&
          _dateInt(order.dateTime) <= _dateInt(dateRangeCurrent.endDate) &&
          order.isDiscount == (dateRangeCurrent.isDiscount ?? false) &&
          order.category == dateRangeCurrent.selectsCat
      ).toList());
    }else{
      print('lineFilters B');
      lineFilters = orders.where((order) =>
      _dateInt(order.dateTime) >= _dateInt(dateRangeCurrent.startDate) &&
          _dateInt(order.dateTime) <= _dateInt(dateRangeCurrent.endDate) &&
          order.isDiscount == (dateRangeCurrent.isDiscount ?? false)
      ).toList();
    }

    DateTime startDate = DateTime.parse(dateRangeCurrent.startDate);
    DateTime endDate = DateTime.parse(dateRangeCurrent.endDate);

    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      var date = startDate.add(Duration(days: i));
      var dateStr = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
     // print('days  ${startDate.add(Duration(days: i))}');
      print('dateStr  ${dateStr}');

        var order = _findByfilter(dateStr);
        print('order  ${order?.price}');
        if(order !=null) {
           totalPrices += order.price;
        }

        data.add(SalesData('${date.day}/${date.month}', order?.price));
    }



    /*
    for(int i = 0; i < lineFilters.length; i++) {
       var dateParse = DateTime.parse(lineFilters[i].dateTime);
       print('dateTime: ${lineFilters[i].dateTime}');

       if(lineFilters[i].isReturnGood == true) {
         data1.add(SalesData('${dateParse.day}/${dateParse.month}', lineFilters[i].price));
       }
       if(lineFilters[i].isReturnGood == false) {
         totalPrices += lineFilters[i].price;
         data.add(SalesData('${dateParse.day}/${dateParse.month}', lineFilters[i].price));
       }

    } */

    if(lineFilters.isEmpty) totalPrices = 0.00;
    // var sum = lineFilters.fold(0, (previous, current) => previous.price + current.price);
    print('lineFilters: $lineFilters');
    print('isDiscount: ${dateRangeCurrent.isDiscount ?? false}');
    print('dateRangeCurrent: ${dateRangeCurrent.startDate} - ${dateRangeCurrent.endDate}');
  }

  _dateInt(date) {
    var dateParse = DateTime.parse(date);
 //   print(int.parse("${dateParse.year}${dateParse.month.toString().padLeft(2, '0')}${dateParse.day.toString().padLeft(2, '0')}"));
    return int.parse("${dateParse.year}${dateParse.month.toString().padLeft(2, '0')}${dateParse.day.toString().padLeft(2, '0')}");
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView (
      child: Container(
          padding: const EdgeInsets.only(bottom: 10.0, top: 10.0, left: defaultPadding, right: defaultPadding ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 1.5, color: Colors.grey),
                    ),
                  ),
                  child: FilterRange(
                      dateRangeCurrent: dateRangeCurrent,
                      onDateRange: (value) {
                        final startDate = DateFormat('yyyy-MM-dd').format(value.startDate);
                        final endDate = DateFormat('yyyy-MM-dd').format(value.endDate);

                        setState(() {
                          dateRangeCurrent = FilterChart(startDate: startDate, endDate: endDate);
                        });
                      },
                      onSelect: (v) {
                          setState(() {
                            dateRangeCurrent = FilterChart(
                              startDate: dateRangeCurrent.startDate,
                              endDate: dateRangeCurrent.endDate,
                              isDiscount: dateRangeCurrent.isDiscount,
                              isReturn: dateRangeCurrent.isReturn,
                              selectsCat: v,
                            );
                          });
                      },
                      onDiscount: (v) {
                        setState(() {
                          dateRangeCurrent = FilterChart(
                            startDate: dateRangeCurrent.startDate,
                            endDate: dateRangeCurrent.endDate,
                            isDiscount: v,
                            isReturn: dateRangeCurrent.isReturn,
                            selectsCat: dateRangeCurrent.selectsCat,
                          );
                        });
                      },
                      onReturn: (v) {
                        setState(() {
                          dateRangeCurrent = FilterChart(
                            startDate: dateRangeCurrent.startDate,
                            endDate: dateRangeCurrent.endDate,
                            isDiscount: dateRangeCurrent.isDiscount,
                            isReturn: v,
                            selectsCat: dateRangeCurrent.selectsCat,
                          );
                        });
                      },
                      onTap: () {
                        _fetchOrders();
                        //  Отправить
                       // _orderFetchChart();
                        // print(dateRangeCurrent.isDiscount);
                      }
                  ),
                ),
                Container(
                    padding: const EdgeInsets.only(bottom: 20.0, top: 20.0 ),
                    child: Text('Прибыль: $totalPrices р.',style: ThemeText.textFontSize(color: Styles.black,fontSize: 24, fontStyle: 'bold'))
                ),
                Container(
                  height: 400,
                  constraints: const BoxConstraints(maxHeight: 600),
                  child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      // Chart title
                      title: ChartTitle(text: 'Продажи товара',alignment: ChartAlignment.near),
                      // Enable legend
                      legend: Legend(isVisible: true, position: LegendPosition.top, alignment: ChartAlignment.near),
                      // Enable tooltip
                      tooltipBehavior: TooltipBehavior(enable: true),
                      series: <ChartSeries<SalesData, String>>[
                        LineSeries<SalesData, String>(
                            dataSource: data,
                            xValueMapper: (SalesData sales, _) => sales.year,
                            yValueMapper: (SalesData sales, _) => sales.sales,
                            name: 'Продажи',
                            markerSettings: const MarkerSettings(
                                isVisible: true
                            ),
                            // Enable data label
                            dataLabelSettings: const DataLabelSettings(isVisible: true)),
                        LineSeries<SalesData, String>(
                            dataSource: data1,
                            xValueMapper: (SalesData sales, _) => sales.year,
                            yValueMapper: (SalesData sales, _) => sales.sales,
                            name: 'Возврат',
                            markerSettings: const MarkerSettings(
                                isVisible: true
                            ),
                            // Enable data label
                            dataLabelSettings: const DataLabelSettings(isVisible: true)),
                      ]),
                )
              ]
          )
      ),
    );
  }
}
