import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_catalog/Model/ModelChar/ChartModel.dart';
import 'package:my_catalog/Model/Orders.dart';
import 'package:my_catalog/Shared/checkbox_ui.dart';
import 'package:my_catalog/Shared/dropdown_Input_ul.dart';
import 'package:my_catalog/Styles/styles.dart';
import 'package:my_catalog/Utils/helpers.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';


class FilterBar extends StatefulWidget {
  final Function(dynamic value)? onDateRange;
  final Function(bool value)? onDiscount;
  final Function(bool value)? onReturn;
  final Function(dynamic value)? onSelect;
  final VoidCallback onTap;
  final String year;
  FilterBar({ Key? key, required this.year, this.onDateRange, required this.onTap, this.onDiscount, this.onReturn, this.onSelect}) : super(key: key);

  @override
  _FilterBarState createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {

  List<Selects> selects = [];

  late dynamic selectValue = widget.year;


  @override
  void initState() {
    for(int i = 0; i < years.length; i++){
      selects.add(
          Selects(
              key: i,
              value: '${years[i]}',
              label: '${years[i]}',
         ));
    }
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
          Container(
            padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
            child:  DropdownInputUl(
              options: selects,
              placeholder: 'Выберите год',
              value: selectValue,
              label: 'Отчет по годам',
              onChanged: (value) {
                setState(() {
                  selectValue = value;
                });
                widget.onSelect!(selectValue);
              },
              // getEmpty: (dynamic value) => value,
            ),
          ),

          // ElevatedButton(onPressed: () => widget.onTap(),
          // child: const Text("Применить")),
        const SizedBox(
          height: 10.0,
        )
      ],);
  }
}
