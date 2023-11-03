import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_catalog/Screens/CatalogScreen/catalog_screen.dart';
import 'package:my_catalog/Screens/ProfileScreen/profile_screen.dart';
import 'package:my_catalog/Screens/ReportsScreen/reports_screen.dart';
import 'package:my_catalog/Screens/SettingsProductsScreen/settings_products_screen.dart';
import 'package:my_catalog/Utils/language_constants.dart';

class TabBottomNavigationBar extends StatefulWidget {
  final int? indexTab;
  final Function(int index) onTab;
  const TabBottomNavigationBar({Key? key,
    this.indexTab,
    required this.onTab
  }) : super(key: key);

  @override
  _TabBottomNavigationBarState createState() => _TabBottomNavigationBarState();
}

class _TabBottomNavigationBarState extends State<TabBottomNavigationBar> {

  late int indexTab = widget.indexTab ?? 1;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: indexTab,
      items:  [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home),
          label: translation(context).catalog,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person),
          label: translation(context).profile,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.settings),
          label: translation(context).settings,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.bar_chart),
          label: translation(context).statistics,
        )
      ],
      onTap: (int index) {
        widget.onTab(index);
        print('index $index');
        if(indexTab != index) {
          switch (index) {
            case 0:
              _tabRoute(const CatalogScreen());
              break;
            case 1:
              _tabRoute(const ProfileScreen());
              break;
            case 2:
              _tabRoute(const SettingsProductsScreen());
              break;
            case 3:
              _tabRoute(const ReportsScreen());
              break;
          }
        }
      },
    );
  }

  _tabRoute(Widget widget) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => widget,
        transitionDuration: const Duration(milliseconds: 200), //Duration.zero,
        transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
      ),
    );
  }
}
