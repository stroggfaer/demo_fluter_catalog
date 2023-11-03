import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_catalog/Model/ModelChar/ChartBarData.dart';
import 'package:my_catalog/Model/Orders.dart';
import 'package:my_catalog/Screens/ReportsScreen/filters/filter_bar.dart';
import 'package:my_catalog/Styles/styles.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BarChart extends StatefulWidget {
  const BarChart({Key? key}) : super(key: key);

  @override
  _BarChartState createState() => _BarChartState();
}

class _BarChartState extends State<BarChart> {
  late List<ChartBarData> data = [];
  late TooltipBehavior _tooltip;
  late ZoomPanBehavior _zoomPanBehavior;

  @override
  void initState() {
    _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      zoomMode: ZoomMode.x,
      enablePanning: true,
    );
    _tooltip = TooltipBehavior(enable: true);

    _fetchReports('2022');

    // TODO: implement initState
    super.initState();
  }

  //
  _fetchReports(String year) {
    setState(() {
      data = [];
    });
    var  resultMonths = _findByYear(year);
    List months = ['янв', 'фев', 'март', 'апр', 'май', 'июн', 'июл', 'авг', 'сент', 'окт', 'нояб', 'дек'];
    var m = 0;
    for (int i = 0; i < months.length; i++) {
        m = i + 1;
        if(resultMonths != null) {
          Months mont = resultMonths.months[i];
          data.add(ChartBarData(months[i], mont.total));
        }
    }
  }

  _findByYear(String year) {
    var result = reportsBar.where((value) => value.year == year);
    return result.isNotEmpty ? result.first : null;
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
              decoration:  const BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1.5, color: Colors.grey),
                ),
              ),
              child: FilterBar(
                  year: '2022',
                  onSelect: (value) {
                    print(value);
                    _fetchReports(value);
                  },
                  onTap: () {

                  }
              ),
            ),
            Container(
                padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
                child: SfCartesianChart(
                    zoomPanBehavior: _zoomPanBehavior,

                    primaryXAxis: CategoryAxis(
                        rangePadding: ChartRangePadding.none,
                        labelRotation: 90,
                        edgeLabelPlacement: EdgeLabelPlacement.none,

                        autoScrollingMode: AutoScrollingMode.start,
                      //  interval: 0.5
                    ),
                    primaryYAxis: NumericAxis(
                        minimum: 0,
                        interval: 10,
                       // enableAutoIntervalOnZooming: true,
                      //  anchorRangeToVisiblePoints: false,
                    //    autoScrollingMode: AutoScrollingMode.start



                    ),
                    tooltipBehavior: _tooltip,
                    enableAxisAnimation: true,

                    series: <ChartSeries<ChartBarData, String>>[
                      ColumnSeries<ChartBarData, String>(
                          dataSource: data,
                          xValueMapper: (ChartBarData data, _) => data.x,
                          yValueMapper: (ChartBarData data, _) => data.y,
                          name: 'Количество продаж за месяц',
                          color: const Color.fromRGBO(8, 142, 255, 1))
                    ])
            ),
          ],
        ),
      )
    );






  }
}
