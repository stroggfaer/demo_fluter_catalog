import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_catalog/Model/ModelChar/ChartModel.dart';
import 'package:my_catalog/Styles/styles.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PieChar extends StatefulWidget {
  const PieChar({Key? key}) : super(key: key);

  @override
  _PieCharState createState() => _PieCharState();
}

class _PieCharState extends State<PieChar> {

  late final List<ChartModel> chartData;
  late List<ChartModel> data;
  late TooltipBehavior _tooltip;
  late TooltipBehavior _tooltip1;

  @override
  void initState() {
    _tooltip = TooltipBehavior(enable: true);
    _tooltip1 = TooltipBehavior(enable: true);

    chartData = [
      ChartModel(x:'Умная колонка', y:120, color: Colors.red),
      ChartModel(x:'Детский 3D-принтер', y:234, color: Colors.blue),
      ChartModel(x:'Камера GoPro', y:455, color: Colors.green),
      ChartModel(x:'Робот-пылесос', y:553, color: Colors.blueGrey),
      ChartModel(x:'Корейская косметика', y:346, color: Colors.amberAccent),
    ];
    data = [
      ChartModel(x:'Детский 3D-принтер', y:25),
      ChartModel(x:'Умная колонка', y:38),
      ChartModel(x:'Робот-пылесос', y:452),
      ChartModel(x:'Умная колонка', y:232)
    ];
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child:  Container(
          padding: const EdgeInsets.only(bottom: 10.0, top: 10.0, left: defaultPadding, right: defaultPadding ),
          child: Column(children: [

            SfCircularChart(
                title: ChartTitle(text: 'Популярные товары для продажи',alignment: ChartAlignment.near),
                tooltipBehavior: _tooltip1,
                series: <CircularSeries>[
                  // Render pie chart
                  PieSeries<ChartModel, String>(
                      dataSource: chartData,
                      pointColorMapper:(ChartModel data, _) => data.color,
                      xValueMapper: (ChartModel data, _) => data.x,
                      yValueMapper: (ChartModel data, _) => data.y,
                      dataLabelSettings:DataLabelSettings(isVisible : true),
                      name: 'За год'
                  )
                ]
            ),
            SfCircularChart(
                title: ChartTitle(text: 'Топ продаваемых товаров',alignment: ChartAlignment.near),
                tooltipBehavior: _tooltip,
                series: [
                  DoughnutSeries<ChartModel, String>(
                      dataSource: data,
                      xValueMapper: (ChartModel data, _) => data.x,
                      yValueMapper: (ChartModel data, _) => data.y,
                      dataLabelSettings:DataLabelSettings(isVisible : true),
                      name: 'За месяц'
                  )
                ]
            ),
          ])
      ),
    );




  }
}
class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}