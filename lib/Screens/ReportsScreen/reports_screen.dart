import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_catalog/Shared/app_bar.dart';
import 'package:my_catalog/Shared/tab_bottom_navigation_bar.dart';
import 'package:my_catalog/Styles/styles.dart';
import 'charts/BarChart.dart';
import 'charts/LineChart.dart';
import 'charts/PieChar.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child:  Scaffold(
          appBar: headerAppBar(
            context,
            titleAppBar: 'Статистика', isBasket: true,
            onChange: (status) {
              print('CatalogScreen: $status');
            },
            tabBar: const TabBar(
                labelColor: Styles.blueLite,
                unselectedLabelColor: Colors.white,
                indicatorColor: Styles.blueLite,
              tabs: [
                Tab(
                    icon: Icon(Icons.stacked_line_chart),
                    text: 'LineChar',
                ),
                Tab(
                    icon: Icon(Icons.bar_chart_sharp),
                    text: 'BarChar',
                ),
                Tab(
                    icon: Icon(Icons.pie_chart),
                    text: 'PieChar',
                ),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              LineChart(),
              BarChart(),
              PieChar()
            ],
          ),

          bottomNavigationBar: TabBottomNavigationBar(onTab: (int index) {
          },indexTab: 3)
      ),
    );
  }


  // Линие график;

}

